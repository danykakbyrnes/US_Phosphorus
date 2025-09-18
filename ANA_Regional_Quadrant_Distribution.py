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

YEARS = [1980, 2017]
df_REGIONS_pct_combined = []

# Filepaths to shapefile and raster (ESPG 5070)
Regional_filepath = os.getenv("GENERAL_INPUT")
Quadrant_filepath = os.getenv("QUADRANT_ANALYSIS")
shpFile = Regional_filepath + 'Regions/HUC2_Merged_Regions.shp'

Regions_Names_map = {'1':'Pacific Coast',
                 '2':'Arid West',
                 '3': 'Southern Plains',
                 '4':'Northern Plains',
                 '5': 'Lower Mississippi',
                 '6': 'Upper Mississippi-Great Lakes',
                 '7': 'South Atlantic Gulf',
                 '8': 'Mid Atlantic',
                 '9': 'New England',
                 ' ':'National'}

for YEAR in YEARS:
    Quadrant_raster = f"{Quadrant_filepath}QuadrantMap_{YEAR}.tif"
    
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
                                  columns=['Region', 'Q1', 'Q2', 'Q3', 'Q4', 'TotCell'])


    # Calculate national totals from raw counts
    national_q1 = df_REGIONS_Q_count['Q1'].sum()
    national_q2 = df_REGIONS_Q_count['Q2'].sum()
    national_q3 = df_REGIONS_Q_count['Q3'].sum()
    national_q4 = df_REGIONS_Q_count['Q4'].sum()
    national_total = df_REGIONS_Q_count['TotCell'].sum()
    
    # Add national row with raw counts
    national_row = pd.DataFrame({
        'Region': [' '],
        'Q1': [national_q1],
        'Q2': [national_q2],
        'Q3': [national_q3],
        'Q4': [national_q4],
        'TotCell': [national_total]
    })
    
    df_REGIONS_abs = pd.concat([df_REGIONS_Q_count, national_row], ignore_index=True)
    df_REGIONS_pct = df_REGIONS_abs.copy()
    # NOW convert to percentages
    df_REGIONS_pct['Q1'] = (df_REGIONS_pct['Q1'] / df_REGIONS_pct['TotCell'])
    df_REGIONS_pct['Q2'] = df_REGIONS_pct['Q2'] / df_REGIONS_pct['TotCell']
    df_REGIONS_pct['Q3'] = df_REGIONS_pct['Q3'] / df_REGIONS_pct['TotCell']
    df_REGIONS_pct['Q4'] = df_REGIONS_pct['Q4'] / df_REGIONS_pct['TotCell'] 
    
    # Drop TotCell column
    df_REGIONS_pct = df_REGIONS_pct.drop('TotCell', axis=1)
    
    df_REGIONS_pct['Region Name'] = df_REGIONS_pct['Region'].map(Regions_Names_map)
    
    df_REGIONS_pct.to_csv(f"{Quadrant_filepath}Regional_Quadrant_{YEAR}.csv",
                             index=False,
                             sep=',')
    
    # Append to list
    df_REGIONS_pct['Year'] = YEAR
    df_REGIONS_pct_combined.append(df_REGIONS_pct)
    
df_REGIONS_pct_combined = pd.concat(df_REGIONS_pct_combined, ignore_index=True, sort=False)

df_REGIONS_pct_combined = df_REGIONS_pct_combined[['Region', 'Region Name', 'Year', 'Q1', 'Q2', 'Q3', 'Q4']]
    
df_REGIONS_pct_combined.sort_values(by = ['Region', 'Year'], inplace = True)
    
df_REGIONS_pct_combined.to_csv(Quadrant_filepath + 'Regional_Quadrant_combined.csv',
                               index=False,
                               sep=',')