# Scrap working script ----------------------------------------------------
# Alec Robitaille

library(nabor)
# install.packages('spData')
library(sf)

npts <- 1e5

sample_bbox <- function(shape, n) {
	bbox <- st_bbox(shape)
	st_as_sf(data.frame(
		x = runif(n, bbox[1], bbox[3]),
		y = runif(n, bbox[2], bbox[4])
	), coords = c('x', 'y'))
}


nc <- st_read(system.file("shapes/sids.shp", package="spData"))
somenc <- nc[sample(length(nc), 5),]

somencpts <- st_as_sf(data.table(
	npts)

seine
bufseine <- st_buffer(seine, 1e3)
seinepts <- st_sample(bufseine, npts)
seineotherpts <- st_sample(bufseine[2, ], npts)

# Source ------------------------------------------------------------------
source('R/distance-to.R')



# Run ---------------------------------------------------------------------
# Pts and polygons
distance_to(somencpts, somenc)

# Pts and lines
distance_to(seinepts, seine)

# Pts and pts
distance_to(seinepts, seineotherpts)

# Notes -------------------------------------------------------------------
# check if st_crs is same


# NOTE:
# The underlying libnabo does not have a signalling value to identify
# indices for invalid query points (e.g. those containing an NA).
# In this situation, the index returned by libnabo will be 0 and
# knn will therefore return an index of 1. However the distance
# will be Inf signalling a failure to find a nearest neighbour.

# compare speed to st_nearest version
# compare speed to raster

# check input output lengths
