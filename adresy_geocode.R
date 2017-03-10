
### loading required packages ######
library(ggmap)
library(leaflet)
library(dplyr)

#### reading data, checking geocodes ######

adresy<-na.omit(read.table("adresy.csv",sep=";",header = TRUE, stringsAsFactors = FALSE))
a<-paste(adresy$Numer, adresy$Ulica, adresy$miasto,adresy$Kod.pocztowy,adresy$Kraj, sep = ", ")
b<-geocode(a)
d<-cbind(adresy,b)

### creating groups for layers #####

layer_Jerzy<- d%>%
  filter(.,Pracownik=="Jerzy")

layer_Barbara<-d%>%
  filter(.,Pracownik=="Barbara")

### generating map ###############

(m_markers<- leaflet()%>%
  addTiles()%>%
  addProviderTiles(providers$OpenTopoMap)%>%
  addMarkers(data=layer_Jerzy, ~lon, ~lat, group="Jerzy",label = ~Pracownik)%>%
  addMarkers(data=layer_Barbara, ~lon, ~lat, group="Barbara",label = ~Pracownik))%>%
  addLayersControl(overlayGroups=c("Jerzy","Barbara"))


write.csv(d,"adresy_wspolrzedne.csv")

