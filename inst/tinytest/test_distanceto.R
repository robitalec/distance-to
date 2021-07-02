# === Test distanceto -----------------------------------------------------



# Packages ----------------------------------------------------------------
library(tinytest)
library(distanceto)

library(spData)
library(sf)



# Data --------------------------------------------------------------------
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



# Run ---------------------------------------------------------------------
d <- distance_to(ncpts, somenc, measure = 'geodesic')




# Tests -------------------------------------------------------------------
# Return types
expect_inherits(d, 'numeric')
expect_equal(typeof(d), 'double')


# Return limits
expect_true(all(d >= 0))


# Warnings


# Errors




# Scrap -------------------------------------------------------------------
##
# Full globe
# measure <- 'geodesic'
# by <- 2.5
# full <- st_as_sf(expand.grid(lon = seq(-180, 180, by), lat = seq(-90, 90, by)),
# 								 coords = c('lon', 'lat'), crs = 4326)
# i <- sample(nrow(full), nrow(full) / 2)
# o <- seq.int(nrow(full))[!seq.int(nrow(full)) %in% i]
# dists <- distance_to(full[i,], full[o,], measure = measure)
