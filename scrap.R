# Scrap working script ----------------------------------------------------
# Alec Robitaille

library(nabor)
# install.packages('spData')
library(sf)

nc <- st_read(system.file("shapes/sids.shp", package="spData"))
somenc <- nc[sample(length(nc), 10),]
somencpts <- st_sample(nc, 100)

seine
seinepts <- st_sample(st_buffer(seine, 1e3), 100)
seineotherpts <- st_sample(st_buffer(seine[2,], 1e3), 100)

# Source ------------------------------------------------------------------
source('R/distance-to.R')



# Run ---------------------------------------------------------------------
# Pts and polygons
distance_to(somencpts, somenc)

# Pts and lines
distance_to(seinepts, seineotherpts)


# Notes -------------------------------------------------------------------
# check if st_crs is same



# NOTE:
# The underlying libnabo does not have a signalling value to identify
# indices for invalid query points (e.g. those containing an NA).
# In this situation, the index returned by libnabo will be 0 and
# knn will therefore return an index of 1. However the distance
# will be Inf signalling a failure to find a nearest neighbour.

# this is good for linear or pts
