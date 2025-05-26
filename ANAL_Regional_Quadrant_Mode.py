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

directory = r'B:/LabFiles/users/DanykaByrnes/9_Phosphorus_Use_Efficiency/'

# Set the working directory
os.chdir(directory)

# Filepaths to shapefile and raster (ESPG 5070)
shpFile = 'INPUTS_051523/0_General_Data/HUC2/noLakes_merged_HUC2_5070_v3.shp'
raster = 'OUTPUTS/Quadrants/QuadrantMap_2017.tif'
    
# Sorting HUC2 regions
HUC2 = gpd.read_file(shpFile)
HUC2.sort_values(by=['REG'], 
                 axis=0, 
                 ascending=False, 
                 inplace=True, 
                 ignore_index=True)

HUC_Q_count = [None] * len(HUC2)

# Reading in raster and masking using the regions.
with rasterio.open(raster) as src:
    # Read the data into an array
    #PUE_2017 = src.read(1)
    # Saving metadata
    metadata = src.meta
    
    for index, HUC in HUC2.iterrows():
    
        HUC_geoms = [mapping(HUC.geometry)]
    
        # Perform the clipping operation
        HUC_raster, HUC_transform = rasterio.mask.mask(src,
                                                       HUC_geoms,
                                                       nodata=np.nan,
                                                       crop=True)
        HUC_raster[HUC_raster == 0] = np.nan
        HUC_Q_count[index] = [HUC.REG, 
                              np.sum(HUC_raster == 1),
                              np.sum(HUC_raster == 2),
                              np.sum(HUC_raster == 3), 
                              np.sum(HUC_raster == 4), 
                              np.count_nonzero(~np.isnan(HUC_raster))]
    
df_HUC_Q_count = pd.DataFrame(HUC_Q_count,
                              columns=['REG', 'Q1', 'Q2', 'Q3', 'Q4', 'TotCell'])

df_HUC_Q_count.to_csv("OUTPUTS/Quadrants/Regional_Quadrants.txt",
                      index=False,
                      sep='\t')