library(readr)
library(readxl)

OUTPUT_folders = 'B:/LabFiles/users/DanykaByrnes/9 Phosphorus Use Efficiency/OUTPUTS/ExportRatios/'
WQ_folder = 'WRTDSresults/'
fileName = 'ErRatio_20230609.txt'

ZonalStatsYEAR = 2010
METDA = read_excel(paste0(OUTPUT_folders, 'Watershed_PropertyTable_20230309.xlsx'))
PS = read_csv(paste0(OUTPUT_folders,'PS_2010_ZonalStatistics.csv'))
HUM = read_csv(paste0(OUTPUT_folders,'HUM_2010_ZonalStatistics.csv'))
LVK = read_csv(paste0(OUTPUT_folders,'LVK_2010_ZonalStatistics.csv'))
AFRT = read_csv(paste0(OUTPUT_folders,'AFRT_2010_ZonalStatistics.csv'))

METDA$PS_2010 = NA
METDA$HUM_2010 = NA
METDA$LVK_2010 = NA
METDA$AFRT_2010 = NA
METDA$Load_2010 = NA
METDA$ExportRatio_2010 = NA

for (i in 1:dim(METDA)[1]) {

  Site_i = METDA$Site[i]
  AREA_i = METDA$DrainageArea_km2[i]*100
  WatershedID_i = METDA$WatershedNumber[i]
  
  # Isolating the P Surplus
  idxPS = which(PS$BasinID == WatershedID_i)
  PS_i = PS$PS2010_mean[idxPS]
  HUM_i = HUM$`_HUMmean`[idxPS]
  LVK_i = LVK$`_meanmean`[idxPS]
  AFRT_i = AFRT$`_meanmean`[idxPS]
  
  # Isolating appropriate loads
  WQ = read.csv(paste0(OUTPUT_folders,WQ_folder,Site_i,'.txt')) 
  idxYear = which(WQ$Year == ZonalStatsYEAR)
  Load_i = WQ$Load[idxYear]/AREA_i # Not normalized.
  
  if (identical(Load_i, numeric(0))) {
    next }
  
  ExportRatio = Load_i/PS_i
  
  METDA$PS_2010[i] = PS_i
  METDA$HUM_2010[i] = HUM_i
  METDA$LVK_2010[i] = LVK_i
  METDA$AFRT_2010[i] = AFRT_i
  METDA$Load_2010[i] = Load_i
  METDA$ExportRatio_2010[i] = ExportRatio
  
}

write_csv(METDA, file = paste0(OUTPUT_folders,fileName))
