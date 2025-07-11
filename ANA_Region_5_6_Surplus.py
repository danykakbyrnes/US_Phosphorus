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
shpFile = '9_Phosphorus_Use_Efficiency/INPUTS_051523/0_General_Data/HUC2/noLakes_merged_HUC2_5070_v3.shp'
raster = '3_TREND_Nutrients/TREND_Nutrients/OUTPUT/Grid_TREND_P_Version_1/TREND-P_Postpocessed_Gridded_2023-11-18/Ag_Surplus/AgSurplus_2017.tif'
#raster = '9_Phosphorus_Use_Efficiency/OUTPUTS/PUE/PUE_2017.tif'
# Sorting HUC2 regions
HUC2 = gpd.read_file(shpFile)
HUC2.sort_values(by=['REG'], 
                 axis=0, 
                 ascending=False, 
                 inplace=True, 
                 ignore_index=True)

# Isolating the two regions I want to compare
HUC_5 = HUC2.iloc[4]
HUC_6 = HUC2.iloc[5]

# Reading in raster and masking using the regions.
with rasterio.open(raster) as src:
    
    # Read the data into an array
    PUE_2017 = src.read(1)
    
    # Saving metadata
    metadata = src.meta

    HUC_5_geoms = [mapping(HUC_5.geometry)]
    HUC_6_geoms = [mapping(HUC_6.geometry)]
    
    # Perform the clipping operation
    HUC_5_raster, HUC_5_transform = rasterio.mask.mask(src, 
                                                       HUC_5_geoms, 
                                                       nodata=np.nan,
                                                       crop=True)
    HUC_6_raster, HUC_6_transform = rasterio.mask.mask(src, 
                                                       HUC_6_geoms, 
                                                       nodata=np.nan,
                                                       crop=True)
    # Copying metadata from original raster
    HUC_5_raster_meta = src.meta
    HUC_6_raster_meta = src.meta

# Updating the metadata for the two regions. 
HUC_5_raster_meta.update({"driver": "GTiff",
                          "height": HUC_5_raster.shape[1],
                          "width": HUC_5_raster.shape[2],
                          "transform": HUC_5_transform,
                          "nodata":np.nan})

HUC_6_raster_meta.update({"driver": "GTiff",
                          "height": HUC_6_raster.shape[1],
                          "width": HUC_6_raster.shape[2],
                          "transform": HUC_6_transform,
                          "nodata":np.nan})

# Selecting first band and turning it into a 2D array
HUC_5_raster_2d = np.squeeze(HUC_5_raster)
HUC_6_raster_2d = np.squeeze(HUC_6_raster)

# Number of total cells in each region
# Ag surplus has 0 for non-ag land, so we need to remove those. 
HUC5_total_cells = np.sum(~np.isnan(HUC_5_raster_2d) & (HUC_5_raster_2d != 0))
HUC5_negative_cells = np.sum((HUC_5_raster_2d < 0) & (~np.isnan(HUC_5_raster_2d)))
HUC5_percent_negative = (HUC5_negative_cells/HUC5_total_cells)*100

HUC6_total_cells = np.sum(~np.isnan(HUC_6_raster_2d) & (HUC_6_raster_2d != 0))
HUC6_negative_cells = np.sum((HUC_6_raster_2d < 0) & (~np.isnan(HUC_6_raster_2d)))
HUC6_percent_negative = (HUC6_negative_cells/HUC6_total_cells)*100