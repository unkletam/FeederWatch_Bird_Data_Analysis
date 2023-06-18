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


df$EFFORT_HRS_ATLEAST <- ifelse(is.null(df$EFFORT_HRS_ATLEAST), 0, df$EFFORT_HRS_ATLEAST)

df_effort <- df%>%
  group_by(SPECIES_CODE) %>%
  summarise(EFFORT_HRS = sum(EFFORT_HRS_ATLEAST))


q1 <- quantile(df_effort$EFFORT_HRS, 0.25)
q3 <- quantile(df_effort$EFFORT_HRS, 0.75)
iqr <- q3 - q1

# Determine the range of values outside of the IQR
lower <- q1 - 1.5 * iqr
upper <- q3 + 1.5 * iqr

# Remove any values outside of the range
df_effort <- df_effort[df_effort$EFFORT_HRS >= lower & df_effort$EFFORT_HRS <= upper, ]


write.csv(df_effort, "C:\\Classwork\\IE 6600\\Project 1\\task10.csv", row.names=FALSE)