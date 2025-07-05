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

ANA_Region_5_6_Surplus.py
	**Do i use this one??**

ANA_Region1-4_CropFertilizerUse.py
	Exploring fertilizer use for the four main field crops (corn, soy, wheat, cotton) for each state. 

** FIGURES **



FIG_Region1-4_Cropland_Pasture.py
	Exploring crop and pastureland P uptake for each region. This analysis used in Section 3.2 (Supplemental Figure 1) to understand the relative proportions of P removed by crop and pasture in regions 1 through 4.
