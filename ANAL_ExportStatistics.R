library(xlsx)

OUTPUT_folders = 'D:/Danyka/9 Phopshorus Use Efficiency/OUTPUTS/ExportRatios/'
WQ_folder = 'WRTDSresults/'
fileName = 'ErRatio_20230421.txt'

ZonalStatsYEAR = 2010
METDA = read.xlsx(paste0(OUTPUT_folders, 'Watershed_PropertyTable_20230309.xlsx'), sheetName = 'WatershedProperties')
PS = read.csv(paste0(OUTPUT_folders,'PS_2010_ZonalStatistics.csv'))

METDA$PS_2010 = NA
METDA$Load_2010 = NA
METDA$ExportRatio_2010 = NA

for (i in 1:dim(METDA)[1]) {

  Site_i = METDA$Site[i]
  AREA_i = METDA$DrainageArea_km2[i]*100
  WatershedID_i = METDA$WatershedNumber[i]
  
  # Isolating the P Surplus
  idxPS = which(PS$BasinID == WatershedID_i)
  PS_i = PS$PS2010_mean[idxPS]
  
  # Isolating appropriate loads
  WQ = read.csv(paste0(OUTPUT_folders,WQ_folder,Site_i,'.txt')) 
  idxYear = which(WQ$Year == ZonalStatsYEAR)
  Load_i = WQ$Load[idxYear]/AREA_i # Not normalized.
  
  if (identical(Load_i, numeric(0))) {
    next }
  
  ExportRatio = Load_i/PS_i
  
  METDA$PS_2010[i] = PS_i
  METDA$Load_2010[i] = Load_i
  METDA$ExportRatio_2010[i] = ExportRatio
  
}

write.csv(METDA, file = paste0(OUTPUT_folders,fileName), row.names = FALSE)
