### leflet options ######

leaflet(options = leafletOptions(minZoom = 0, maxZoom = 18))

#### loading map ######

library(leaflet)
library(ggmap)
library(rgdal)

m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=16.20431, lat=51.40322, popup="The birthplace of R") %>%
  setView(lng=16.2, lat=51.4,zoom=13)

#### adding data ######

### adding circles ####

df<-data.frame(Lat=c(1:10), Long=rnorm(10))

leaflet()%>%
  addCircles(data = df)

#### adding polygons ####

library(sp)
library(maps)

map_states<-map("state",fill = T, plot = F)

leaflet(data = map_states) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

#### choosing base map ######

m_provider<-leaflet()%>%
  addTiles() %>%
  addProviderTiles(providers$HikeBike) %>%
  setView(lng=16.2, lat=51.4,zoom=12)

#### adding markers #######

data("quakes")

m_markers<- leaflet(data = quakes[1:20,])%>%
  addTiles()%>%
  addMarkers(~long, ~lat,popup=~as.character(mag),label=~as.character(mag))
  
#### adding marker clusters ######

m_clusters<-leaflet(data=quakes[1:100,])%>%
  addTiles()%>%
  addProviderTiles(providers$OpenSeaMap)%>%
  addMarkers(~long,
             ~lat,
             clusterOptions=markerClusterOptions(), ## the most important
             label=~as.character(mag))

### adding layers ##############




#### loading shp files #########

wojewodztwa<-readOGR("/Users/bk/wojewodztwa/wojewodztwa.shp",GDAL1_integer64_policy = TRUE)
wojewodztwa <- spTransform(wojewodztwa,  CRS("+proj=longlat +datum=WGS84"))

powiaty<-readOGR("/Users/bk/PRG_jednostki_administracyjne_v14/powiaty.shp")
powiaty<- spTransform(powiaty,  CRS("+proj=longlat +datum=WGS84"))

leaflet(wojewodztwa)%>%addPolygons(weight = 2,)%>%addProviderTiles(providers$OpenStreetMap)

leaflet(powiaty)%>% addPolygons(weight=1)%>%addProviderTiles(providers$OpenStreetMap)

#### filling polygons by color #####

score<-rnorm(16)
wojewodztwa$score<-score

pal<-colorBin("YlOrRd", domain = wojewodztwa$score, bins = score)

leaflet(wojewodztwa)%>%
  addProviderTiles(providers$OpenStreetMap)%>%
  addPolygons(fillColor = ~pal(score),
              weight=2,
              opacity=1,
              color="white",
              dashArray="3",
              fillOpacity = 0.7,
              highlight = highlightOptions(
                weight = 2,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE))

#### geting geocode from address ####






