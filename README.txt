##############################################################################
United States Phosphorus Use Efficiency Paper Scripts
##############################################################################

The following scripts are used to recreate data and figures required for the paper titled [TBD]. 

We use gTREND-phosphorus data found at XX. 

** DATA GENERATION SCRIPTS **
* These scripts must be ran first to derive the data files required for the rest of the analysis and figure generation. *

DATA_CumulativePhosphorusSurplus_gridded.m
	Generating .tif files of cumulative surplus sourcing the gTREND data layers. Cumulative surplus is the summation of manure P inputs, fertilizer P inputs, and crop P removal. 

DATA_PhosphorusUseEfficiency_gridded.m
	Generating .tif files phosphorus use effiency sourcing the gTREND data layers. Phosphorus use efficiency is calculated by taking the ratio of crop P removal to total P input (manure and fertilizer).

DATA_AgriculturalSurplus.m
	**not created yet, it's in the gTREND folder but I should move it to this code folder

DATA_HUC2_Surplus_Components_PUE.R
	Clipping gTREND components, agricultural surplus, and PUE to each HUC2 watershed for each year. Calculation done for each year (1930 to 2017). 

DATA_HUC2_CumultativeSurplus.R
	Clipping cumulative surplus to each HUC2 watershed for 1980 and 2017.

DATA_HUC2_AgrLandUse_clip.R
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
	Calculates the proportion of manure-derived P inputs at the national-scale and at the regional scale. Outputs is PUE (2017) versus the proportion of manure-derived P inputs (Figure 2d). 

FIG_PUE_PS_conceptualFigure.m
	Output plot of phosphorus surplus (x-axis) and 1-PUE (y-axis). Regional surplus and 1-PUE in 2017 are also plotted (Figure 6). 

FIG_PUEcSurplus_frameworkQuadrants.m
	Categorizes each agricultural land use parcel in 1980 and 2017 based on land parcel's PUE and cumulative surplus. Script outputs a .mat file of vectorized data. It also outputs a quadrant plot in 1980 and 2017, along with a Sankey plot (Figure 8b, e-f).

FIG_quadrantDrivers.m
	Script generating boxplots of the distribution of proportion of manure-derived P inputs in each quadrant and maps of the proportion of manure-derived P inputs in 1980 and 2017. 
	** THIS SCRIPT MIGHT BE UNUSED. 




FIG_PS_cumuSurplus_conceptualFigure.m
	Outputs plot of 2017 phosphorus surplus (x-axis) and 2017 cumulative surplus (y-axis). Regional surplus and cumulative surplus in 2017 are also plotted (Supplemental Figure 3).

FIG_Region1-4_Cropland_Pasture.py
	Exploring crop and pastureland P uptake for each region. This analysis used in Section 3.2 (Supplemental Figure 1) to understand the relative proportions of P removed by crop and pasture in regions 1 through 4.

FIG_ManucriptMetrics.m
	Script that outputs all the reported metrics in manuscript. 