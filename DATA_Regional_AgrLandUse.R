# Clipping agricultural land use to Regions
library(snow)
library(raster)
library(tidyverse)
library(sf)

setwd("B:/LabFiles/users/DanykaByrnes/")

# Setting up filepaths
YEARS = 1930:2017
INPUT_folders = '9_Phosphorus_Use_Efficiency/INPUTS_103122/'
OUTPUT_folders = '9_Phosphorus_Use_Efficiency/OUTPUTS/HUC2/'
HUC2_loc = '0_General_Data/HUC2/'

# Read in Region shapefile files
Regions = sf::read_sf(paste0(INPUT_folders, HUC2_loc,'merged_HUC2_5070_v3.shp'))
files = dir(paste0(INPUT_folders,'/1_Land_Use_Data/'))

LU_extc = data.frame()

  for (i in 1:length(files)) {
    
    LUtif_folders = paste0(INPUT_folders,'1_Land_Use_Data/', files[i])
    YEAR_i = readr::parse_number(files[i])
    R = terra::rast(LUtif_folders)

    for (j in 1:dim(Regions)[1]) {
        
        # summing the binary file to get all the cropland
        clipped_raster = terra::crop(R,
                                     extent(Regions[j,]))
        AgLand = terra::extract(clipped_raster, 
                                Regions[j,], 
                                fun=sum, 
                                na.rm=TRUE, 
                                df=TRUE)
        
        # replacing all the non-cropland (0) with 1 
        temp = values(clipped_raster)
        temp = as.matrix(temp)
        temp[temp == 0] = 1 # replacing all the numbers with 1 so I can get total area.
        temp <- as.data.frame(temp)
        values(clipped_raster) = temp
        
        # Summing total cropland
        TotalLand = terra::extract(clipped_raster, Regions[j,], fun=sum, na.rm=TRUE, df=TRUE)
        
        # Column 1 is HUC, Column 2 is year, column 3 is AG, Col 4 is total
        row = dim(LU_extc)[1]+1
        LU_extc[row,1] = Regions[j,]$REG
        LU_extc[row,2] = YEAR_i
        LU_extc[row,3] = as.numeric(AgLand[2])
        LU_extc[row,4] = as.numeric(TotalLand[2])
        LU_extc[row,5] = as.numeric(AgLand[2])/as.numeric(TotalLand[2])
    }
  }
  colnames(LU_extc) =c("REG", 'YEAR',"AG_cells", 'Tot_cells', 'FracAgLU')
  
  # Sort by Year then HUC
  LU_extc = dplyr::arrange(LU_extc, YEAR, REG)
  write.table(LU_extc, 
              file = paste0(OUTPUT_folders,'RegionLandUse_tif.txt'), 
              row.names = FALSE)
  