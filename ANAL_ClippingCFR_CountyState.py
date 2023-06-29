# -*- coding: utf-8 -*-
"""Created on Thu Jun 29 09:59:21 2023

@author: dkbyrnes
"""

import os
import rasterio
import geopandas as gpd
from rasterio.mask import mask
from rasterstats import zonal_stats
import matplotlib.pyplot as plt

# Path to the folder containing rasters
raster_folder = 'B:/LabFiles/users/DanykaByrnes/9 Phosphorus Use Efficiency/OUTPUTS/CropFertRatio/'

# Path to the shapefile
shapefile_path = 'B:/LabFiles/users/DanykaByrnes/3 TREND_Nutrients/TREND_Nutrients/INPUTS_102122/0 General Data/CountyShapefiles/US_CountyShapefile_2017.shp'

# Read the shapefile using geopandas
shapefile = gpd.read_file(shapefile_path)

# Iterate over each raster in the folder
for filename in os.listdir(raster_folder):
    if filename.endswith('.tif'):  # Change the file extension if needed
        raster_path = os.path.join(raster_folder, filename)

        # Read the raster file using rasterio
        with rasterio.open(raster_path) as src:
            # Mask the raster using the shapefile's geometry
            raster, raster_transform = mask(src, shapefile.geometry, crop=True)

            # Get the statistics for each polygon in the shapefile
            stats = zonal_stats(
                shapefile_path,
                raster[0],
                affine=raster_transform,
                nodata=src.nodata,
                stats=['median']
                )
            
            # Create a new column in the shapefile for the raster statistics
            year = filename.split('_')[1].split('.')[0]
            column_name = f'Y{year}'  # Create a column name with the year
            shapefile[column_name] = [stat['median'] for stat in stats]
            
# Move the geometry column to the end
geometry_column = shapefile.geometry
shapefile.pop('geometry')
shapefile.insert(len(shapefile.columns), 'geometry', geometry_column)

# Save the updated shapefile with the zonal statistics
output_shapefile = 'CFR_counties.shp'
shapefile.to_file(raster_folder+output_shapefile)


#%% State level analysis
shapefile_path = 'B:/LabFiles/users/DanykaByrnes/3 TREND_Nutrients/TREND_Nutrients/INPUTS_102122/0 General Data/cb_2017_us_state_5m/cb_2017_us_state_5m_5070.shp'
# Read the shapefile using geopandas
shapefile = gpd.read_file(shapefile_path)

# Iterate over each raster in the folder
for filename in os.listdir(raster_folder):
    if filename.endswith('.tif'):  # Change the file extension if needed
        raster_path = os.path.join(raster_folder, filename)

        # Read the raster file using rasterio
        with rasterio.open(raster_path) as src:
            # Mask the raster using the shapefile's geometry
            raster, raster_transform = mask(src, shapefile.geometry, crop=True)

            # Get the statistics for each polygon in the shapefile
            stats = zonal_stats(
                shapefile_path,
                raster[0],
                affine=raster_transform,
                nodata=src.nodata,
                stats=['median']
                )
            
            # Create a new column in the shapefile for the raster statistics
            year = filename.split('_')[1].split('.')[0]
            column_name = f'Y{year}'  # Create a column name with the year
            shapefile[column_name] = [stat['median'] for stat in stats]
            
# Move the geometry column to the end
geometry_column = shapefile.geometry
shapefile.pop('geometry')
shapefile.insert(len(shapefile.columns), 'geometry', geometry_column)

# Save the updated shapefile with the zonal statistics
output_shapefile = 'CFR_state.shp'
shapefile.to_file(raster_folder+output_shapefile)

#%% Path to the folder containing rasters
raster_folder = 'B:/LabFiles/users/DanykaByrnes/9 Phosphorus Use Efficiency/OUTPUTS/ManureFertRatio/'

# Path to the shapefile
shapefile_path = 'B:/LabFiles/users/DanykaByrnes/3 TREND_Nutrients/TREND_Nutrients/INPUTS_102122/0 General Data/CountyShapefiles/US_CountyShapefile_2017.shp'

# Read the shapefile using geopandas
shapefile = gpd.read_file(shapefile_path)

# Iterate over each raster in the folder
for filename in os.listdir(raster_folder):
    if filename.endswith('.tif'):  # Change the file extension if needed
        raster_path = os.path.join(raster_folder, filename)

        # Read the raster file using rasterio
        with rasterio.open(raster_path) as src:
            # Mask the raster using the shapefile's geometry
            raster, raster_transform = mask(src, shapefile.geometry, crop=True)

            # Get the statistics for each polygon in the shapefile
            stats = zonal_stats(
                shapefile_path,
                raster[0],
                affine=raster_transform,
                nodata=src.nodata,
                stats=['median']
                )
            
            # Create a new column in the shapefile for the raster statistics
            year = filename.split('_')[1].split('.')[0]
            column_name = f'Y{year}'  # Create a column name with the year
            shapefile[column_name] = [stat['median'] for stat in stats]
            
# Move the geometry column to the end
geometry_column = shapefile.geometry
shapefile.pop('geometry')
shapefile.insert(len(shapefile.columns), 'geometry', geometry_column)

# Save the updated shapefile with the zonal statistics
output_shapefile = 'MFR_counties.shp'
shapefile.to_file(raster_folder+output_shapefile)