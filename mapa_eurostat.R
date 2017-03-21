
library(eurostat)
library(leaflet)
library(sp)
library(dplyr)
library(ggplot2)


dane<-get_eurostat(id="tec00113", time_format = "num")

##'%!in%' <- function(x,y)!('%in%'(x,y))

## dane<-dane[dane$geo %!in% c("EU28","EA19"),]

dane_2004<-dane%>%
  filter(time=="2004")%>%
  mutate(cat=cut_to_classes(values,n=9,style = "equal"))

dane_2014<-dane%>%
  filter(time=="2014")%>%
  mutate(cat=cut_to_classes(values,n=9, style="equal"))

EU28<-filter(dane,geo %in% c("EU28"))

full.data<-left_join(dane,EU28, by="time")

#cut_vector<-round(seq(0.3,1.7,0.20), digits = 4)
  
full.data<-full.data%>%
  mutate(value=full.data$values.x/full.data$values.y)%>%
  mutate(cat=cut_to_classes(value,n=11,style = "pretty",decimals = 2))%>%
  select(geo.x, time, value, cat)%>%
  filter(time <2015)%>%
  rename(geo=geo.x)
  
full.data2004<-full.data%>%
  filter(time==2004)

full.data2014<-full.data%>%
  filter(time==2014)


mapdata_2004<-merge_eurostat_geodata(full.data2004, resolution = "20")
mapdata_2014<-merge_eurostat_geodata(full.data2014, resolution = "20")
mapdata<-merge_eurostat_geodata(full.data, resolution = "20")

#EU28<-filter(dane,geo %in% c("EU28"))

mapa_2004<-ggplot(mapdata_2004, aes(x=long, y=lat, group=group)) + 
  geom_polygon(aes(fill=cat),color="black", size=.1) +
  scale_fill_brewer(palette = "RdYlBu")+ theme_light()+ 
  coord_map(xlim=c(-12,44), ylim=c(35,67))

mapa_2004

mapa_2014<-ggplot(mapdata_2014, aes(x=long, y=lat, group=group)) + 
  geom_polygon(aes(fill=cat),color="black", size=.1) +
  scale_fill_brewer(palette = "RdYlBu")+ theme_light()+ 
  coord_map(xlim=c(-12,44), ylim=c(35,67))

mapa_2014

mapa_full<-ggplot(mapdata, aes(x=long, y=lat, group=group)) + 
  geom_polygon(aes(fill=cat),color="black", size=.1) +
  scale_fill_brewer(palette = "Greys")+ theme_light()+ 
  coord_map(xlim=c(-12,44), ylim=c(35,67)) + facet_wrap(~time)


dane_2015<-filter(dane, time=="2015")



