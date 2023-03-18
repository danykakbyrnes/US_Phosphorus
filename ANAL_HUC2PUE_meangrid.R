# Clipping HUC2 Watershed to P components
library(foreach)
library(doParallel)
library(snow)
library(raster)
library(tidyverse)
library(sf)
library(terra)

setwd("D:/Danyka/")

# ******************************************************************************
# This script takes the N Surplus data and clips the watersheds with the data. 
# The result is a shapefile with the countries clipped and an extra column that
# calculates the fraction of the county that is within the watershed boundary. 
# This later gets aggregated in the FigureGeneration.mat

# ******************************************************************************
# Setting up filepaths
YEARS = 1930:2017

HUC2INPUT_folders = '9 Phopshorus Use Efficiency/INPUTS_103122/'
INPUT_folders = '9 Phopshorus Use Efficiency/OUTPUTS/PUE/'
OUTPUT_folders = '9 Phopshorus Use Efficiency/OUTPUTS/HUC2/'

#ComponentsName = c('Lvsk', 'Fert', 'Crop')
#Components = c('Lvst_Agriculture_LU/Lvst_', 
#               'Fertilizer_Agriculture_Agriculture_LU/Fertilizer_Ag_', 
#               'CropUptake_Agriculture_Agriculture_LU/CropUptake_Ag_')
#
# read in HUC8 files
HUC2 = sf::read_sf(paste0(HUC2INPUT_folders, '0 General Data/HUC2/merged_HUC2_5070_v3.shp'))
Comp_extc = data.frame()
Comp_extc2 = data.frame()
## MEAN ########################################################################
  for (i in 1:length(YEARS)) {
    tif_folders = paste0(INPUT_folders, 'PUE_', YEARS[i],'.tif')
    #R = raster(tif_folder)
    R = terra::rast(tif_folders) # NaN are treated same was as NA.
    
    for (j in 1:dim(HUC2)[1]) {
      
      clipped_raster = terra::crop(R,extent(HUC2[j,]))
      temp2 = terra::extract(clipped_raster, HUC2[j,], fun=mean, na.rm=TRUE, df=TRUE)
      
      Comp_extc[j,1] = HUC2[j,]$REG
      Comp_extc[j,i+1] = temp2[2]
      
      medianMask = terra::mask(clipped_raster, HUC2[j,], inverse=FALSE)
      maskDf1 = as.data.frame(medianMask)
      temp3 = apply(maskDf1,2,median)
      Comp_extc2[j,1] = HUC2[j,]$REG
      Comp_extc2[j,i+1] = temp3/1000
    }
  }
  colnames(Comp_extc)[1] ="REG"
  write.table(Comp_extc, file = paste0(OUTPUT_folders, 
                                      'PUE_meanHUC2_fromgrid.txt'), row.names = FALSE)
  colnames(Comp_extc2)[1] ="REG"
  write.table(Comp_extc2, file = paste0(OUTPUT_folders, 
                                       'PUE_medianHUC2_fromgrid.txt'), row.names = FALSE)
  