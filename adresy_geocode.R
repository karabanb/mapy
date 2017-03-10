
library(ggmap)
library(leaflet)
adresy<-na.omit(read.table("adresy.csv",sep=";",header = TRUE, stringsAsFactors = FALSE))
a<-paste(adresy$Numer, adresy$Ulica, adresy$miasto,adresy$Kod.pocztowy,adresy$Kraj, sep = ", ")
a<-address_cleaner(a)
b<-geocode(a)
c<-cbind(a,b)
d<-cbind(adresy,b)

(m_markers<- leaflet(data = c)%>%
  addTiles()%>%
  addMarkers(~lon, ~lat))

write.csv(d,"adresy_wspolrzedne.csv")

