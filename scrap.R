# Scrap working script ----------------------------------------------------
# Alec Robitaille

library(nabor)
# install.packages('spData')
library(sf)

npts <- 1e4

sample_bbox <- function(shape, n) {
	bbox <- sf::st_bbox(shape)
	sf::st_as_sf(data.frame(
		x = runif(n, bbox[1], bbox[3]),
		y = runif(n, bbox[2], bbox[4])
	), coords = c('x', 'y'),
	crs = sf::st_crs(shape))
}


nc <- st_read(system.file("shapes/sids.shp", package="spData"))
st_crs(nc) <- "+proj=longlat +datum=NAD27"
somenc <- nc[sample(length(nc), 5),]
ncpts <- sample_bbox(nc, npts)

data('seine', package = 'spData')
bufseine <- st_buffer(seine, 1e3)
seinepts <- sample_bbox(bufseine[1, ], npts)
seineotherpts <- sample_bbox(bufseine[2, ], npts)

# Source ------------------------------------------------------------------
source('R/distance-to.R')



# Run ---------------------------------------------------------------------
# Pts and polygons
system.time(distance_to(ncpts, somenc, measure = 'geodesic'))
system.time(nngeo::st_nn(ncpts, somenc, returnDist = TRUE))

dd <- distance_to(ncpts, somenc, measure = 'geodesic')
nn <- nngeo::st_nn(ncpts, somenc, returnDist = TRUE)
all.equal(as.vector(dd), unlist(nn$dist))

# Pts and lines
distance_to(seinepts, seine)

# Pts and pts
distance_to(seinepts, seineotherpts)

st_nn(seinepts, seineotherpts, returnDist = TRUE)



# Grid --------------------------------------------------------------------
system.time(r <- distance_raster(seine, 1e5))
system.time(r <- distance_raster(seine, 1e3))


x <- seine
y <- seine
cellsize <- 1e4

pols <- sf::st_as_sf(sf::st_make_grid(
	x,
	cellsize = cellsize,
	what = 'polygons'
))
pts <- st_as_sf(sf::st_make_grid(
	x,
	cellsize = cellsize,
	what = 'centers'
))

pols$dist <- as.vector(distance_to(pts, y))

mapview(fasterize::fasterize(pols, fasterize::raster(pols, res = cellsize), field = 'dist'))

g <- data.frame(dist = )
g$geom <- grid
st_as_sf(g)

mapview(grid)
g <- sf::st_as_sf(
	grid#,
	# dist = distance_to(grid, y)
)



# Notes -------------------------------------------------------------------
# NOTE:
# The underlying libnabo does not have a signalling value to identify
# indices for invalid query points (e.g. those containing an NA).
# In this situation, the index returned by libnabo will be 0 and
# knn will therefore return an index of 1. However the distance
# will be Inf signalling a failure to find a nearest neighbour.

# compare speed to st_nearest version
# compare speed to raster

# check input output lengths
