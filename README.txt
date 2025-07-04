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

DATA_HUC2_Components_clip.R
	Clipping gTREND components and agricultural surplus 

** ANALYSIS SCRIPTS **


** FUNCTIONS **
ANAL_PhosphorusUseEfficiency_gridded.m
	Reads in the gridded data from TREND Output files and calculates the PUE for the gridded data. 

