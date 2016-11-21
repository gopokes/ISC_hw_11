#ISC HW 11(b): Spatial Data in R
#loading required packages
library(raster)
library(rgdal)
library(sp)
library(dplyr)
library(okmesonet)
#Exercise 1: Importing Spatial Data
#importing data
county_borders<-readOGR("./data/county.shp")
NOAA_clim<-readOGR("./data/GIS.OFFICIAL_CLIM_DIVISIONS.shp")
nat_ele<-raster("./data/ok_elev.tif")
#plotting data
plot(county_borders)
plot(NOAA_clim)
plot(nat_ele)
#Exercise 2: Converting Raw Data to Spatial Data
meso_locs<-updatestn()#imports mesonet station location data
meso_locs<-data.frame(meso_locs%>%#uses package:dplyr to filter decomissioned mesonet site locations
  filter(meso_locs$Decommissioned>"2016-12-31"))
summary(meso_locs)#summarizes filtered mesonet site location data
county_borders_crs<-crs(county_borders)
colnames(meso_locs)
meso_coords<-meso_locs[,c(7,6)]#creates object for mesonet locations (lat,lon); used to converting to spatial dataframe
my_spatial_df<-SpatialPointsDataFrame(meso_coords,meso_locs,proj4string = county_borders_crs)#creates spatial points data frame from active mesonet locations and county_borders crs
plot(my_spatial_df)
#Exercise 3: Manipulating and Transforming Spatial Data
extent(county_borders)
extent(NOAA_clim)
extent(nat_ele)
extent(my_spatial_df)
OK_clim<-subset(NOAA_clim,ST_ABBRV="OK",select=c(OBJECTID,STATE,STATE_FIPS,CD_2DIG,STATE_CODE,CLIMDIV,CD_NEW,FIPS_CD,NCDC_GEO_I,NAME,ST_ABBRV,SHAPE_AREA,SHAPE_LEN))
extent(OK_clim)
crs(county_borders)
crs(OK_clim)
crs(nat_ele)
crs(my_spatial_df)
global_crs<-crs(county_borders)
spTransform(OK_clim,global_crs)
spTransform(my_spatial_df,global_crs)
crs(nat_ele,proj4string=global_crs)
crs(OK_clim)
crs(nat_ele)
crs(my_spatial_df)
