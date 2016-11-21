#loading required packages
library(raster)
library(rgdal)
library(sp)
library(dplyr)
library(okmesonet)
#1.1
county <- readOGR("./data", layer = "county")
plot(county)
#1.2
CDB <-readOGR("./data", layer = "GIS.OFFICIAL_CLIM_DIVISIONS")
plot(CDB)
#1.3
elevation <- raster("./data/ok_elev.tif")
plot (elevation)
#2.1
loc <- updatestn()
summary(loc)
#2.2
stations <-subset(loc, Decommissioned =="2099-12-31")
summary(stations)
#2.3
a <-crs(county)
a
#2.4
xy <-stations[,c(7,6)]
spdf <- SpatialPointsDataFrame(coords = xy, data = stations, proj4string = CRS("+proj=longlat +datum=NAD83 +no_defs
                                                                               +ellps=GRS80 +towgs84=0,0,0"))
plot(spdf)
#3.1
#oklahoma county boundaries
extent(county)
#NOAA US climate divisions
extent(CDB)
#oklahoma elevation
extent(elevation)
#oklahoma mesonet station locations
extent(spdf)
#3.2
newCDB <-subset(CDB, STATE == "Oklahoma")
extent(newCDB)
#3.3
#crs for Oklahoma county boundaries
crs(county)
#crs for Oklahoma climate divisions
crs(newCDB)
#crs for Oklahoma elevation
crs(elevation)
#crs for Oklahoma Mesonet station
crs(spdf)
#3.4
#oklahoma climate divisions
b<- spTransform(newCDB, crs(county))
crs(b)
#Oklahoma Elevations
e <- rasterToPoints(elevation, spatial = TRUE)
c <- spTransform(e, crs(county))
crs(c)
#Oklahoma Mesonet station locations 
d <- spTransform(spdf, CRSobj = proj4string(county))
crs(d)
#3.5
plot(elevation)
plot(county, add=T)
plot(spdf, add=T)
#3.6
map <- crop(elevation, extent(county))
map1 <- mask(map,county)
plot(map1)
plot(county, add =T)
plot(spdf, add=T)
#3.7
slope <- terrain(map1, opt = 'slope')
aspect <- terrain(map1, opt = 'aspect')
hill = hillShade(slope,aspect, 40,270)
#4.1
plot(hill)
#4.2
plot(hill, box = FALSE, axes = FALSE, legend = FALSE)
#4.3
plot(hill, box = FALSE, axes = FALSE, legend = FALSE, col = gray(0:100/100))
#4.4
plot(hill, box = FALSE, axes = FALSE, legend = FALSE, col = gray(0:100/100))
plot(newCDB, add = TRUE, col = rainbow(9))
#4.5
plot(hill, box = FALSE, axes = FALSE, legend = FALSE, col = gray(0:100/100))
plot(newCDB, add = TRUE, col = rainbow(9, alpha = .15))
#4.6
plot(hill, box = FALSE, axes = FALSE, legend = FALSE, col = gray(0:100/100))
plot(newCDB, add = TRUE, col = rainbow(9, alpha = .15))
plot(county, add = TRUE, border = "gray")
#4.7
plot(hill, box = FALSE, axes = FALSE, legend = FALSE, col = gray(0:100/100))
plot(newCDB, add = TRUE, col = rainbow(9, alpha = .15))
plot(county, add = TRUE, border = "gray")
plot(spdf, add = TRUE, pch = 17)
