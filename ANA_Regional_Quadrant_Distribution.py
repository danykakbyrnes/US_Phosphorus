# -*- coding: utf-8 -*-
"""
Created on Tue May  6 13:58:56 2025

@author: danyk
"""

import geopandas as gpd
import pandas as pd
import os
import rasterio
import rasterio.mask
import numpy as np
from shapely.geometry import mapping
from dotenv import load_dotenv

load_dotenv()

# Filepaths to shapefile and raster (ESPG 5070)
Regional_filepath = os.getenv("GENERAL_INPUT")
Quadrant_filepath = os.getenv("QUADRANT_ANALYSIS")
Quadrant_raster = Quadrant_filepath + 'QuadrantMap_2017.tif'
shpFile = Regional_filepath + 'Regions/HUC2_Merged_Regions.shp' #noLakes_merged_HUC2_5070_v3

# Sorting regions
REGIONS = gpd.read_file(shpFile)
REGIONS.sort_values(by=['REG'], 
                 axis=0, 
                 ascending=False, 
                 inplace=True, 
                 ignore_index=True)

REGIONS_Q_count = [None] * len(REGIONS)

# Reading in raster and masking using the regions.
with rasterio.open(Quadrant_raster) as src:
    # Read the data into an array
    #PUE_2017 = src.read(1)
    # Saving metadata
    metadata = src.meta
    
    for index, REGIONS in REGIONS.iterrows():
    
        REGIONS_geoms = [mapping(REGIONS.geometry)]
    
        # Perform the clipping operation
        REGIONS_raster, REGIONS_transform = rasterio.mask.mask(src,
                                                       REGIONS_geoms,
                                                       nodata=np.nan,
                                                       crop=True)
        REGIONS_raster[REGIONS_raster == 0] = np.nan
        REGIONS_Q_count[index] = [REGIONS.REG, 
                              np.sum(REGIONS_raster == 1),
                              np.sum(REGIONS_raster == 2),
                              np.sum(REGIONS_raster == 3), 
                              np.sum(REGIONS_raster == 4), 
                              np.count_nonzero(~np.isnan(REGIONS_raster))]
    
df_REGIONS_Q_count = pd.DataFrame(REGIONS_Q_count,
                              columns=['REG', 'Q1', 'Q2', 'Q3', 'Q4', 'TotCell'])

df_REGIONS_Q_count.to_csv(Quadrant_filepath + "Regional_Quadrants_2017.txt",
                      index=False,
                      sep='\t')