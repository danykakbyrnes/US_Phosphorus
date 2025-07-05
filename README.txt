##############################################################################
United States Phosphorus Use Efficiency Paper Scripts
##############################################################################

The following scripts are used to recreate data and figures required for the paper titled [TBD]. 

We use gTREND-phosphorus data found at XX. 

** DATA GENERATION SCRIPTS **
DATA_CumulativePhosphorusSurplus_gridded.m
	Generating .tif files of cumulative surplus sourcing the gTREND data layers. Cumulative surplus is the summation of manure P inputs, fertilizer P inputs, and crop P removal. 

DATA_PhosphorusUseEfficiency_gridded.m
	Generating .tif files phosphorus use effiency sourcing the gTREND data layers. Phosphorus use efficiency is calculated by taking the ratio of crop P removal to total P input (manure and fertilizer).

DATA_AgriculturalSurplus.m
	**not created yet, it's in the gTREND folder but I should move it to this code folder

DATA_HUC2_Surplus_Components.R
	Clipping gTREND components and agricultural surplus to each HUC2 watershed for each year. 

DATA_HUC2_CumultativeSurplus.R
	Clipping gTREND components and agricultural surplus to each HUC2 watershed for each year. 

DATA_HUC2_AgrLandUse_clip.R
	Clipping agricultural land use to HUC2 watersheds for Figure 3.

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
FIG_ManucriptMetrics.m
	Script that outputs all the reported metrics in manuscript. 

FIG_National_Timeseries_Plots.m
	Summarizes and outputs national median, interquartile range, and 5th-95th percentile range. National statistics are plotted and used in Figure 1 and Figure 3b. 

FIG_PercentManureInputs.m
	Summarizes the proportion of manure-derived P inputs (%) 


FIG_Region1-4_Cropland_Pasture.py
	Exploring crop and pastureland P uptake for each region. This analysis used in Section 3.2 (Supplemental Figure 1) to understand the relative proportions of P removed by crop and pasture in regions 1 through 4.
