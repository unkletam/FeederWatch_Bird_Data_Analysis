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


df$DATE <- as.Date(paste(df$Year, df$Month, "1", sep = "-"))
# Calculate number of unique bird species per year

bird_counts <- aggregate(SPECIES_CODE ~ Year, data = df, FUN = function(x) length(unique(x)))

task3 <- plot_ly(bird_counts, x = ~Year, y = ~SPECIES_CODE, type = "scatter", mode = "lines+markers", name = "Bird Species Observed")%>%
  layout(title = "Change in Bird Species Observed Over Time")

api_create(task3, filename = "Task3")