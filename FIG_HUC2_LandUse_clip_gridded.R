# Clipping HUC2 Watershed to P components
library(foreach)
library(doParallel)
library(snow)
library(raster)
library(tidyverse)
library(sf)

setwd("D:/Danyka/")

# ******************************************************************************
# This script takes the N Surplus data and clips the watersheds with the data. 
# The result is a shapefile with the countries clipped and an extra column that
# calculates the fraction of the county that is within the watershed boundary. 
# This later gets aggregated in the FigureGeneration.mat

# ******************************************************************************
# Setting up filepaths
YEARS = 1930:2017
INPUT_folders = '9 Phopshorus Use Efficiency/INPUTS_103122/'
OUTPUT_folders = '9 Phopshorus Use Efficiency/OUTPUTS/HUC2/'
HUC2_loc = '0 General Data/HUC2/'

# read in HUC8 files
HUC2 = sf::read_sf(paste0(INPUT_folders, HUC2_loc,'merged_HUC2_5070_v3.shp'))

files = dir(paste0(INPUT_folders,'/1 Land Use Data/'))

LU_extc = data.frame()


  for (i in 1:length(files)) {
    
    LUtif_folders = paste0(INPUT_folders,'1 Land Use Data/', files[i])
    YEAR_i = readr::parse_number(files[i])
    #R = raster(tif_folder)
    R = terra::rast(LUtif_folders)

    for (j in 1:dim(HUC2)[1]) {
        
        # summing the binary file to get all the cropland
        clipped_raster = terra::crop(R,extent(HUC2[j,]))
        AgLand = terra::extract(clipped_raster, HUC2[j,], fun=sum, na.rm=TRUE, df=TRUE)
        
        # replacing all the non-cropland (0) with 1 
        temp = values(clipped_raster)
        temp = as.matrix(temp)
        temp[temp == 0] = 1 # replacing all the numbers with 1 so I can get total area.
        temp <- as.data.frame(temp)
        values(clipped_raster) = temp
        
        # Summing total cropland
        TotalLand = terra::extract(clipped_raster, HUC2[j,], fun=sum, na.rm=TRUE, df=TRUE)
        
        # Column 1 is HUC, Column 2 is year, column 3 is AG, Col 4 is total
        row = dim(LU_extc)[1]+1
        LU_extc[row,1] = HUC2[j,]$REG
        LU_extc[row,2] = YEAR_i
        LU_extc[row,3] = as.numeric(AgLand[2])
        LU_extc[row,4] = as.numeric(TotalLand[2])
        LU_extc[row,5] = as.numeric(AgLand[2])/as.numeric(TotalLand[2])
    }
  }
  colnames(LU_extc) =c("REG", 'YEAR',"AG_cells", 'Tot_cells', 'FracAgLU')
  
  # Sort by Year then HUC
  LU_extc = dplyr::arrange(LU_extc, YEAR, REG)
  write.table(LU_extc, file = paste0(OUTPUT_folders,'HUC2LandUse_tif.txt'), row.names = FALSE)
  