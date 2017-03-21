
### loading required packages ######
library(ggmap)
library(leaflet)
library(dplyr)
library(readODS)
library(stringr)

#### reading data ######

#adresy<-na.omit(read.table("adresy.csv",sep=";",header = TRUE, stringsAsFactors = FALSE))
adresy.basia<-read_ods("Trasa Basia.ods")

### preparing data ######
#a<-paste(adresy$Numer, adresy$Ulica, adresy$miasto,adresy$Kod.pocztowy,adresy$Kraj, sep = ", ")

adresy_lista<-str_split(adresy.basia$Adres,"/",simplify = TRUE)[,1]

adresy_paste<-paste(adresy_lista,adresy.basia$Miejscowość, adresy.basia$`Kod pocztowy`, sep=", ")
label.basia<-paste(adresy.basia$Nazwa,
                   paste(adresy.basia$Adres,
                   paste(adresy.basia$`Kod pocztowy`, adresy.basia$Miejscowość, sep=' '), sep="<br/>"), sep="<br/>")

#label<-paste(paste(adresy$Ulica,adresy$Numer, sep = ' '), paste(adresy$Kod.pocztowy, adresy$miasto, sep=' '), sep="<br/>")

#### checking geocodes ######

#b<-geocode(a)
geocode.basia<-geocode(adresy_paste)

d<-cbind(adresy,b,label)

prepared.basia<-cbind(adresy.basia, geocode.basia, label.basia)

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

(m_markers<- leaflet()%>%
    addTiles()%>%
    addProviderTiles(providers$OpenTopoMap)%>%
    addMarkers(data=prepared.basia, ~lon, ~lat,popup = ~label.basia)
    
  )


write.csv(d,"adresy_wspolrzedne.csv")

