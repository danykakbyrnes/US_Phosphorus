# Clipping Watersheds to N Surp
library(rgdal)        # To load "shapefiles" into R and use in conversions of spatial formats 
library(sf)           # To load "shapefiles" into R and use in conversions of spatial formats 
library(raster)
library(tidyverse)
library(ggplot2)
library(xlsx)
setwd("B:/LabFiles/users/DanykaByrnes")
# ******************************************************************************
# This script takes the N Surplus data and clips the watersheds with the data. 
# The result is a shapefile with the countries clipped and an extra column that
# calculates the fraction of the county that is within the watershed boundary.
# This later gets aggregated in the 
#find("colMedians")
#  [1] "package:matrixStats"

# ******************************************************************************
# Setting up file paths
OUTPUT_folders = '3 TREND_Nutrients/TREND_Nutrients/OUTPUTS/TREND_P_Version_1.2/PUE/'
INPUT_folders = '3 TREND_Nutrients/TREND_Nutrients/INPUTS_061322/'

# Reading in N Surplus
Component = c('Total_PUE.shp', 'Manure_PUE.shp','Inorganic_Fert_PUE.shp', 
              'Cropland_Fraction.shp', 'Pastureland_Fraction.shp',
              'Manure_AgLand.shp','Fertilizer_AgLand.shp', 
              'Crop_AgLand.shp','Comb_AgLand.shp')
ComponentNames = c('TotalPUE','ManurePUE','InorgPUE', 'Cropland', 
                   'Pastureland', 'Manure_AGHA', 'Fertilizer_AGHA',
                   'Crop_AGHA', 'Comb_AGHA')
MatchProj = st_read(paste0(INPUT_folders,'0 General Data/CountyShapefiles/US_CountyShapefile_2017.shp'))

HUC2 = st_read(paste0(INPUT_folders,'0 General Data/HUC2/merged_HUC2_5070_v3.shp'))
st_crs(HUC2) = st_crs(MatchProj)[2][[1]]

for (i in 1:length(Component)){
  # Reading in N Surplus
  Component_i = Component[i]
  PUE = st_read(paste0(OUTPUT_folders,Component_i))
  ls = dim(HUC2)[1]

  HUC_PUE_min = data.frame()
  HUC_PUE_max = data.frame()
  HUC_PUE_mean = data.frame()
  HUC_PUE_median = data.frame()
    for (j in 1:ls){
    print(j)
    HUC_PUE_t = data.frame(HUCID = character())
    PUE_t = PUE
    st_crs(PUE_t) = st_crs(MatchProj)[2][[1]]
    
    
    # Reading the watersheds from the big file 
    HUC_ID = HUC2[[j,1]]
    HUC2_j = HUC2[j,]
    
    HUC2_j_Surplus = try(st_intersection(PUE_t, HUC2_j), silent = TRUE)
    
#    if (inherits(HUC2_j_Surplus,"try-error")) {
#      HUC2_j = st_buffer(HUC2_j,0)
#      PUE_t = st_buffer(PUE_t,0)
#      HUC2_j_Surplus =  st_intersection(PUE_t, HUC2_j)
#    }

    limits = c(which( colnames(HUC2_j_Surplus)=="Y1930"), which( colnames(HUC2_j_Surplus)=="Y2017"))
    HUC2_j_Surplus = st_set_geometry(HUC2_j_Surplus, NULL)
    PUE_t = HUC2_j_Surplus[,limits[1]:limits[2]]
    #PUE_t[PUE_t > 10] = NA
    PUE_t[is.na(PUE_t)] = 0
  
    #HUC_PUE_stat = colMedians(PUE_t) #colMeans(PUE_t)
    #test = apply(PUE_t,2,median)
    #HUC_PUE_stat = t(as.data.frame(HUC_PUE_stat))
    #row.names(HUC_PUE_stat) = NULL
    #HUC_PUE_t = cbind(HUC_PUE_t,HUC_PUE_stat)
    #HUC_PUE = rbind(HUC_PUE, HUC_PUE_t)
    
    min_t <- apply(PUE_t, 2, min)  
    max_t <- apply(PUE_t, 2, max)
    median_t <- apply(PUE_t, 2, median)
    mean_t <- apply(PUE_t, 2, mean)
    
    min_t <- as.data.frame(t(min_t))
    max_t  <- as.data.frame(t(max_t))
    median_t <- as.data.frame(t(median_t))
    mean_t <- as.data.frame(t(mean_t))
    
    min_t = cbind(HUC_ID, min_t)
    max_t = cbind(HUC_ID, max_t)
    mean_t = cbind(HUC_ID, mean_t)
    median_t = cbind(HUC_ID, median_t)
    
    HUC_PUE_min = rbind(HUC_PUE_min, min_t)
    HUC_PUE_max = rbind(HUC_PUE_max, max_t)
    HUC_PUE_mean = rbind(HUC_PUE_mean, mean_t)
    HUC_PUE_median = rbind(HUC_PUE_median, median_t)
    }

  write.xlsx(HUC_PUE_min, file = paste0(OUTPUT_folders,'HUC2_',ComponentNames[i],'.xlsx'),
             sheetName = "Min", row.names = FALSE, append = FALSE)
  
  write.xlsx(HUC_PUE_max, file = paste0(OUTPUT_folders,'HUC2_',ComponentNames[i],'.xlsx'),
             sheetName = "Max", row.names = FALSE, append = TRUE)
  write.xlsx(HUC_PUE_mean, file = paste0(OUTPUT_folders,'HUC2_',ComponentNames[i],'.xlsx'),
             sheetName = "Mean", row.names = FALSE, append = TRUE)
  write.xlsx(HUC_PUE_median, file = paste0(OUTPUT_folders,'HUC2_',ComponentNames[i],'.xlsx'),
             sheetName = "Median", row.names = FALSE, append = TRUE)
}
