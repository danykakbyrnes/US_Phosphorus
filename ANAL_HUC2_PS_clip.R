# Clipping HUC2 Watershed to P components
library(foreach)
library(doParallel)
library(snow)
library(raster)
library(tidyverse)
library(sf)
library(terra)

setwd("B:/LabFiles/users/DanykaByrnes/")

# ******************************************************************************
# This script takes the N Surplus data and clips the watersheds with the data. 
# The result is a text file with the mean and median of the components for each 
# HUC2 watershed.

# ******************************************************************************

# Setting up filepaths
YEARS = 1930:2017
INPUT_folders = '9_Phosphorus_Use_Efficiency/INPUTS_051523/'
OUTPUT_folders = '9_Phosphorus_Use_Efficiency/OUTPUTS/HUC2/'
NSURPLUS_OUTPUT_folders = '3_TREND_Nutrients/TREND_Nutrients/OUTPUT/Grid_TREND_P_Version_1/TREND-P_Postpocessed_Gridded_2023-11-18/'
HUC2_loc = '0_General_Data/HUC2/'
ComponentsName = c('Lvsk', 'Fert', 'Crop', 'Ag_Surplus')
Components = c('Lvst_Agriculture_LU/Lvst_', 
               'Fertilizer_Agriculture_Agriculture_LU/Fertilizer_Ag_', 
               'CropUptake_Agriculture_Agriculture_LU/CropUptake_',
               'Ag_Surplus/AgSurplus_')

# read in HUC8 files
HUC2 = sf::read_sf(paste0(INPUT_folders, HUC2_loc,'merged_HUC2_5070_v3.shp'))

# Set up clusters - this will make things faster
UseCores <- detectCores() - 18 #leaving half
cl = makeCluster(UseCores)
registerDoParallel(cl)

Comp_extc = data.frame()
Comp_extc2 = data.frame()

# Iterate through rasters and clip each watershed to all rasters
beginCluster(cl)
results <- foreach(a = 1:length(Components), 
                   .packages = c("sf", "terra", "raster"),
                   .combine = 'list',
                   .multicombine = TRUE,
                   .errorhandling = 'pass') %dopar% {
#for (a in 1:length(Components)) {

  for (i in 1:length(YEARS)) {
    tif_folders = paste0(NSURPLUS_OUTPUT_folders, Components[a], YEARS[i],'.tif')
    #R = raster(tif_folder)
    R = terra::rast(tif_folders)
    
    # Replacing 0s with NA
    temp = values(R)
    temp = as.matrix(temp)
    temp[temp == 0] = NA
    temp <- as.data.frame(temp)
    
    values(R) = temp

    for (j in 1:dim(HUC2)[1]) {

        temp2 = terra::extract(R, HUC2[j,], fun=mean, na.rm=TRUE)
        Comp_extc[j,1] = HUC2[j,]$REG
        Comp_extc[j,i+1] = temp2[2]
        
        medianMask = terra::mask(R, HUC2[j,], inverse=FALSE)
        maskDf1 = as.data.frame(medianMask, na.rm = TRUE) # this removes all NaNs
        temp3 = median(unlist(maskDf1), na.rm = TRUE)
        #temp3 = apply(maskDf1,2,median)
        Comp_extc2[j,1] = HUC2[j,]$REG
        Comp_extc2[j,i+1] = temp3
    }
  }
  colnames(Comp_extc)[1] ="REG"
  write.table(Comp_extc, file = paste0(OUTPUT_folders, 
                                       ComponentsName[a],
                                      '_meanHUC2Components.txt'), 
              row.names = FALSE)
  
  colnames(Comp_extc2) <- colnames(Comp_extc)
  write.table(Comp_extc2, file = paste0(OUTPUT_folders, 
                                        ComponentsName[a],
                                       '_medianHUC2Components.txt'), 
              row.names = FALSE)
}

stopCluster(cl)