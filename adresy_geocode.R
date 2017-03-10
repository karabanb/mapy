
### loading required packages ######
library(ggmap)
library(leaflet)
library(dplyr)

#### reading data, checking geocodes ######

adresy<-na.omit(read.table("adresy.csv",sep=";",header = TRUE, stringsAsFactors = FALSE))
a<-paste(adresy$Numer, adresy$Ulica, adresy$miasto,adresy$Kod.pocztowy,adresy$Kraj, sep = ", ")
label<-paste(paste(adresy$Ulica,adresy$Numer, sep = ' '), paste(adresy$Kod.pocztowy, adresy$miasto, sep=' '), sep="<br/>")
b<-geocode(a)
d<-cbind(adresy,b,label)

### creating groups for layers #####

layer_Jerzy<- d%>%
  filter(.,Pracownik=="Jerzy")

layer_Barbara<-d%>%
  filter(.,Pracownik=="Barbara")

### generating map ###############

(m_markers<- leaflet()%>%
  addTiles()%>%
  addProviderTiles(providers$OpenTopoMap)%>%
  addMarkers(data=layer_Jerzy, ~lon, ~lat, group="Jerzy",popup = ~label)%>%
  addMarkers(data=layer_Barbara, ~lon, ~lat, group="Barbara",popup = ~label))%>%
  addLayersControl(overlayGroups=c("Jerzy","Barbara"))


write.csv(d,"adresy_wspolrzedne.csv")

