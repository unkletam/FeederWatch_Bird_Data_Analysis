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


##Bar chart showing the number of observations reviewed vs. not reviewed.
colnames <- c("loc_id","proj_period_id","fed_in_jan","fed_in_feb","fed_in_mar","fed_in_apr","fed_in_may","fed_in_jun","fed_in_jul","fed_in_aug","fed_in_sep","fed_in_oct","fed_in_nov","fed_in_dec"
)
df_site_sample <- df_site[colnames]

df_site_sample$proj_period_id <- gsub("PFW_", "", df_site_sample$proj_period_id)
#df$proj_period_id <- as.numeric(df$proj_period_id)

df_pivot <- df_site_sample %>%
  pivot_longer(cols = starts_with("fed_in_"), names_to = "month") %>%
  #filter(value == 1) %>%
  mutate(month = gsub("fed_in_", "", month))

colnames(df_pivot)[1] <- "LOC_ID"
colnames(df_pivot)[2] <- "Year"
colnames(df_pivot)[3] <- "Month"


month_abbreviations <- c("jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec")

# convert month column to numerical months starting from 1
df_pivot$Month <- match(df_pivot$Month, month_abbreviations)

colnames <- c("LOC_ID","Year","Month","HOW_MANY")
df_how_many <- df[colnames]


df_merged <- merge(x=df_pivot,y=df_how_many, 
                   by=c("LOC_ID","Year","Month"))

df_merged_sum <- df_merged %>%
  group_by(Year,Month,value) %>%
  summarise(HOW_MANY = sum(HOW_MANY))

df_merged_sum$value <- ifelse(is.na(df_merged_sum$value), 0, df_merged_sum$value)
colnames(df_merged_sum)[3] <- "fed"

df_merged_sum$date <- as.Date(paste(df_merged_sum$Year, df_merged_sum$Month, "01", sep = "-"))


df_test <- df_merged_sum %>% group_by(date,fed) %>%
  summarise(HOW_MANY = sum(HOW_MANY))

write.csv(df_test, "C:\\Classwork\\IE 6600\\Project 1\\task5_1.csv", row.names=FALSE)
plot_ly(df_merged_sum, x = ~date, y = ~HOW_MANY, color = I('black'), type = "scatter", mode = "lines")
