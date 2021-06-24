# Scrap working script ----------------------------------------------------
# Alec Robitaille

library(nabor)
# install.packages('spData')
library(sf)

nc <- st_read(system.file("shapes/sids.shp", package="spData")[1], quiet=TRUE)
somenc <- nc[sample(length(nc), 10),]
pts <- st_sample(nc, 100)


# Source ------------------------------------------------------------------
source('R/distance-to.R')



# Run ---------------------------------------------------------------------
z <- knn(st_coordinates(pts),
				 st_coordinates(somenc),
				 1)
distance_to(pts,)

# Notes -------------------------------------------------------------------
# check if st_crs is same



# NOTE:
# The underlying libnabo does not have a signalling value to identify
# indices for invalid query points (e.g. those containing an NA).
# In this situation, the index returned by libnabo will be 0 and
# knn will therefore return an index of 1. However the distance
# will be Inf signalling a failure to find a nearest neighbour.

# this is good for linear or pts
