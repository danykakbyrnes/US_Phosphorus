# United States Phosphorus Use Efficiency Paper Scripts

The following scripts are used to recreate data and figures required for the paper titled [TBD]. 

We use gTREND-phosphorus data found at XX. 

## To do
1. Move agricultural surplus code to P surplus folder
2. Change script so regions numbers match the manuscrip

## Usage Instructions

### 1. Data Generation (Run First)

These scripts must be executed first to generate the required data files for subsequent analysis and figure generation. All geospatial .tif files are projected in EPSG:5070 - NAD83 / Conus Albers.

#### DATA_CumulativePhosphorusSurplus_gridded.m
	**Purpose**: Generates gridded cumulative phosphorus surplus data.
	**Input**: gTREND data layers (annual fertilizer P input, manure P input, and crop P removal .tif files)
	**Output**: Annual (1930-2017) geospatial .tif files of cumulative surplus (summation of manure P inputs, fertilizer P inputs, and crop P removal).
	**Language**: MATALB

#### `DATA_PhosphorusUseEfficiency_gridded.m`
	**Purpose**: Generates gridded phosphorus use efficiency (PUE) data.
	**Input**: gTREND data layers (annual fertilizer P input, manure P input, and crop P removal .tif files)
	**Output**: Annual (1930-2017) geospatial .tif files of PUE (ratio of crop P removal to total manure P and fertilizer P inputs). 
	**Language**: MATLAB

#### `DATA_AgriculturalSurplus.m`
	not created yet, it's in the gTREND folder but I should move it to this code folder
	**Purpose**:
	**Input**:
	**Output**:
	**Language**: MATLAB

#### `DATA_HUC2_Surplus_Components_PUE.R`
	**Purpose**: Extracts HUC2 watershed-level surplus, components, and PUE. 
	**Input**: gTREND components, agricultural surplus, and PUE .tif files. 
	**Output**: Text file of annual mean and median statistics (1930-2017) by HUC2 watershed for P components, agricultural surplus, and PUE.
	**Language**: R
	
#### `DATA_HUC2_CumultativeSurplus.R`
	**Purpose**: Extracts HUC2 watershed-level cumulative surplus.
	**Input**: Cumulative surplus 1980 and 2017 .tif files.
	**Output**: Text file containing mean and median cumulative surplus statistics by HUC2 watershed for 1980 and 2017.
	**Language**: R

#### `DATA_HUC2_AgrLandUse_clip.R`
	**Purpose**: Extacts HUC2 watershed-level agricultural land use.
	**Input**: Annual agricultural land use .tif files. 
	**Output**: Text file of percent agricultural land use (1930-2017) by HUC2 watershed. 
	**Language**: R
	Clipping annual agricultural land use to HUC2 watersheds for Figure 3.

DATA_PUEcSurplus_frameworkMaps.m
	Categorizes each agricultural land use parcel in 1980 and 2017 based on land parcel's PUE and cumulative surplus. Script outputs the maps of the categorized land use parcels. Maps are then produced in QGIS.

** ANALYSIS SCRIPTS **

ANA_Regional_Quadrant_Distribution.py
	Exploring the quadrant distribution for each region. Script is used for analysis in Section 3.5. 

ANA_Region_5_6_Surplus.py
	**Do i use this one??**

ANA_Region1-4_CropFertilizerUse.py
	Exploring fertilizer use for the four main field crops (corn, soy, wheat, cotton) for each state. 

ANA_Region3_Region8_Comparison.py
	Exploring the 2017 PUE distribution in Regions 3 and 8 to understand why median values of each component are similar magnitudes, but their median PUE is different. Script is used for analysis in Section 3.2 (Supplemental Figure 2). 

** FIGURES **

FIG_National_Timeseries_Plots.m
	Summarizes and outputs national median, interquartile range, and 5th-95th percentile range. National statistics are plotted and used in Figure 1 and Figure 3b. 

FIG_PercentManureInputs.m
	Calculates the proportion of manure-derived P inputs at the national-scale and at the regional scale. Outputs is PUE (2017) versus the proportion of manure-derived P inputs (Figure 2d). Generating the hexplot requires over computers with over 64GB of RAM. As such, we also include a script to generate a scatter plot. 

FIG_PUE_PS_conceptualFigure.m
	Output plot of phosphorus surplus (x-axis) and 1-PUE (y-axis). Regional surplus and 1-PUE in 2017 are also plotted (Figure 6). 

FIG_PUEcSurplus_frameworkQuadrants.m
	Categorizes each agricultural land use parcel in 1980 and 2017 based on land parcel's PUE and cumulative surplus. Script outputs a .mat file of vectorized data. It also outputs a quadrant plot in 1980 and 2017, along with a Sankey plot (Figure 8b, e-f).

FIG_quadrantDrivers.m
	Generates boxplots of the distribution of proportion of manure-derived P inputs in each quadrant and maps of the proportion of manure-derived P inputs in 1980 and 2017. 
	** THIS SCRIPT MIGHT BE UNUSED. 

FIG_Regional_PUE_Surp_cSURP_lollicharts.m
	Generates lolli charts for median surplus (1930, 1980, and 2017), median PUE and median cumulative surplus (1980, 2017) in Figures 2c, 5c, and 7c.

FIG_Regional_PUE_component_timeseries.m
	Generates the median timeseries of PUE and surplus components (manure, fertilizer, and crop removal). Also generates the total agricultural land use in each region. Output Figures 3 and 4. 

FIG_PS_cumuSurplus_conceptualFigure.m
	Outputs plot of 2017 phosphorus surplus (x-axis) and 2017 cumulative surplus (y-axis). Regional surplus and cumulative surplus in 2017 are also plotted (Supplemental Figure 3).

FIG_Region1-4_Cropland_Pasture.py
	Exploring crop and pastureland P uptake for each region. This analysis used in Section 3.2 (Supplemental Figure 1) to understand the relative proportions of P removed by crop and pasture in regions 1 through 4.

FIG_ManucriptMetrics.m
	Script that outputs all the reported metrics in manuscript. 