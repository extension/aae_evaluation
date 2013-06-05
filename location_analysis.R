# this data file assumes that the questions csv download at http://data.extension.org/downloads
# have been loaded in to R as 'aae_questions'
# 
# e.g.
# aae_questions <- read.csv("~/dev/eXtension/aae_evaluation/aae_questions_2013-23.csv")
#
# also, ggplot2, plyr, and mapproj needs to be installed, as well as loaded
# > install.packages('ggplot2')
# (installing ggplot2 should install plyr as well)
# > library(ggplot2)
# > library(plyr)
# > library(mapproj)

# load the polygons for the states map data
states_map <- map_data("state")

