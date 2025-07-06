# United States Phosphorus Use Efficiency Paper Scripts

The following scripts are used to recreate data and figures required for the paper titled [TBD]. 

The analysis of phosphorus use across the US from 1930 to 2017 using the newly published gTREND-Phosphorus dataset. The dataset can be found at [XX]. 

## To do
1. Move agricultural surplus code to P surplus repo
2. Change script so regions numbers match the manuscrip

## Data Source
- **gTREND-phosphorus data**: Available at [XX - update with actual URL]

## Usage Instructions

### 1. Data Generation (Run First)

These scripts must be executed first to generate the required data files for subsequent analysis and figure generation. All geospatial TIF files are projected in EPSG:5070 - NAD83 / Conus Albers.

#### `DATA_PhosphorusUseEfficiency_gridded.m`
- **Purpose**: Generates gridded phosphorus use efficiency (PUE) data.  
- **Input**: gTREND data layers (annual fertilizer P input, manure P input, and crop P removal TIF files).  
- **Output**: Annual (1930-2017) geospatial TIF files of PUE (ratio of crop P removal to total manure P and fertilizer P inputs). Maps in Figure 2 are produced in QGIS.  
- **Language**: MATLAB  

#### `DATA_AgriculturalSurplus.m`
not created yet, it's in the gTREND folder but I should move it to this code folder
- **Purpose**:  
- **Input**:  
- **Output**: Maps in Figure 5 are produced in QGIS.  
- **Language**: MATLAB  

#### `DATA_CumulativePhosphorusSurplus_gridded.m`
- **Purpose**: Generates gridded cumulative phosphorus surplus data.  
- **Input**: gTREND data layers (annual fertilizer P input, manure P input, and crop P removal TIF files).  
- **Output**: Annual (1930-2017) geospatial TIF files of cumulative surplus (summation of manure P inputs, fertilizer P inputs, and crop P removal). Maps in Figure 7 are produced in QGIS.  
- **Language**: MATALB  

#### `DATA_HUC2_Surplus_Components_PUE.R`
- **Purpose**: Extracts HUC2 watershed-level surplus, components, and PUE.  
- **Input**: gTREND components, agricultural surplus, and PUE TIF files.  
- **Output**: Text file of annual mean and median statistics (1930-2017) by HUC2 watershed for P components, agricultural surplus, and PUE.  
- **Language**: R  
	
#### `DATA_HUC2_CumultativeSurplus.R`
- **Purpose**: Extracts HUC2 watershed-level cumulative surplus.  
- **Input**: Cumulative surplus 1980 and 2017 TIF files.  
- **Output**: Text file containing mean and median cumulative surplus statistics by HUC2 watershed for 1980 and 2017.  
- **Language**: R  

#### `DATA_HUC2_AgrLandUse_clip.R`
- **Purpose**: Extacts HUC2 watershed-level agricultural land use.  
- **Input**: Annual agricultural land use TIF files.  
- **Output**: Text file of percent agricultural land use (1930-2017) by HUC2 watershed.  
- **Language**: R  

#### `DATA_PUEcSurplus_typologyMaps.m`
- **Purpose**: Categorizes agricultural parcels for framework analysis.  
- **Input**: PUE and cumulative surplus TIF files for 1980 and 2017.  
- **Output**: TIF files of categorized land use parcels in 1980 and 2017. Final maps are produced in QGIS.  
- **Language**: MATLAB  

### 2. Analysis Scripts

#### `ANA_Regional_Quadrant_Distribution.py`
- **Purpose**: Analysis of quadrants distribution by region used in Section 3.5.  
- **Input**: TIF files of categorized land use parcels in 1980 and 2017.  
- **Language**: Python  

#### `ANA_Region_5_6_Surplus.py`
	**Do i use this one??**

#### `ANA_Region1-4_CropFertilizerUse.py`
- **Purpose**: Analysis of fertilizer use by state for the four main field crops (corn, soy, wheat, cotton) used in Section 3.3.  
- **Input**: Mosheim, R. (2025). Fertilizer Use and Price - Documentation and Data Sources. https://www.ers.usda.gov/data-products/fertilizer-use-and-price/documentation-and-data-sources
- **Language**: Python  

#### `ANA_Region3_Region8_Comparison.py`
- **Purpose**: Analysis of 2017 PUE distribution in Region 3 and 8 used in Section 3.2 (Supplemental Figure 2).   
- **Input**: gTREND 2017 crop and pasture P removal TIF files.
- **Language**: Python  

### 3. Figure Generation

#### `FIG_National_Timeseries_Plots.m`
- **Purpose**: Generates figure of national-scale statistical summaries and time series.
- **Input**: Annual PUE and surplus TIF files
- **Output**: **Figures 1j-i and 5b** - Plots showing national median, IQR, and 5th-95th percentile for PUE and surplus. 
- **Language**: MATLAB

#### `FIG_PUE_PercentManureInputs.m`
- **Purpose**: Generates figure of PUE versus the proportion of manure-derived phosphorus inputs.  
- **Input**: National TIF files and regional HUC2 medians of manure P, fertilizer P, and PUE data.  
- **Output**: **Figure 2d** - PUE vs. proportion of manure-derived P inputs (hexplot or scatter plot).  
- **Requirements**: >64GB RAM for hexplot generation. Scatter plot can be used as an alternative if hexplot function cannot be run.
- **Language**: MATLAB  

#### `FIG_PUE_PS_conceptualFigure.m`
- **Purpose**: Generates figure to showcase the relationship between surplus and PUE.  
- **Input**: Gridded 2017 PUE and surplus data TIF files and regional medians.  
- **Output**: **Figure 6** - Phosphorus surplus vs. (1-PUE) plot with regional data.  
- **Language**: MATLAB

#### `FIG_PUEcSurplus_frameworkQuadrants.m`
- **Purpose**: Generates figures for framework quadrant analysis and transitions of land parcels betwen 1980 and 2017. 
- **Input**: Gridded PUE and cumulative surplus TIF files and regional medians in 1980 and 2017.
- **Output**: **Figures 8b, 8e-f** - Quadrant plots and Sankey diagram; .mat file of vectorized data.  
- **Language**: MATLAB

#### `FIG_quadrantDrivers.m`
- **Purpose**: Analyzes drivers of quadrant classification.  
- **Input**: Manure proportion data by quadrant.  
- **Output**: Boxplots and maps of manure-derived P inputs (1980, 2017).  
- **Language**: MATLAB
** THIS SCRIPT MIGHT BE UNUSED. 

#### `FIG_Regional_PUE_Surp_cSURP_lollicharts.m`
- **Purpose**: Generates regional summary visualizations.  
- **Input**: Regional median data for surplus, PUE, and cumulative surplus in 1930, 1980, and 2017. 
- **Output**: **Figures 2c, 5c, 7c** - Lollipop charts of median surplus, PUE, and cumulative surplus.  
- **Language**: MATLAB

#### `FIG_Regional_PUE_component_timeseries.m`
- **Purpose**: Generates regional time series of PUE, manure, fertilizer, and crop removal.
- **Input**: HUC2 watershed-level median PUE, component, and agricultural land use percentage data.
- **Output**: **Figures 3 and 4** - Time series of PUE, components and agricultural land use.  
- **Language**: MATLAB

#### `FIG_PS_cumuSurplus_conceptualFigure.m`
- **Purpose**: Generates supplemental figure showcasing the relationship between surplus and cumulative surplus.
- **Input**: Gridded 2017 surplus and cumulative surplus TIF files and regional medians. 
- **Output**: **Supplemental Figure 3** - Phosphorus surplus vs. cumulative surplus plot
- **Language**: MATLAB

#### `FIG_Region1-4_Cropland_Pasture.py`
- **Purpose**: Generating figure of crop phosphorus uptake and pasture phosphorus uptake to compare regional magnitudes.
- **Input**: Regional crop and pasture P uptake data in 1930, 1980, and 2017.
- **Output**: **Supplemental Figure 1** - Figure of P removal by crop and pasture (used in  Section 3.2).  
- **Language**: Python

#### `FIG_ManucriptMetrics.m`
- **Purpose**: Compiles all numerical metrics reported in the manuscript.  
- **Input**: **  
- **Output**: Text file of all the statistics and metrics reported in the manucript.  
- **Language**: MATLAB

## Contact
If you have any questions, please direct questions to danyka[dot]byrnes[at]proton[dot]me.