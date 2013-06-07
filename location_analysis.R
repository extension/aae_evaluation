# this data file assumes that the questions csv download at http://data.extension.org/downloads
# have been loaded in to R as 'aae_questions'
# 
# e.g.
# aae_questions <- read.csv("~/dev/eXtension/aae_evaluation/aae_questions_2013-23.csv")
#
# also, ggplot2, plyr, and mapproj needs to be installed, as well as loaded
# > install.packages('ggplot2','mapproj')
# (installing ggplot2 should install plyr as well)
library(ggplot2)
library(plyr)
library(mapproj)

# load the polygons for the states map data
states_map <- map_data("state")
locations = ddply(aae_questions_public,c('detected_location','detected_location_fips'), function(x) c(count=nrow(x)))
locations$detected_location = tolower(locations$detected_location)

# default colors/counts
ggplot(locations, aes(map_id = detected_location, fill=count)) + geom_map(map=states_map) + expand_limits(x=states_map$long, y=states_map$lat) + coord_map("polyconic")

# quantiles
qa <- quantile(locations$count, c(0,0.25,0.5,0.75,0.9,1.0))
locations$count_q <- cut(locations$count,qa,labels=c('0-25%','25-50%','50-75%','75-90%','90-100%'),include.lowest=TRUE)
pal <- colorRampPalette(c("#559999","grey80","#BB650B"))(5)
ggplot(locations, aes(map_id = detected_location, fill=count_q)) + geom_map(map=states_map,color='black') + scale_fill_manual(values=pal) + expand_limits(x=states_map$long, y=states_map$lat) + coord_map("polyconic")

# qa <- quantile(locations$count, seq(0,1,by=0.1))
# locations$count_q <- cut(locations$count,qa,labels=c('0-10%','10-20%','20-30%','30-40%','40-50%','5-60%','60-70%','70-80%','80-90%','90-100%'),include.lowest=TRUE)
# pal <- colorRampPalette(c("#559999","grey80","#BB650B"))(10)
# ggplot(locations, aes(map_id = detected_location, fill=count_q)) + geom_map(map=states_map,color='black') + scale_fill_manual(values=pal) + expand_limits(x=states_map$long, y=states_map$lat) + coord_map("polyconic")
