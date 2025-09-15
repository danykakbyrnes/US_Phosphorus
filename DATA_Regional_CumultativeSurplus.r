# Clipping cumulative surplus to Regions
library(raster)
library(tidyverse)
library(sf)
library(terra)
library(dotenv)

load_dot_env()

# Setting the years of analysis
YEARS = c(1980, 2017)

# Setting up filepaths
Regional_filepath = Sys.getenv("REGIONSHP_FILEPATH")
INPUT_folders = Sys.getenv("CUMULATIVE_PHOS")
OUTPUT_folders = Sys.getenv("REGIONAL_ANALYSIS")

# read in Region shapefile
Regions = sf::read_sf(paste0(Regional_filepath, 'HUC2_Merged_Regions.shp'))
MedianRegion = data.frame()

  for (i in 1:length(YEARS)) {
    tif_folders = paste0(INPUT_folders, 'CumSum_', YEARS[i],'.tif')
    R = terra::rast(tif_folders) # NaN are treated same was as NA.
    
    for (j in 1:dim(Regions)[1]) {

      medianMask = terra::mask(R, Regions[j,], 
                               inverse=FALSE)
      maskDf1 = as.data.frame(medianMask, 
                              na.rm = TRUE) # this removes all NaNs
      temp3 = median(unlist(maskDf1), na.rm = TRUE)
      
      MedianRegion[j,1] = Regions[j,]$REG
      MedianRegion[j,i+1] = temp3
    }
  }
  
# Save median  
colnames(MedianRegion) = c("REG", "CumSum_1980", "CumSum_2017")
write.table(MedianRegion, 
            file = paste0(OUTPUT_folders,'CumuSum_medianRegion.txt'), 
            row.names = FALSE)