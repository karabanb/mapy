
library(ggplot2)
library(eurostat)
library(dplyr)
library(stringr)

#### mapa w ggplot ######

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

 ##### mapa do tableau ######

unempolyement<-get_eurostat("ei_lmhr_m")%>%filter(time>="2005-01-01")
unempolyement$time<-str_sub(as.character(unempolyement$time),0,7)

## trying join...

unempolyement.join<-full_join(unempolyement,eu_countries, by=c("geo"="code"))%>%na.omit()
write.table(unempolyement.join,"unemployement.csv", row.names = FALSE, quote = FALSE, sep=",")




