
### loading required packages ######
library(ggmap)
library(leaflet)
library(dplyr)
library(readODS)
library(stringr)

#### reading data ######

adresy.basia<-read_ods("Trasa Basia.ods")

### preparing data ######

adresy_lista<-str_split(adresy.basia$Adres,"/",simplify = TRUE)[,1]
ostatnia_spacja<-str_locate(adresy_lista,"[:space:][0-9]")
numer_domu<-str_trim(str_sub(adresy_lista, ostatnia_spacja[,1], str_length(adresy_lista)))
ulica<-str_sub(adresy_lista, 1, ostatnia_spacja[,1]-1)

adresy.paste<-paste(numer_domu, ulica, adresy.basia$Miejscowość, adresy.basia$`Kod pocztowy`, sep=", ")

label.basia<-paste(adresy.basia$Nazwa,
                   paste(adresy.basia$Adres,
                   paste(adresy.basia$`Kod pocztowy`, adresy.basia$Miejscowość, sep=' '), sep="<br/>"), sep="<br/>")

#label<-paste(paste(adresy$Ulica,adresy$Numer, sep = ' '), paste(adresy$Kod.pocztowy, adresy$miasto, sep=' '), sep="<br/>")

#### checking geocodes ######

#b<-geocode(a)
geocode.basia<-geocode(adresy_paste2)

d<-cbind(adresy,b,label)

prepared.basia<-cbind(adresy.paste, geocode.basia, label.basia)

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

