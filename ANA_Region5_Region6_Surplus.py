# -*- coding: utf-8 -*-
"""
Created on Thu Jun 19 15:28:15 2025

@author: danyk
"""

import geopandas as gpd
import os
import rasterio
import rasterio.mask
import matplotlib.pyplot as plt
import numpy as np
from shapely.geometry import mapping
from dotenv import load_dotenv

load_dotenv()

# Filepaths to shapefile and raster (ESPG 5070)
Regional_filepath = os.getenv("GENERAL_INPUT")
AgSURP_filepath = os.getenv("POSTPROCESSED_TREND")
AgSURP_raster = AgSURP_filepath + 'Ag_Surplus/Ag_Surplus_2017.tif'

shpFile = Regional_filepath + 'Regions/HUC2_Merged_Regions.shp' #noLakes_merged_HUC2_5070_v3

# Sorting regions
REGIONS = gpd.read_file(shpFile)
REGIONS.sort_values(by=['REG'], 
                 axis=0, 
                 ascending=False, 
                 inplace=True, 
                 ignore_index=True)

# Isolating the two regions I want to compare
REGION_5 = REGIONS.iloc[4]
REGION_6 = REGIONS.iloc[5]

# Reading in raster and masking using the regions.
with rasterio.open(AgSURP_raster) as src:
    
    # Read the data into an array
    PUE_2017 = src.read(1)
    
    # Saving metadata
    metadata = src.meta

    REGION_5_geoms = [mapping(REGION_5.geometry)]
    REGION_6_geoms = [mapping(REGION_6.geometry)]
    
    # Perform the clipping operation
    REGION_5_raster, REGION_5_transform = rasterio.mask.mask(src, 
                                                       REGION_5_geoms, 
                                                       nodata=np.nan,
                                                       crop=True)
    REGION_6_raster, REGION_6_transform = rasterio.mask.mask(src, 
                                                       REGION_6_geoms, 
                                                       nodata=np.nan,
                                                       crop=True)
    # Copying metadata from original raster
    REGION_5_raster_meta = src.meta
    REGION_6_raster_meta = src.meta

# Updating the metadata for the two regions. 
REGION_5_raster_meta.update({"driver": "GTiff",
                          "height": REGION_5_raster.shape[1],
                          "width": REGION_5_raster.shape[2],
                          "transform": REGION_5_transform,
                          "nodata":np.nan})

REGION_6_raster_meta.update({"driver": "GTiff",
                          "height": REGION_6_raster.shape[1],
                          "width": REGION_6_raster.shape[2],
                          "transform": REGION_6_transform,
                          "nodata":np.nan})

# Selecting first band and turning it into a 2D array
REGION_5_raster_2d = np.squeeze(REGION_5_raster)
REGION_6_raster_2d = np.squeeze(REGION_6_raster)

# Number of total cells in each region
# Ag surplus has 0 for non-ag land, so we need to remove those. 
HUC5_total_cells = np.sum(~np.isnan(REGION_5_raster_2d) & (REGION_5_raster_2d != 0))
HUC5_negative_cells = np.sum((REGION_5_raster_2d < 0) & (~np.isnan(REGION_5_raster_2d)))
HUC5_percent_negative = (HUC5_negative_cells/HUC5_total_cells)*100

HUC6_total_cells = np.sum(~np.isnan(REGION_6_raster_2d) & (REGION_6_raster_2d != 0))
HUC6_negative_cells = np.sum((REGION_6_raster_2d < 0) & (~np.isnan(REGION_6_raster_2d)))
HUC6_percent_negative = (HUC6_negative_cells/HUC6_total_cells)*100