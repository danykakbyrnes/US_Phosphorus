# -*- coding: utf-8 -*-
"""
Created on Wed May  7 11:49:04 2025
@author: danyk
"""

# Packages Imports
import geopandas as gpd
import pandas as pd 
import rasterio as ra
from rasterstats import zonal_stats
import numpy as np
import os
import matplotlib.pyplot as plt

# watershd shapefile path

directory = r'B:/LabFiles/users/DanykaByrnes/9_Phosphorus_Use_Efficiency/'

# Set the working directory
os.chdir(directory)

# Filepaths to shapefile and raster (ESPG 5070)
shpFile = 'INPUTS_051523/0_General_Data/HUC2/noLakes_merged_HUC2_5070_v3.shp'
rasterFolders = 'B:/LabFiles/users/DanykaByrnes/3_TREND_Nutrients/TREND_Nutrients/OUTPUT/Grid_TREND_P_Version_1/TREND-P_Gridded_Outputs_2023-11-18/'

# Read watershed shapefile
HUC2 = gpd.read_file(shpFile)
HUC2 = HUC2.set_index("REG")
HUC2.sort_values(by='REG', ascending=False, inplace=True)
crop_rasterFiles = ['CropUptake_Cropland_Agriculture_LU/CropUptake_Cropland_1980.tif', 
                    'CropUptake_Cropland_Agriculture_LU/CropUptake_Cropland_2017.tif',
                    'CropUptake_Pasture_Agriculture_LU/CropUptake_Pasture_1930.tif', 
                    'CropUptake_Pasture_Agriculture_LU/CropUptake_Pasture_1980.tif',
                    'CropUptake_Pasture_Agriculture_LU/CropUptake_Pasture_2017.tif']
cYear = ['Crop_1930', ' Crop_1980', 'Crop_2017', 'Past_1930', 'Past_1980', 'Past_2017']
itr = 0
    
# Pulling the files from individual folders
rasterFile = rasterFolders+'CropUptake_Cropland_Agriculture_LU/CropUptake_Cropland_1930.tif'

# Reading first file in to initialize
rf = ra.open(rasterFile)
affine = rf.transform
r = rf.read(1)

r[r == 0] = np.nan

# Initializing the dataframe
n = zonal_stats(HUC2, r, affine=affine, stats="median")
n = pd.DataFrame(n)
n["{}".format(cYear[itr])]=n["median"]
n=n.set_index(HUC2.index)
n=n.drop(columns=["median"])
    
# Loop years you are interested in and extract data         
for file in crop_rasterFiles:
    itr = itr + 1
    rasterFile = rasterFolders+file
    rf = ra.open(rasterFile)
    affine = rf.transform
    r = rf.read(1)
    r[r == 0] = np.nan
    df = zonal_stats(HUC2, r, affine=affine, stats="median")
    df = pd.DataFrame(df)
    n["{}".format(cYear[itr])] = df['median'].values
    
# Make histograms 
plt.figure(figsize=(10,8))
labels = ['1930', '1980', '2017']
x = np.arange(len(labels))
width = 0.3
RegNum = [1,2,3,4,5,6,7,8,9]
itr = 0
for reg in RegNum: 

    plt.subplot(3,3,itr+1)
    plt.bar(x-width/2, [n.iloc[itr,0], n.iloc[itr,1],  n.iloc[itr,2]], width, label='Crop Uptake')
    plt.bar(x+width/2, [n.iloc[itr,3], n.iloc[itr,4], n.iloc[itr,5]], width, label='Pasture Uptake',)
    plt.xticks([0,1,2], labels, fontsize=10)
    plt.ylim([0, 15])
    
    plt.title('Region {}'.format(reg))
    itr = itr + 1

plt.subplot(3,3,1)
plt.ylabel("kg-P/ha/yr")
plt.subplot(3,3,4)
plt.ylabel("kg-P/ha/yr")
plt.subplot(3,3,7)
plt.ylabel("kg-P/ha/yr")

plt.subplot(3,3,1)
plt.legend()

plt.tight_layout()
plt.savefig(directory+'OUTPUTS/PUE_drivers/Region_1-4_CropPasture.png')