# -*- coding: utf-8 -*-
"""
Created on Wed Nov 22 13:19:00 2023

@author: dkbyrnes
"""

# Packages you need 
import numpy as np
import geopandas as gpd
import pandas as pd 
import rasterio as ra
from rasterstats import zonal_stats
import os
import concurrent.futures

# Where to save it?
OUTPUTFolder = '../OUTPUTS/HUC2/'

# p_g is the watershed shapefile path
wtsdFilepath = '../INPUTS_051523/0 General Data/HUC2/merged_HUC2_5070_v3.shp'
# r is the TREND-DS imageries path
rasterFolders = '../../3 TREND_Nutrients/TREND_Nutrients/OUTPUT/Grid_TREND_P_Version_1/TREND-P Postpocessed Gridded (2023-11-18)/'

# Listing files
rasterFoldersList = os.listdir(rasterFolders)

# Selecting specific folders
goodINX = [4] #### CHECK THESE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
rasterFoldersList = [rasterFoldersList[i] for i in goodINX]

# Read HUC2 shapefile
WS = gpd.read_file(wtsdFilepath)
WS = WS.set_index("MERGE")

# Reprojecting shapefile to have the same projection as the raster
WS = WS.to_crs({'init': 'epsg:5070'})

# Function to process each raster folder
def process_raster_folder(compfolder):
    cYear = 1930
    rasterFile = rasterFolders + compfolder + '/'
    rasterFileList = os.listdir(rasterFile)
    rasterFileList.sort()

    rPath = rasterFile + rasterFileList[0]
    rf = ra.open(rPath)
    affine = rf.transform
    r = rf.read(1)
    r[r == 0] = np.nan # I want only the zonal statistics from ag land.

    n = zonal_stats(WS, r, affine=affine, stats="mean")
    n = pd.DataFrame(n)
    n["{}".format(cYear)] = n["mean"]
    n = n.set_index(WS.index)
    n = n.drop(columns=["mean"])

    for file in rasterFileList:
        rPath = rasterFile + file
        rf = ra.open(rPath)
        affine = rf.transform
        r = rf.read(1)

        df = zonal_stats(WS, r, affine=affine, stats="mean")
        df = pd.DataFrame(df)
        n["{}".format(cYear)] = df['mean'].values
        cYear += 1

    save_path =  OUTPUTFolder + compfolder + '.txt'
    n.to_csv(save_path)

# Parallel execution
with concurrent.futures.ThreadPoolExecutor() as executor:
    executor.map(process_raster_folder, rasterFoldersList)
    
# Repeating the process for PUE
rasterFolders = '../OUTPUTS/'
rasterFoldersList = "PUE"

with concurrent.futures.ThreadPoolExecutor() as executor:
    executor.map(process_raster_folder, rasterFoldersList)