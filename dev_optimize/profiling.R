## Profiling 
library(tidyverse)
library(sf)
library(sf.dotdensity)
library(profvis)


### Example from github

london_shapefile <- sf.dotdensity::london_shapefile
london_election_data <- sf.dotdensity::london_election_data

#get the data to plot
#merge a shapefile with the population data
london_sf_data <- merge(london_shapefile, london_election_data, by = "ons_id")

#the columns we want to select and plot
parties <- names(london_sf_data)[4:8]
#set up a colour scale for these if so inclined
colours = c("deepskyblue", "red", "gold", "purple", "green")
names(colours) = parties

#how many people should lead to one dot
people_per_dots <- 100

profvis(
  {
    london_dots <- calc_dots(df = london_sf_data,
                             col_names = parties,
                             n_per_dot = 10)
  }
)






tStart <- Sys.time()
#calculate the dot positions for each column
london_dots <- calc_dots(df = london_sf_data,
                         col_names = parties,
                         n_per_dot = people_per_dots)

Sys.time() - tStart
cat("\nUsing all cores avaialble")


tStart <- Sys.time()
#calculate the dot positions for each column
london_dots <- calc_dots(df = london_sf_data,
                         col_names = parties,
                         n_per_dot = people_per_dots,
                         ncores = 1)

Sys.time() - tStart
cat("\nUsing only 1 core")

