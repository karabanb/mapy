
library(ggplot2)
library(eurostat)
library(dplyr)

export<-get_eurostat("tet00003")%>%
  mutate(cat=cut_to_classes(values,n=10))


mapdata<-merge_eurostat_geodata(export, resolution = "20")

ggplot(mapdata, aes(x=long,y=lat))+
  geom_polygon(fill=cat)+
  facet_grid(~time)
