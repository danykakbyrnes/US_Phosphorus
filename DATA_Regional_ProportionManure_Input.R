# Clipping Proportion of total inputs from manure to each region
library(raster)
library(tidyverse)
library(sf)
library(terra)

load_dot_env()

# Setting the years of analysis
YEARS = c(1980, 2017)

# Setting up filepaths
Regional_filepath = Sys.getenv("REGIONSHP_FILEPATH")
INPUT_folders = Sys.getenv("POSTPROCESSED_TREND")
OUTPUT_folders = Sys.getenv("REGIONAL_ANALYSIS")

RegionalShp_filepath = 'Regions/HUC2_Merged_Regions.shp'

ComponentsName = c('Lvsk', 'Fert', 'Crop')
Components = c('Lvst_Agriculture_LU/Lvst_', 
               'Fertilizer_Agriculture_Agriculture_LU/Fertilizer_Ag_', 
               'CropUptake_Agriculture_Agriculture_LU/CropUptake_')

# read in Region shapefile
Regions = sf::read_sf(paste0(Regional_filepath, RegionalShp_filepath))

MeanRegion = data.frame()
MedianRegion = data.frame()

  for (i in 1:length(YEARS)) {
    Lvstk_tif_folders = paste0(INPUT_folders, Components[1], YEARS[i],'.tif')
    Fert_tif_folders = paste0(INPUT_folders, Components[2], YEARS[i],'.tif')
    Crop_tif_folders = paste0(INPUT_folders, Components[3], YEARS[i],'.tif')
    
    Lvstk_tif = terra::rast(Lvstk_tif_folders) # NaN are treated same was as NA.
    Fert_tif = terra::rast(Fert_tif_folders) # NaN are treated same was as NA.
    Crop_tif = terra::rast(Crop_tif_folders) # NaN are treated same was as NA.
    
    for (j in 1:dim(Regions)[1]) {
      
      clipped_raster = terra::crop(PCT_MANU_IN,extent(Regions[j,]))
      temp2 = terra::extract(clipped_raster, 
                             Regions[j,],
                             fun=mean,
                             na.rm=TRUE)
      
      MeanRegion[j,1] = Regions[j,]$REG
      MeanRegion[j,i+1] = temp2[2]
      
      medianMask = terra::mask(clipped_raster, Regions[j,], inverse=FALSE)
      maskDf1 = as.data.frame(medianMask)
      temp3 = apply(maskDf1,2,median)
      MedianRegion[j,1] = Regions[j,]$REG
      MedianRegion[j,i+1] = temp3
    }
  }
  ColNames = paste0("Lvstk_in_", 1930:2017)
  colnames(MeanRegion)[1] = "REG"
  colnames(MeanRegion)[2:ncol(MeanRegion)] = ColNames
  write.table(MeanRegion, 
              file = paste0(OUTPUT_folders,'Prop_Manure_In_meanRegion.txt'),
              row.names = FALSE)
  colnames(MedianRegion)[1] ="REG"
  colnames(MedianRegion)[2:ncol(MedianRegion)] = ColNames
  write.table(MedianRegion, 
              file = paste0(OUTPUT_folders,'Prop_Manure_In_medianRegion.txt'),
              row.names = FALSE)
  