  library(dataRetrieval)
  library(stringr)
  library(EGRET)
  #library(dplyr)
  
  INPUT_folders = 'D:/Danyka/9 Phopshorus Use Efficiency/INPUTS_103122/2 Water Quality/eLists/'
  OUTPUT_folders = 'D:/Danyka/9 Phopshorus Use Efficiency/OUTPUTS/ExportRatios/WRTDSresults/'
  metadata_filename = 'METADATA_20230309.txt'
  
  files = list.files(path = INPUT_folders, pattern=glob2rx('*Total Phosphorus*'))
  
  # Recording the watershed metadata
  Metadata <- data.frame(matrix(ncol = 10, nrow = 0))
  colnames(Metadata) = c("Site","SiteName","StreamgageNumber","DrainageArea_km2","State","Latitude","Longitude","MinYear","MaxYear","FluxBias")
  
  for ( i in 1:length(files)) { 
  
     file_i = files[i]
     
     # Is it a rejected watershed?
     subFile_i = str_sub(file_i ,-12,-1)
     if (subFile_i == 'rejected.rds') {
       next
     }
     
     eList_file = readRDS(paste0(INPUT_folders,file_i)) 
     
     # Isolating the WRTDS results
     Daily_elist = eList_file$Daily
     NoData = which(is.na(Daily_elist$ConcDay))
     
     # Removing the No Data entries
     if (!identical(NoData, integer(0))) {
      Daily_elist = Daily_elist[-NoData,]
     }
     
     # Isolate each year and sum total load
     Years = floor(Daily_elist$DecYear)
     unYears = unique(Years)
    
     # Populating the metadata table
     INFO = eList_file$INFO
     Metadata[i,1:7] = c(INFO$Site_no, INFO$shortName, INFO$Gage_number, 
                      INFO$drainSqKm, INFO$staAbbrev, INFO$dec_lat_va, 
                      INFO$dec_long_va)
     
     # Populate the dataframe with annual statistics
     Export_WQ <- data.frame(matrix(ncol = 4, nrow = 0))
     
        for (j in 1:length(unYears)) {
          
          idx = which(Years == unYears[j])
          
          if (length(idx) >= 365) {
            Daily_elist_j = Daily_elist[idx,]
            Load_j = sum(Daily_elist_j$FluxDay)
            FWC_j = sum(Daily_elist_j$Q*Daily_elist_j$ConcDay)/(sum(Daily_elist_j$Q))
            Q_j = mean(Daily_elist_j$Q)
            
            DFappend = c(unYears[j],Q_j, Load_j, FWC_j)
            Export_WQ = rbind(Export_WQ, DFappend)
            
          }
          
        }
     
     # Exporting WQ data
     colnames(Export_WQ) = c("Year","MeanQ","Load","FWC")
     write.csv(Export_WQ, file = paste0(OUTPUT_folders,INFO$Site_no,'.txt'), row.names = FALSE)
     
     # Getting the remaining details for metadata
     Metadata[i,8] = min(Export_WQ$Year)
     Metadata[i,9] = max(Export_WQ$Year)
     Sample <- getSample(eList_file)
     fluxBias <- fluxBiasStat(Sample) 
     Metadata[i,10] = fluxBias[3]
     
  }
  
   # Removing the No Data entries
  NoWtsdData = which(is.na(Metadata$Site))
  Metadata = Metadata[-NoWtsdData,]
  
  write.csv(Metadata, file = paste0(OUTPUT_folders,metadata_filename), row.names = FALSE)
  
  
  which(Metadata$MaxYear < 2010)