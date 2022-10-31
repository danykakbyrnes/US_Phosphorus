  library(plyr)         # To manipulate data
  library(ggplot2)      # To have ggplot2 graphic interface
  library(rgdal)        # To load "shapefiles" into R and use in conversions of spatial formats 
  library(rgeos)        # To use in geometrical operations
  library(sp)           # Methods for retrieving coordinates from spatial objects.
  library(maptools)     # A package for building maps
  library(RColorBrewer) # To build RColorBrewer color palettes
  library(rgdal)
  library(sf)
  library(tidyr)
  library(dplyr)
  library(maptools)
  
  rm(list = ls(all.names = TRUE)) #will clear all objects includes hidden objects.
  gc() #free up memory and report the memory usage.
  cat("/014") # clear console 
  
  # PSurplus Plots (1930 to 2012) -------------------------------------------
  # This section is used to generate NSurplus Plots (US) for every year. 
  setwd("B:/LabFiles/users/DanykaByrnes/3 TREND_Nutrients/TREND_Nutrients/TREND_P_1.2")
  
  INPUT_folderName = '../INPUTS_061322/'
  OUTPUT_folderName = '../OUTPUTS/TREND_P_Version_1.2/'
  
  MatchProj = st_read(paste0(INPUT_folderName, '0 General Data/CountyShapefiles/US_CountyShapefile_2017.shp'))
  data.shape = st_read(paste0(OUTPUT_folderName, 'SHAPEFILES/CumAgPSurplus.shp'))
  stateOutline = st_read(paste0(INPUT_folderName, '0 General Data/cb_2017_us_state_5m/cb_2017_us_state_5m.shp'))
  
  st_crs(data.shape) = st_crs(MatchProj)[2][[1]]
  data.shape$Interval = NA
  from = 1
  to = 88
  
  for (i in from:to) { 
    YearData = data.shape[[i+10]] # IDK IF THIS IS RIGHT
    i
    
    if ((i-1)%%10 != 0) {
     next}
    
  data.shape$Interval = cut(YearData,breaks = c(-Inf, 0, 100, 200, 500, 750, Inf), right = F)
  MyPallette = c('#81bad8','#ffffbf','#fec980','#f17c4a','#d7191c', '#8e1214')
  
  currentplot = ggplot() + geom_sf(data = data.shape, aes(fill = Interval, color = Interval), show.legend = FALSE) + 
                geom_sf(data = stateOutline, colour="black", size=0.25, fill=NA) +
    
    #fill using the palette defined above.
    scale_fill_manual(values = MyPallette, aesthetics = "fill") + 
    scale_color_manual(values = MyPallette, aesthetics = "colour") +

    #theme with white background
    theme_bw() +
    
    #eliminates background, gridlines, and chart border
    theme(
      plot.background = element_blank()
      ,panel.grid.major = element_blank()
      ,panel.grid.minor = element_blank()
      ,panel.border = element_blank()
    ) +
  
    #draws x and y axis line
    theme(axis.line = element_line(color = 'transparent')) +
    #gets rid of lat long lines
    theme(panel.grid.major = element_line(colour = 'transparent')) +
    
    #getting rid of the axis
    theme(axis.text.x = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          rect = element_blank()) + theme(plot.title = element_text(hjust = 0.1, vjust = -32, size = 55, face = 'bold')) +
      ggtitle(paste(1929+i)) +
  
    theme(plot.margin = unit(c(0.5,0.5,0.5,0.5), "cm"), plot.title = element_text(color="black",face="bold"))
      
      aspect_ratio <- 1.5
      height <- 7
      ggsave_name = paste0(OUTPUT_folderName,"TimeseriesPlot/Cumulative Ag P Surplus/CumAgPSurplus_",1929+i,".png")
      
      ggsave(ggsave_name,plot = currentplot, bg = "transparent",height = 7 , width = 7 * aspect_ratio) 
  }