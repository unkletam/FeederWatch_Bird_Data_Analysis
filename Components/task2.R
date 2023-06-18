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
df_20 <- df[1:5000,]
mapbox_access_token  <-  'pk.eyJ1IjoidW5rbGV0YW0iLCJhIjoiY2tkNnljemFxMG1mYTJ6cmE4bW1yYjczeiJ9.rBvwQf6Zw4BTA_f_O9dKbg'
Sys.setenv("MAPBOX_TOKEN" = mapbox_access_token)

# Set your Plotly credentials
Sys.setenv("plotly_username"="unkletam")
Sys.setenv("plotly_api_key"="Nh99HaoHrpARSK3gdmNg")

df_1 <- df %>%
  group_by(LOC_ID, Month) %>%
  summarise(Total_Birds = sum(HOW_MANY), Avg_HRS_Effort = mean(EFFORT_HRS_ATLEAST))

df_2 <- df_site %>%
  group_by(loc_id) %>%
  summarise(Avg_Housing_Density = mean(housing_density))
colnames(df_2)[1] <- "LOC_ID"

df_merged <- merge(x=df_1,y=df_2, 
                          by="LOC_ID")

#df_merged <- df_merged[df_merged$Total_Birds < 1001487, ] 
colnames(df_2)[1] <- "LOC_ID"
df_merged_agg <- df_merged %>%
  group_by(Month,Avg_Housing_Density) %>%
  summarise(Avg_HRS_Effort = mean(Avg_HRS_Effort),Total_Birds = sum(Total_Birds) )


#write.csv(df_merged, "C:\\Classwork\\IE 6600\\Project 1\\task2.csv", row.names=FALSE)"Reds"

#annotation <- list(yref = 'paper', xref = "x", y = 0, x = 2, text = "annotation")
p <- plot_ly(df_merged_agg, x = ~Avg_Housing_Density, y = ~Total_Birds, 
             size = ~Avg_HRS_Effort, color = ~Month, 
             colors = "RdYlBu", text = ~paste("Month: ", Month, "<br>Number of Birds: ", Total_Birds, "<br>Housing Density: ", Avg_Housing_Density)) %>% 
  add_markers() %>% 
  layout(title = "Participant Estimated Housing Density vs. Number of Birds Observed",
         subtitle = "This is a subtitle",
         xaxis = list(title = "Housing Density"),
         yaxis = list(title = "Number of Birds Observed", range = c(0,60000)))%>% 
  add_lines(
    y = range(c(0,50000)),
    x = 3,
    line = list(
      color = "grey"
    ),
    inherit = FALSE,
    showlegend = FALSE
  )

p <- p %>% layout(
  margin = list(l = 25, r = 25, t = 50, b = 50),
  title = list(text = "Participant Estimated Housing Density vs. Number of Birds Observed",
               font = list(size = 24),
               x=0,
               y=1,
               xanchor ="left",
               yanchor = "top",
               pad = list(t = 20, b = 0, l = 20, r = 0),
               margin = list(l = 80)),
  width = 400,
  height = 300
)


# Display the chart
p

api_create(p, filename = "Task2")




# Task 2 - Bubble chart showing the relationship between participant 
#estimated housing density and the number of birds observed at each site.

colnames <- c("LATITUDE","LONGITUDE","Month","Year","SPECIES_CODE")
df_sample <- df[colnames]

df_sample <- df_sample %>%
  group_by(LATITUDE,LONGITUDE,Month,Year) %>%
  summarise(combined_species = paste(SPECIES_CODE, collapse = " | "))


# Filter out sites with incorrect locations
#df_20 <- df_20 %>% filter(SUBNATIONAL1_CODE != "XX")




# Create a Plotly scattermapbox object
map <- plot_ly(data = df_sample, type = "scattermapbox",
               lat = ~LATITUDE, lon = ~LONGITUDE, 
               text = ~combined_species, hoverinfo = "text",
               mode = "markers", color = I("white"), marker = list(size = 1.5))

# Set mapbox layout options
map <- map %>% layout(
  mapbox = list(
    style = "satellite",
    zoom = 3,
    center = list(lon = -98.5, lat = 39.8)
  ),
  margin = list(l = 25, r = 25, t = 50, b = 50),
  title = list(text = "FeederWatch Sites Across North America",
               font = list(size = 24),
               x=0,
               y=1,
               xanchor ="left",
               yanchor = "top",
               pad = list(t = 20, b = 0, l = 20, r = 0),
               margin = list(l = 80)),
  width = 800,
  height = 600
  
)

# Display map
map <- map %>% config(mapboxAccessToken = Sys.getenv("MAPBOX_TOKEN"))

map







