
######################### [INSTALLATION DES PACKAGES] ###########
install.packages("leaflet",dependencies = TRUE)
install.packages("htmltools",dependencies = TRUE)
install.packages("rgdal",dependencies = TRUE)
#################################################################

##Uploaderles packages dont on a besoin
library(leaflet)    #to create the map             
library(rgdal)      #to read the shape (données spaciales)
library(htmltools)  #For the labels

mymap <- readOGR("dz_map/dzaBound.shp") #read the shape of the map
mydata <- read.csv("data3.csv")         #read the data

mydata$Label <- paste("<center><p><b>",mydata$Province,"</b></p></center>",
                      "<p><b>Incidence: </b>", mydata$Incidence, "</p>",
                      "<p><b>Inside dwellings: </b>", mydata$Inside_dwellings,"=>", round(mydata$Inside_dwellings/(mydata$Outside_dwellings+mydata$Inside_dwellings)*100,2), "%</p>",
                      "<p><b>Outside dwellings: </b>", mydata$Outside_dwellings,"=>", round(mydata$Outside_dwellings/(mydata$Outside_dwellings+mydata$Inside_dwellings)*100,2), "%</p>",
                      "<p><b>Total</b>",mydata$Inside_dwellings+mydata$Outside_dwellings,"=>",(mydata$Outside_dwellings/(mydata$Inside_dwellings+mydata$Outside_dwellings))*100+(mydata$Inside_dwellings/(mydata$Inside_dwellings+mydata$Outside_dwellings))*100,"%</p>")   #the label shown when hover the province
mymap <- subset(mymap, is.element(mymap$nam, mydata$Province))   #match the map with the data (merge)

bins <-c(140, 160 ,180, 200, 220, 240, 260, 280, 300, 320, 340, 360)  #interval of data
palette <- colorBin(c("#001F47", "#BE3793"), domain = mydata$Incidence, bins = bins)   #gradiant color

m<- leaflet() %>% 
  addProviderTiles(providers$OpenStreetMap.HOT) %>%  #simple map
  setView(lng = 0.0000, lat = 35.4021, zoom = 7) %>%   #set the view in the coordinate
  addPolygons(data = mymap,                           
              color = "white",              #the map of Algeria
              weight = 1,
              smoothFactor = 0.5,
              fillOpacity = 0.8,
              fillColor = palette(mydata$Incidence),
              #
              label = lapply(mydata$Label, HTML))  %>%
  addLegend(pal = palette, values = mydata$Incidence,    #the map-scale
            opacity = 0.7,                    
            title = "Incidence",
            position = "bottomright")
m
library(htmlwidgets)
saveWidget(m,file = "dynamic_map.html") #exportation de la carte


