library(tidyverse)
library(tidyr)
library(dplyr)
library(stringr)
require(data.table)
library(magrittr)
library(plotly)

setwd("C:/Classwork/IE 6600/Project 1")
df <- read.csv('PFW_2016_2020_public.csv')
df_site <- read.csv('PFW_count_site_data_public_2021.csv')



df_snow <- df%>%
  group_by(SNOW_DEP_ATLEAST,SPECIES_CODE) %>%
  summarise(HOW_MANY = sum(HOW_MANY))

write.csv(df_snow, "C:\\Classwork\\IE 6600\\Project 1\\task6.csv", row.names=FALSE)


plot_ly(df_snow, x = ~SNOW_DEP_ATLEAST, y = ~HOW_MANY, type = "scatter", mode = "markers",
        marker = list(size = 3, opacity = 0.5)) %>%
  layout(title = "Snow Depth vs. Bird Sightings",
         xaxis = list(title = "Snow Depth (inches)"),
         yaxis = list(title = "Maximum Number of Bird Sightings"))