# sf.chlorodot
Simple Dot Chloropleth Maps using sf


A packaged version of Paul Campbell's blogpost at https://www.cultureofinsight.com/blog/2018/05/02/2018-04-08-multivariate-dot-density-maps-in-r-with-sf-ggplot2/.
Hopefully should allow for faster generation of dot chloropleth maps for people wanting to emulate the post. Also contains the data from the blogpost as an example.

```{r example, warning=FALSE,message=FALSE}
library(sf)
library(sf.chlordot)

#get the data to plot
#merge a shapefile with the population data
sf_data <- merge(ge_data, uk, by = "ons_id") %>% 
  st_as_sf() # I'm losing sf class after join so make sf object again

#the columns we want to select and plot
parties <- names(sf_data)[4:8]
#set up a colour scale for these if so inclined
colours = c("blue", "red", "darkgoldenrod", "purple", "green")
names(colours) = parties

#calculate the dot positions for each column
sf_dots <- calc_dots(df = sf_data, col_names = parties, n_per_dot = 100)

#plot the results
library(ggplot2)
p <- ggplot() +
  geom_sf(data = sf_data, fill = "transparent",colour = "white") +
  geom_point(data = sf_dots, aes(lon, lat, colour = variable), size = 0.5) +
  scale_colour_manual(name = parties, values = colours) +
  theme_void()

p
```

![London](https://github.com/RobWHickman/sf.chlorodot/blob/master/figures/london.png)


Another good example using Bosnian ethnicity data can be found [here](https://twitter.com/majda_ruge/status/1037704253043879936). For an extra example I decided to look at South African language diversity, which I'd previously seen good visualisation of [here](https://adrianfrith.com/linguistic-diversity/)

```{r south_africa, message=FALSE,warning=FALSE}
library(rvest)
library(tidyverse)
library(data.table)

#download the South African shapefile fom gadm
admin_url <- "https://biogeo.ucdavis.edu/data/gadm3.6/Rsf/gadm36_ZAF_3_sf.rds"
download.file(admin_url, destfile = "shapefiles.rds", mode = "wb")
south_africa <- readRDS("shapefiles.rds") %>%
  #convert to sf
  st_as_sf() %>%
  select(region = NAME_3) %>%
  #merge geometries that have two rows
  group_by(region) %>%
  summarise()

#get the links to the data from Adrian Frith's site
sa_data_url <- "https://census2011.adrianfrith.com"
south_africa_data <- sa_data_url %>%
  read_html() %>% html_nodes(".namecell a") %>% html_attr("href") %>% paste0(sa_data_url, .) %>%
  lapply(., function(x) read_html(x) %>% html_nodes(".namecell a") %>% html_attr("href") %>% paste0(sa_data_url, .)) %>% unlist() %>%
   lapply(., function(x) read_html(x) %>% html_nodes(".namecell a") %>% html_attr("href") %>% paste0(sa_data_url, .)) %>% unlist()

#scrape the data on primary language from the 2011 South African census
language_data <- rbindlist(lapply(south_africa_data, function(x) {
  read <- read_html(x)
  language_nos <- read %>% html_nodes(".datacell") %>% html_text()
  start <- grep("Percentage", language_nos)[3] + 1
  stop <- grep("Population", language_nos) - 1
  #some areas have no data
  if(!is.na(start) & !is.na(stop)) {
    language_nos <- language_nos[start:stop]
    language_nos <- language_nos[seq(1, length(language_nos), 2)]
  } else {
    language_nos <- NA
  }
  
  languages <- read %>% html_nodes("tr > :nth-child(1)") %>% html_text()
  start <- grep("First language", languages) + 1
  stop <- grep("Name", languages) - 1
  if(length(start) > 0 & !is.na(stop)) {
    languages <- languages[start:stop]
  } else {
    languages <- NA
  }
  
  region_names <- read %>% html_nodes(".topname") %>% html_text()
  
  #combine into a df
  df <- data.frame(language = languages, primary_speakers = language_nos, region = region_names)
  return(df)
})) %>%
  #convert number of speakers to numeric
  mutate(primary_speakers = as.numeric(as.character(primary_speakers))) %>%
  #matching of area names with South African shapefile
  mutate(region = gsub(" NU", "", region)) %>%
  mutate(region = gsub("Tshwane", "City of Tshwane", region)) %>%
  #filter only the data we want to merge
  filter(region %in% south_africa$region) %>%
  filter(!is.na(language)) %>%
  #spread the data
  dcast(., region ~ language, value.var = "primary_speakers", fun.aggregate = sum) %>%
  #join in the spatial geometry
  left_join(., south_africa)

#calculate the dot locations using the package
sf_dots <- calc_dots(df = language_data, col_names = names(language_data)[2:15], n_per_dot = 1000)

#plot it
#stolen the background colour scheme from Paul Campbell's blog
#original inspiration for this package
p <- ggplot() +
  geom_sf(data = south_africa, fill = "transparent",colour = "white") +
  geom_point(data = sf_dots, aes(lon, lat, colour = Party), size = 0.5) +
  ggtitle("Language Diversity in South Africa") +
  theme_void() +
  theme(plot.background = element_rect(fill = "#212121", color = NA), 
        panel.background = element_rect(fill = "#212121", color = NA),
        legend.background = element_rect(fill = "#212121", color = NA),
        text =  element_text(color = "white"),
        title =  element_text(color = "white"),
        legend.text=element_text(size=12))

p
```
![South Africa](https://github.com/RobWHickman/sf.chlorodot/blob/master/figures/south_africa.png)


