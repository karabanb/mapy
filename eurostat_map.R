
library(ggplot2)
library(eurostat)
library(dplyr)

bands<-seq(0.1,1.3,0.1)

export<-get_eurostat("tet00003")%>%
  filter(time<"2017-01-01",
         geo!="LU",
         geo!="MT",
         geo!="IE")%>%
  mutate(cat=cut_to_classes(values, style = "pretty", n=10))
  

mapdata<-merge_eurostat_geodata(export, resolution = "20")

ggplot(mapdata, aes(x=long,y=lat,group=group))+
  geom_polygon(aes(fill=cat), color="grey", size=.1)+
  scale_fill_brewer(palette = "RdYlBu")+
  facet_wrap(~time)+
  coord_map(xlim=c(-12,44), ylim=c(35,67))+
  theme_light()

filter(export, values>90)




