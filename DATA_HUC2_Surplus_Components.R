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
# This script takes the P Surplus data and clips the watersheds with the data. 
# The result is a text file with the mean and median of the components for each 
# HUC2 watershed.
# ******************************************************************************

# Setting up filepaths
YEARS = 1930:2017
INPUT_folders = '9_Phosphorus_Use_Efficiency/INPUTS_051523/'
OUTPUT_folders = '9_Phosphorus_Use_Efficiency/OUTPUTS/HUC2/'
PSURPLUS_OUTPUT_folders = '3_TREND_Nutrients/TREND_Nutrients/OUTPUT/Grid_TREND_P_Version_1/TREND-P_Postpocessed_Gridded_2023-11-18/'
PUE_OUTPUT_folders = '9 Phosphorus Use Efficiency/OUTPUTS/PUE/'
HUC2_filepath = '0_General_Data/HUC2/'

# Select which gTREND components to be clipped. 
ComonentsName = c('Lvsk', 'Fert', 'Crop', 'Ag_Surplus')
Components = c('Lvst_Agriculture_LU/Lvst_', 
               'Fertilizer_Agriculture_Agriculture_LU/Fertilizer_Ag_', 
               'CropUptake_Agriculture_Agriculture_LU/CropUptake_',
               'Ag_Surplus/AgSurplus_')

# read in HUC8 files
HUC2 = sf::read_sf(paste0(INPUT_folders,HUC2_filepath,'merged_HUC2_5070_v3.shp'))

for (a in 1:length(Components)) {
  
  # Creating empty dataframe to populate
  MeanHUC2 = data.frame()
  MedianHUC2 = data.frame()
  
  for (i in 1:length(YEARS)) {
    tif_folders = paste0(PSURPLUS_OUTPUT_folders,Components[a], YEARS[i],'.tif')
    R = terra::rast(tif_folders)
    
    # Replacing 0s with NA becaus we don't want 0s in our calculation
    temp = values(R)
    temp = as.matrix(temp)
    temp[temp == 0] = NA
    temp = as.data.frame(temp)
    values(R) = temp

    for (j in 1:dim(HUC2)[1]) {
        # Calculating the mean for jth HUC2 watershed
        mean_val = terra::extract(R, 
                                  HUC2[j,],
                                  fun=mean,
                                  na.rm=TRUE)
        MeanHUC2[j,1] = HUC2[j,]$REG
        MeanHUC2[j,i+1] = mean_val[2]
        
        # Calculating the median for jth HUC2 watershed
        HUC2Mask = terra::mask(R,
                               HUC2[j,],
                               inverse=FALSE)
        maskDF = as.data.frame(HUC2Mask, 
                               na.rm = TRUE) # removes all NaNs
        median_val = median(unlist(maskDF), 
                            na.rm = TRUE)
        
        MedianHUC2[j,1] = HUC2[j,]$REG
        MedianHUC2[j,i+1] = median_val
    }
  }
  colnames(MeanHUC2)[1] ="REG"
  write.table(MeanHUC2, file = paste0(OUTPUT_folders, 
                                       ComponentsName[a],
                                      '_meanHUC2Components.txt'), 
              row.names = FALSE)
  
  colnames(MedianHUC2) <- colnames(MeanHUC2)
  write.table(MedianHUC2, file = paste0(OUTPUT_folders, 
                                        ComponentsName[a],
                                       '_medianHUC2Components.txt'), 
              row.names = FALSE)
}

## Now processing PUE at the regional scale. 

# Creating empty dataframe to populate
MeanHUC2 = data.frame()
MedianHUC2 = data.frame()

for (i in 1:length(YEARS)) {
  tif_folders = tif_folders = paste0(PUE_OUTPUT_folders, 'PUE_', YEARS[i],'.tif')
  R = terra::rast(tif_folders)
    
    # Removing 0s (PUE doesn't have 0 values, but implementing as a fail safe)
    temp = values(R)
    temp = as.matrix(temp)
    temp[temp == 0] = NA
    temp = as.data.frame(temp)
    values(R) = temp
    
    for (j in 1:dim(HUC2)[1]) {
      # Calculating the mean for jth HUC2 watershed
      mean_val = terra::extract(R, 
                                HUC2[j,],
                                fun=mean,
                                na.rm=TRUE)
      MeanHUC2[j,1] = HUC2[j,]$REG
      MeanHUC2[j,i+1] = mean_val[2]
      
      # Calculating the median for jth HUC2 watershed
      HUC2Mask = terra::mask(R,
                             HUC2[j,],
                             inverse=FALSE)
      maskDF = as.data.frame(HUC2Mask, 
                             na.rm = TRUE) # removes all NaNs
      median_val = median(unlist(maskDF), 
                          na.rm = TRUE)
      
      MedianHUC2[j,1] = HUC2[j,]$REG
      MedianHUC2[j,i+1] = median_val
    }
  }
  colnames(MeanHUC2)[1] ="REG"
  write.table(MeanHUC2, file = paste0(OUTPUT_folders, 
                                      'PUE_meanHUC2_fromgrid'), 
              row.names = FALSE)
  
  colnames(MedianHUC2) <- colnames(MeanHUC2)
  write.table(MedianHUC2, file = paste0(OUTPUT_folders, 
                                        'PUE_medianHUC2_fromgrid'), 
              row.names = FALSE)