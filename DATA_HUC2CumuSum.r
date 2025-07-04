# Clipping HUC2 Watershed to P components
library(foreach)
library(doParallel)
library(snow)
library(raster)
library(tidyverse)
library(sf)
library(terra)

setwd("B:/LabFiles/users/DanykaByrnes/")

# Setting the years of analysis
YEARS = c(1980, 2017)

# Setting up filepaths
HUC2INPUT_folders = '9_Phosphorus_Use_Efficiency/INPUTS_051523/'
INPUT_folders = '9_Phosphorus_Use_Efficiency/OUTPUTS/Cumulative_Phosphorus/'
OUTPUT_folders = '9_Phosphorus_Use_Efficiency/OUTPUTS/HUC2/'

# read in HUC8 files
HUC2 = sf::read_sf(paste0(HUC2INPUT_folders, '0_General_Data/HUC2/merged_HUC2_5070_v3.shp'))
Comp_extc = data.frame()
Comp_extc2 = data.frame()

  for (i in 1:length(YEARS)) {
    tif_folders = paste0(INPUT_folders, 'CumSum_', YEARS[i],'.tif')
    R = terra::rast(tif_folders) # NaN are treated same was as NA.
    
    for (j in 1:dim(HUC2)[1]) {

      medianMask = terra::mask(R, HUC2[j,], inverse=FALSE)
      maskDf1 = as.data.frame(medianMask, na.rm = TRUE) # this removes all NaNs
      temp3 = median(unlist(maskDf1), na.rm = TRUE)
      
      Comp_extc2[j,1] = HUC2[j,]$REG
      Comp_extc2[j,i+1] = temp3
    }
  }
  
# Save median  
colnames(Comp_extc2) = c("REG", "CumSum_1980", "CumSum_2017")
write.table(Comp_extc2, 
            file = paste0(OUTPUT_folders,'CumSum_medianHUC2_fromgrid.txt'), 
            row.names = FALSE)