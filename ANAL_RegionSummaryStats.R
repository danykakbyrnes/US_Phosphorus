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

shpINPUT_folders = '9 Phopshorus Use Efficiency/INPUTS_103122/0 General Data/CensusRegions/CensusRegions_20230122.shp'
tifINPUT_folders = 'D:/Danyka/3 TREND_Nutrients/TREND_Nutrients/OUTPUTS/Grid_TREND_P_Version_1/TREND-P Postpocessed Gridded/CropUptake_Agriculture_Agriculture_LU/'
OUTPUT_folders = '9 Phopshorus Use Efficiency/OUTPUTS/SummaryFiles/'

# read in HUC8 files
shp = sf::read_sf(shptifINPUT_folders)
Comp_extc = data.frame()
Comp_extc2 = data.frame()
## MEAN ########################################################################
tif_folders = paste0(tifINPUT_folders, YEARS[i],'.tif')

R = terra::rast(tif_folders) # NaN are treated same was as NA.
  
for (j in 1:dim(shp)[1]) {
    
    clipped_raster = terra::crop(R,extent(shp[j,]))
    temp2 = terra::extract(clipped_raster, shp[j,], fun=sum, na.rm=TRUE, df=TRUE)
    
    Comp_extc[j,1] = shp[j,]$REG
    Comp_extc[j,i+1] = temp2[2]
}

colnames(Comp_extc)[1] ="REG"
write.table(Comp_extc, file = paste0(OUTPUT_folders, 
                                     'PUE_meanHUC2_fromgrid.txt'), row.names = FALSE)