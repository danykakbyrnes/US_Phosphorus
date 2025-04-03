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
# The result is a shapefile with the countries clipped and an extra column that
# calculates the fraction of the county that is within the watershed boundary. 
# This later gets aggregated in the FigureGeneration.mat

# ******************************************************************************
# Setting up filepaths
YEARS = 1930:2017

INPUT_folders = '9_Phosphorus_Use_Efficiency/INPUTS_051523/'
OUTPUT_folders = '9_Phosphorus_Use_Efficiency/OUTPUTS/HUC2/'
NSURPLUS_OUTPUT_folders = '3_TREND_Nutrients/TREND_Nutrients/OUTPUT/Grid_TREND_P_Version_1/TREND-P_Postpocessed_Gridded_2023-11-18/'
HUC2_loc = '0_General_Data/HUC2/'
ComponentsName = c('Lvsk', 'Fert', 'Crop')
Components = c('Lvst_Agriculture_LU/Lvst_', 
               'Fertilizer_Agriculture_Agriculture_LU/Fertilizer_Ag_', 
               'CropUptake_Agriculture_Agriculture_LU/CropUptake_')
OUTPUT_folders = '9_Phosphorus_Use_Efficiency/OUTPUTS/HUC2/'

# read in HUC8 files
HUC2 = sf::read_sf(paste0(INPUT_folders, '0_General_Data/HUC2/merged_HUC2_5070_v3.shp'))
Comp_extc = data.frame()
Comp_extc2 = data.frame()

  for (i in 1:length(YEARS)) {
    Lvstk_tif_folders = paste0(NSURPLUS_OUTPUT_folders, Components[1], YEARS[i],'.tif')
    Fert_tif_folders = paste0(NSURPLUS_OUTPUT_folders, Components[2], YEARS[i],'.tif')
    Crop_tif_folders = paste0(NSURPLUS_OUTPUT_folders, Components[3], YEARS[i],'.tif')
    
    Lvstk_tif = terra::rast(Lvstk_tif_folders) # NaN are treated same was as NA.
    Fert_tif = terra::rast(Fert_tif_folders) # NaN are treated same was as NA.
    Crop_tif = terra::rast(Crop_tif_folders) # NaN are treated same was as NA.
    
    PCT_MANU_IN = Lvstk_tif/(Fert_tif+Lvstk_tif)
    for (j in 1:dim(HUC2)[1]) {
      
      clipped_raster = terra::crop(PCT_MANU_IN,extent(HUC2[j,]))
      temp2 = terra::extract(clipped_raster, HUC2[j,], fun=mean, na.rm=TRUE)
      
      Comp_extc[j,1] = HUC2[j,]$REG
      Comp_extc[j,i+1] = temp2[2]
      
      medianMask = terra::mask(clipped_raster, HUC2[j,], inverse=FALSE)
      maskDf1 = as.data.frame(medianMask)
      temp3 = apply(maskDf1,2,median)
      Comp_extc2[j,1] = HUC2[j,]$REG
      Comp_extc2[j,i+1] = temp3
    }
  }
  ColNames = c(1930:2017)
  colnames(Comp_extc)[1] ="REG"
  colnames(Comp_extc)[2:ncol(Comp_extc)] = ColNames
  write.table(Comp_extc, 
              file = paste0(OUTPUT_folders,'PCT_Manure_In_meanHUC2_fromgrid.txt'),
              row.names = FALSE)
  colnames(Comp_extc2)[1] ="REG"
  colnames(Comp_extc2)[2:ncol(Comp_extc2)] = ColNames
  write.table(Comp_extc2, 
              file = paste0(OUTPUT_folders,'PCT_Manure_In_medianHUC2_fromgrid.txt'),
              row.names = FALSE)
  