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

##Histogram showing the distribution of the number of individuals seen for each species.

# Aggregate data by species and count number of individuals seen
species_counts <- df %>%
  group_by(SPECIES_CODE) %>%
  summarize(count = n())

subgroup_counts <- species_counts %>%
  group_by(count) %>%
  summarize(occurence = n())

subgroup_counts <- subgroup_counts[subgroup_counts$count < 2501, ] 
write.csv(subgroup_counts, "C:\\Classwork\\IE 6600\\Project 1\\task4.csv", row.names=FALSE)
#write.csv(species_counts, "C:\\Classwork\\IE 6600\\Project 1\\species_counts.csv", row.names=FALSE)


# Create a Plotly histogram object
#hist <- plot_ly(data = subgroup_counts, x = ~count, type = "histogram")
hist <- plot_ly(data = subgroup_counts , x = count, y = ~occurence, type = 'bar')

# Set histogram layout options
hist <- hist %>% layout(
  xaxis = list(title = "Number of Individuals Seen"),
  yaxis = list(title = "Count"),
  title = list(text = "Distribution of Individuals Seen by Species",
               font = list(size = 24)),
  margin = list(l = 50, r = 50, t = 50, b = 50),
  annotations = list(
    list(x = 0.5, y = -0.1, 
         text = "Data source: FeederWatch",
         showarrow = FALSE, xref = "paper", yref = "paper",
         xanchor = "center", yanchor = "top", 
         font = list(size = 14))
  )
)

# Display histogram
hist
#This code reads in the FeederWatch data, aggregates it by species, counts the number of individuals seen for each species, and then creates a Plotly histogram object based on the counts. The layout options are set to provide appropriate axis labels, a title, and annotations indicating the data source. Finally, the histogram is displayed using the plotly() function.





