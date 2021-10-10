# Scrap working script ----------------------------------------------------
# Alec Robitaille

# install.packages('spData')
library(sf)

npts <- 1e3

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



# Compare -----------------------------------------------------------------
# old robitalec/wildcam approach
eval_dist <- function(x, layer) {
	sf::st_distance(x, layer[sf::st_nearest_feature(x, layer),],
									by_element = TRUE)
}

# 3.13m to 1.56m
View(bench::mark(
	distance_to(ncpts, somenc, measure = 'geodesic'),
	eval_dist(ncpts, somenc),
	check = FALSE
))

# 2.15s to 11.05m
View(bench::mark(
	distance_to(seinepts, seine),
	eval_dist(seinepts, seine),
	check = FALSE,
	relative = TRUE
))


# Pts and polygons
system.time(dfcheapnc <- distance_to(ncpts, somenc, measure = 'cheap'))
system.time(dfgeonc <- distance_to(ncpts, somenc, measure = 'geodesic'))
system.time(ed <- eval_dist(ncpts, somenc))
system.time(nnc <- nngeo::st_nn(ncpts, somenc, returnDist = TRUE))


all.equal(dfcheapnc, unlist(nnc$dist))
all.equal(dfgeonc, unlist(nnc$dist))
all.equal(dfgeonc, dfcheapnc)

View(bench::mark(
	distance_to(ncpts, somenc, measure = 'cheap'),
	distance_to(ncpts, somenc, measure = 'geodesic'),
	nngeo::st_nn(ncpts, somenc, returnDist = TRUE),
	check = FALSE,
	relative = TRUE
))

# Pts and lines
system.time(dse <- distance_to(seinepts, seine))
system.time(nse <- nngeo::st_nn(seinepts, seine, returnDist = TRUE))

all.equal(dse, unlist(nse$dist))

# Pts and pts
system.time(dseo <- distance_to(seinepts, seineotherpts))
system.time(nseo <- nngeo::st_nn(seinepts, seineotherpts, returnDist = TRUE))

all.equal(dseo, unlist(nseo$dist))


# Grid --------------------------------------------------------------------
system.time(r <- distance_raster(seine, 1e5))
system.time(r <- distance_raster(seine, 1e3))
