# Clipping P components to regions
library(raster)
library(tidyverse)
library(sf)
library(terra)
library(dotenv)

load_dot_env()

# Setting up filepaths
Regional_filepath = Sys.getenv("REGIONSHP_FILEPATH")
TREND_OUTPUT_folder = Sys.getenv("POSTPROCESSED_TREND")
PUE_OUTPUT_folder = Sys.getenv("PHOS_USE_EFFICIENCY")
ASURP_OUTPUT_folder = Sys.getenv("AG_SURPLUS")
OUTPUT_folder = Sys.getenv("REGIONAL_ANALYSIS")

# Select which gTREND components to be clipped. 
ComonentsName = c('Lvsk', 'Fert', 'Crop', 'Ag_Surplus')
Components = c('Lvst_Agriculture_LU/Lvst_', 
               'Fertilizer_Agriculture_Agriculture_LU/Fertilizer_Ag_', 
               'CropUptake_Agriculture_Agriculture_LU/CropUptake_',
               'Ag_Surplus/Ag_Surplus_')

# read in Region shapefile files
Regions = sf::read_sf(paste0(Regional_filepath, 'HUC2_Merged_Regions.shp'))

YEARS = 1930:2017
for (a in 1:length(Components)) {
  
  # Creating empty dataframe to populate
  MeanRegion = data.frame()
  MedianRegion = data.frame()
  
  for (i in 1:length(YEARS)) {
    tif_folder = paste0(TREND_OUTPUT_folder, Components[a], YEARS[i],'.tif')
    R = terra::rast(tif_folder)
    
    # Replacing 0s with NA becaus we don't want 0s in our calculation
    temp = values(R)
    temp = as.matrix(temp)
    temp[temp == 0] = NA
    temp = as.data.frame(temp)
    values(R) = temp

    for (j in 1:dim(Regions)[1]) {
        # Calculating the mean for jth region
        mean_val = terra::extract(R, 
                                  Regions[j,],
                                  fun=mean,
                                  na.rm=TRUE)
        MeanRegion[j,1] = Regions[j,]$REG
        MeanRegion = mean_val[2]
        
        # Calculating the median for jth region
        RegionMask = terra::mask(R,
                               Regions[j,],
                               inverse=FALSE)
        maskDF = as.data.frame(RegionMask, 
                               na.rm = TRUE) # removes all NaNs
        median_val = median(unlist(maskDF), 
                            na.rm = TRUE)
        
        MedianRegion[j,1] = Regions[j,]$REG
        MedianRegion[j,i+1] = median_val
    }
  }
  colnames(MeanRegion)[1] ="REG"
  write.table(MeanRegion, 
              file = paste0(OUTPUT_folder,ComponentsName[a],'_meanRegionComponents.txt'), 
              row.names = FALSE)
  
  colnames(MedianRegion) = colnames(MeanRegion)
  write.table(MedianRegion, 
              file = paste0(OUTPUT_folder,ComponentsName[a],'_medianRegionComponents.txt'), 
              row.names = FALSE)
}

## Now processing PUE at the regional scale. 
# Creating empty dataframe to populate
MeanRegion = data.frame()
MedianRegion = data.frame()

for (i in 1:length(YEARS)) {
  tif_folder = paste0(PUE_OUTPUT_folder, 'PUE_', YEARS[i],'.tif')
  R = terra::rast(tif_folder)
    
    # Removing 0s (PUE doesn't have 0 values, but implementing as a fail safe)
    temp = values(R)
    temp = as.matrix(temp)
    temp[temp == 0] = NA
    temp = as.data.frame(temp)
    values(R) = temp
    
    for (j in 1:dim(Regions)[1]) {
      # Calculating the mean for jth region
      mean_val = terra::extract(R, 
                                Regions[j,],
                                fun=mean,
                                na.rm=TRUE)
      MeanRegions[j,1] = Regions[j,]$REG
      MeanRegions[j,i+1] = mean_val[2]
      
      # Calculating the median for jth region
      RegionMask = terra::mask(R,
                             Regions[j,],
                             inverse=FALSE)
      maskDF = as.data.frame(RegionMask, 
                             na.rm = TRUE) # removes all NaNs
      median_val = median(unlist(maskDF), 
                          na.rm = TRUE)
      
      MedianRegion[j,1] = Regions[j,]$REG
      MedianRegion[j,i+1] = median_val
    }
  }
  colnames(MeanRegion)[1] ="REG"
  write.table(MeanRegion, 
              file = paste0(OUTPUT_folder,'PUE_meanRegion_fromgrid.txt'), 
              row.names = FALSE)
  
  colnames(MedianRegion) = colnames(MeanRegion)
  write.table(MedianRegion, 
              file = paste0(OUTPUT_folder,'PUE_medianRegion_fromgrid.txt'), 
              row.names = FALSE)