
######################### [INSTALLATION DES PACKAGES] ###########
install.packages("sf",dependencies = TRUE) #permettant d'importer, de manipuler et de transformer les données spatiales
install.packages("ggplot2",dependencies = TRUE) #permettant d'afficher des objets spatiaux et de réaliser des cartes thématiques simples
install.packages("data.table",dependencies = TRUE) #permettant de traiter les données en tableau
install.packages("viridis",dependencies = TRUE)  #palette de couleur  
install.packages("viridisLite",dependencies = TRUE)
#################################################################


######################### [ INCIDENCE ]###########################

##Uploader les packages dont on a besoin
library(sf)
library(ggplot2)
library(data.table)
library(viridisLite)
library(viridis)


setwd('C:/Users/Katia/Documents/ETUDE/M1/Bio-stat/tp/Mapping')  #se mettre dans l'espace de travail

donnees <- as.data.frame(fread(file = "data3.csv",header = TRUE))  #importer les données

map <- st_read('dz_map/dzaBound.shp',stringsAsFactors=FALSE)  #importer la carte de l'algérie
map[c("FIRST_f_co","FIRST_f__1","FIRST_coc","FIRST_soc")] <- list(NULL)  #ignore the maps that we won't use
plot(map) #visualiser la carte
map_donnees <- merge(donnees , map, by.x ='Province',by.y = 'nam',sort = TRUE) #merge the data with the map

incidence <- ggplot(map_donnees,aes(fill=Incidence))+  #fill the map according to incidence
  geom_sf(aes(geometry=geometry))+
  labs(title='Spatial distribution of incidence by location',y="Latitude",x="Longitude",subtitle = "By SOUKEUR Seif Eddine & KADID Katia"
       , caption = "Map: West of Algeria")+
  theme(legend.position = "bottom")+
  scale_fill_viridis(
    option = "cividis", 
    direction = -1,
    name = "Incidence",
    guide = guide_colorbar(
      direction = "horizontal",
      barheight = unit(4, units = "mm"),
      barwidth = unit(100, units = "mm"),
      draw.ulim = F,
      title.position = 'top',
      title.hjust = 0.5,
      label.hjust = 0.5
    ))
incidence <- incidence +  geom_sf_label(aes(label = Province , geometry = geometry),fill="transparent",fontface = 'bold',color = 'black', label.size = NA)
incidence
#library(webshot)
#install_phantomjs()
#library(mapview)
#mapshot(incidence,file="incidence_map.png")


##################[ INSIDE DWELLINGS ]#########################

inside_dwellings <- ggplot(map_donnees,aes(fill=Inside_dwellings))+  #fill the map according to incidence
  geom_sf(aes(geometry=geometry))+
  labs(title='Spatial distribution of Inside dwellings by location',y="Latitude",x="Longitude",subtitle = "By SOUKEUR Seif Eddine & KADID Katia"
       , caption = "Map: West of Algeria")+
  theme(legend.position = "bottom")+
  scale_fill_gradient(low='#975959' ,high ='#dd3c3c')
inside_dwellings <- inside_dwellings +  geom_sf_label(aes(label = Province , geometry = geometry),fill="transparent",fontface = 'bold', color = 'white',label.size = NA)
inside_dwellings
#mapshot(inside_dwellings,file="inside_map.png")

###############[OUTSIDE DWELLINGS]#######################

outside_dwellings <- ggplot(map_donnees,aes(fill=Outside_dwellings))+  #fill the map according to incidence
  geom_sf(aes(geometry=geometry))+
  labs(title='Spatial distribution of Outside dwellings by location',y="Latitude",x="Longitude",subtitle = "By SOUKEUR Seif Eddine & KADID Katia"
       , caption = "Map: West of Algeria")+
  theme(legend.position = "bottom")+
  scale_fill_gradient2(low='#9672a7' ,high ='#8192b1') #9672a7 #8192b1
outside_dwellings <- outside_dwellings +  geom_sf_label(aes(label = Province , geometry = geometry),fill="transparent",fontface = 'bold', color = '#651010',label.size = NA)
outside_dwellings
#mapshot(outside_dwellings,file="outside_map.png")

