# this data file assumes that the questions csv download at https://ask.extension.org/expert/data/questions
# have been loaded in to R as 'questions'
# 
# e.g.
questions <- read.csv("~/dev/eXtension/aae_evaluation/questions_2014-12.csv")
questions_public = subset(questions,questions$submitter_is_extension == 'false')

# also, ggplot2, plyr, and mapproj needs to be installed, as well as loaded
# > install.packages('ggplot2')
# > install.packages('mapproj')
# (installing ggplot2 should install plyr as well)
library(ggplot2)
library(plyr)
library(mapproj)

# load the polygons for the states map data
states_map <- map_data("state")

# build up a questions by location dataset
satisfaction_questions =subset(questions_public,!is.na(questions_public$evaluation_10_value))
locations = ddply(satisfaction_questions,c('detected_location','detected_location_fips'), summarize, count=length(evaluation_10_value), happiness=mean(evaluation_10_value))
locations$Name = tolower(locations$detected_location)

# default colors/counts
ggplot(locations, aes(map_id = Name, fill=happiness)) + geom_map(map=states_map) + expand_limits(x=states_map$long, y=states_map$lat) + coord_map("polyconic")

# nc map
nc_county_map <- map_data("county","north carolina")
nc_county_map$region <- nc_county_map$subregion
nc_satisfaction_questions = subset(satisfaction_questions,satisfaction_questions$detected_location == 'North Carolina')
nc_locations = ddply(nc_satisfaction_questions,c('detected_county'), summarize, count=length(evaluation_10_value), happiness=mean(evaluation_10_value))
nc_locations$Name = tolower(gsub(' County','',nc_locations$detected_county))

ggplot(nc_locations, aes(map_id = Name, fill=happiness)) + geom_map(map=nc_county_map) + expand_limits(x=nc_county_map$long, y=nc_county_map$lat) + coord_map("polyconic")

