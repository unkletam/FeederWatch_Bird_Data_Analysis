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


df_effort <- df%>%
  group_by(EFFORT_HRS_ATLEAST,SPECIES_CODE) %>%
  summarise(HOW_MANY = sum(HOW_MANY))

write.csv(df_effort, "C:\\Classwork\\IE 6600\\Project 1\\task7.csv", row.names=FALSE)
