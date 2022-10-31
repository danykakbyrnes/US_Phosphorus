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
  
  # P Surplus Plots (1930 to 2012) -------------------------------------------
  # This section is used to generate P Surplus Plots (US) for every year. 
  
  setwd("B:/LabFiles/users/DanykaByrnes/3 TREND_Nutrients/TREND_Nutrients/TREND_P_1.2")
  
  INPUT_folderName = '../INPUTS_061322/'
  OUTPUT_folderName = '../OUTPUTS/TREND_P_Version_1.2/'
  
  MatchProj = st_read(paste0(INPUT_folderName, '0 General Data/CountyShapefiles/US_CountyShapefile_2017.shp'))
  data.shape = st_read(paste0(OUTPUT_folderName, 'SHAPEFILES/PSurplus.shp'))
  stateOutline = st_read(paste0(INPUT_folderName, '0 General Data/cb_2017_us_state_5m/cb_2017_us_state_5m.shp'))
 
  st_crs(data.shape) = st_crs(MatchProj)[2][[1]]
  data.shape$Interval = NA
  from = 1
  to = 88
  for (i in from:to) { 
    YearData = data.shape[[i+10]] # IDK IF THIS IS RIGHT
    i
    
    # if ((i-1)%%5 != 0) {
    #  next
    #  }
  # FIRST IS FOR NSURPLUS, SECOND IS FOR INPUTS. COMMENT OUT WHICH ONE YOU ARE NOT USING  
#  data.shape$Interval = cut(YearData,breaks = c(-Inf,-2, 0, 5, 25, 50, 100, 200, Inf), right = F)
    #MyPallette = c('#4575b4', '#91bfdb','#ffffb2','#fed976','#feb24c','#fd8d3c','#fc4e2a','#b10026')
      data.shape$Interval = cut(YearData,breaks = c(-Inf,-10, -5, 0, 2, 5, 10, 20, Inf), right = F)
  MyPallette = c('#265F7C','#499DC7','#baced8','#ffffbf','#fec980','#f17c4a','#d7191c','#9e1214')
  #MyPallette = c('#4575b4', '#91bfdb','#ffffb2','#fed976','#feb24c','#fd8d3c','#fc4e2a','#e31a1c','#b10026')
  
  #data.shape$Interval = cut(YearData,breaks =  c(0, 5, 10, 20, 50, 100, Inf), right = F)
  #data.shape$Interval = cut(YearData,breaks =  c(0, 5, 10, 20, 30, 40, Inf), right = F)
  #data.shape$Interval = cut(YearData,breaks =  c(0, 2, 5, 10, 15, 20, Inf), right = F)
      currentplot = ggplot(data = data.shape) + geom_sf(aes(fill = Interval), color = "transparent",size=0.0001, show.legend = FALSE) + 
        geom_sf(data = stateOutline,colour="black", fill=NA) +
  
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

  ggsave_name = paste0(OUTPUT_folderName,"TimeseriesPlot/CountyPSurplus_",1929+i,".png")
  #ggsave_name = paste0("TimeseriesPlot/LivestockPlots/CountyLvInputs_",1929+i,".png")
  
  ggsave(ggsave_name,plot = currentplot, bg = "transparent",height = 7 , width = 7 * aspect_ratio) 
  
  }
  