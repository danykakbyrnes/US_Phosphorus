# Clipping agricultural land use to Regions
library(raster)
library(tidyverse)
library(sf)
library(dotenv)

load_dot_env(".env")

# Setting up filepaths
Regional_filepath = Sys.getenv("REGIONSHP_FILEPATH")
LUINPUT_folders = Sys.getenv("LANDUSE_INPUT")
OUTPUT_folders = Sys.getenv("REGIONAL_ANALYSIS")

# Read in Region shapefile files
Regions = sf::read_sf(paste0(Regional_filepath, 'HUC2_Merged_Regions.shp'))
files = dir(LUINPUT_folders)

YEARS = 1930:2017
LU_extc = data.frame()

  for (i in 1:length(files)) {
    
    LUtif_folders = paste0(LUINPUT_folders, files[i])
    YEAR_i = readr::parse_number(files[i])
    R = terra::rast(LUtif_folders)

    for (j in 1:dim(Regions)[1]) {
        
        # summing the binary file to get all the cropland
        clipped_raster = terra::crop(R,
                                     extent(Regions[j,]))
        AgLand = terra::extract(clipped_raster, 
                                Regions[j,], 
                                fun=sum, 
                                na.rm=TRUE)
        
        # Replacing all the non-cropland (0) with 1 to get total area
        temp = values(clipped_raster)
        temp = as.matrix(temp)
        temp[temp == 0] = 1
        temp <- as.data.frame(temp)
        values(clipped_raster) = temp
        
        # Summing total cropland
        TotalLand = terra::extract(clipped_raster, 
                                   Regions[j,], 
                                   fun=sum, 
                                   na.rm=TRUE)
        
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
              file = paste0(OUTPUT_folders,'RegionLandUse_frac.txt'), 
              row.names = FALSE)
  