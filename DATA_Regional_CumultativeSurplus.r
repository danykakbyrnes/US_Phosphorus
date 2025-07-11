# Clipping cumulative surplus to Regions
library(raster)
library(tidyverse)
library(sf)
library(terra)
library(dotenv)

load_dot_env(".env")

# Setting the years of analysis
YEARS = c(1980, 2017)

# Setting up filepaths
GenINPUT_folders = Sys.getenv("GENERAL_INPUT")
INPUT_folders = Sys.getenv("CUMULATIVE_PHOS")
OUTPUT_folders = Sys.getenv("REGIONAL_ANALYSIS")
RegionalShp_filepath = 'HUC2/merged_HUC2_5070_v3.shp'

# read in HUC8 files
Regions = sf::read_sf(paste0(GenINPUT_folders, RegionalShp_filepath))
Comp_extc = data.frame()
Comp_extc2 = data.frame()

  for (i in 1:length(YEARS)) {
    tif_folders = paste0(INPUT_folders, 'CumSum_', YEARS[i],'.tif')
    R = terra::rast(tif_folders) # NaN are treated same was as NA.
    
    for (j in 1:dim(Regions)[1]) {

      medianMask = terra::mask(R, Regions[j,], 
                               inverse=FALSE)
      maskDf1 = as.data.frame(medianMask, 
                              na.rm = TRUE) # this removes all NaNs
      temp3 = median(unlist(maskDf1), na.rm = TRUE)
      
      Comp_extc2[j,1] = Regions[j,]$REG
      Comp_extc2[j,i+1] = temp3
    }
  }
  
# Save median  
colnames(Comp_extc2) = c("REG", "CumSum_1980", "CumSum_2017")
write.table(Comp_extc2, 
            file = paste0(OUTPUT_folders,'CumSum_medianHUC2_fromgrid.txt'), 
            row.names = FALSE)