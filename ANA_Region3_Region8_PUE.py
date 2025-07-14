# -*- coding: utf-8 -*-
"""
Created on Tue May  6 13:58:56 2025

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

# Load .env filepath
load_dotenv()

# Filepaths to shapefile and raster (ESPG 5070)
Regional_filepath = os.getenv("GENERAL_INPUT")
PUE_filepath = os.getenv("PHOS_USE_EFFICIENCY")

shpFile = Regional_filepath + '/HUC2/noLakes_merged_HUC2_5070_v3.shp'
PUE_raster = PUE_filepath+'PUE_2017.tif'

# Sorting HUC2 regions
HUC2 = gpd.read_file(shpFile)
HUC2.sort_values(by=['REG'], 
                 axis=0, 
                 ascending=False, 
                 inplace=True, 
                 ignore_index=True)

# Isolating the two regions I want to compare
HUC_3 = HUC2.iloc[2]
HUC_8 = HUC2.iloc[7]

# Reading in raster and masking using the regions.
with rasterio.open(PUE_raster) as src:
    
    # Read the data into an array
    PUE_2017 = src.read(1)
    
    # Saving metadata
    metadata = src.meta

    HUC_3_geoms = [mapping(HUC_3.geometry)]
    HUC_8_geoms = [mapping(HUC_8.geometry)]
    
    # Perform the clipping operation
    HUC_3_raster, HUC_3_transform = rasterio.mask.mask(src, 
                                                       HUC_3_geoms, 
                                                       nodata=np.nan,
                                                       crop=True)
    HUC_8_raster, HUC_8_transform = rasterio.mask.mask(src, 
                                                       HUC_8_geoms, 
                                                       nodata=np.nan,
                                                       crop=True)
    # Copying metadata from original raster
    HUC_3_raster_meta = src.meta
    HUC_8_raster_meta = src.meta

# Updating the metadata for the two regions. 
HUC_3_raster_meta.update({"driver": "GTiff",
                          "height": HUC_3_raster.shape[1],
                          "width": HUC_3_raster.shape[2],
                          "transform": HUC_3_transform,
                          "nodata":np.nan})

HUC_8_raster_meta.update({"driver": "GTiff",
                          "height": HUC_8_raster.shape[1],
                          "width": HUC_8_raster.shape[2],
                          "transform": HUC_8_transform,
                          "nodata":np.nan})

# Selecting first band and turning it into a 2D array
HUC_3_raster_2d = np.squeeze(HUC_3_raster)
HUC_8_raster_2d = np.squeeze(HUC_8_raster)

# Plot normalized histograms for both regions
fig, ax = plt.subplots(figsize=(8, 5))

# Set specific bin width (e.g., 0.1 units)
bin_width = 0.05
bins = np.arange(0, 2 + bin_width, bin_width)

# Region 3 (vectorizing the data and plotting)
ax.hist(HUC_3_raster_2d.flatten()[~np.isnan(HUC_3_raster_2d.flatten())], 
        bins=bins, alpha=0.5, label='Region 3',
        color='red', density=True)

# Region 8 (vectorizing the data and plotting)
ax.hist(HUC_8_raster_2d.flatten()[~np.isnan(HUC_8_raster_2d.flatten())], 
        bins=bins, alpha=0.5, label='Region 8',
        color='blue', density=True)

# Add labels and title
plt.rcParams.update({'font.size': 12})
ax.set_xlabel('PUE', fontsize=12)
ax.set_ylabel('Probability Density', fontsize=12)
ax.legend()

# Display the plot
plt.tight_layout()
plt.show()

# Calculating statistics
HUC_3_median = np.nanmedian(HUC_3_raster_2d)
HUC_3_std = np.nanstd(HUC_3_raster_2d)
    
HUC_8_median = np.nanmedian(HUC_8_raster_2d)
HUC_8_std = np.nanstd(HUC_8_raster_2d)