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
## Set up clusters - this will make things faster
#UseCores <- detectCores() -2 #leaving 2
#cl = makeCluster(UseCores)
#registerDoParallel(cl)
Comp_extc = data.frame()
# Iterate through rasters and clip each watershed to all rasters
#beginCluster(cl)
#par = foreach(a = 1:length(Components)) %dopar% {

  library(raster)
  library(sf)
  for (i in 1:length(files)) {
    
    LUtif_folders = paste0(INPUT_folders,'1 Land Use Data/', files[i])
    YEAR_i = readr::parse_number(files[1])
    #R = raster(tif_folder)
    R = terra::rast(LUtif_folders)
    
    # Replacing 0s with NA
    temp = values(R)
    temp = as.matrix(temp)
    temp[temp == 0] = NA
    temp <- as.data.frame(temp)
    
    values(R) = temp

    for (j in 1:dim(HUC2)[1]) {

        clipped_raster = terra::crop(R,extent(HUC2[j,]))
        temp2 = terra::extract(clipped_raster, HUC2[j,], fun=sum, na.rm=TRUE, df=TRUE)

        Comp_extc[j,1] = HUC2[j,]$REG
        Comp_extc[j,i+1] = temp2[2]
    }
  }
  colnames(Comp_extc)[1] ="REG"
  write.table(Comp_extc, file = paste0(OUTPUT_folders, ComponentsName[a],
                                      '_meanHUC2LandUse.txt'), row.names = FALSE)
#}

#stopCluster(cl)
