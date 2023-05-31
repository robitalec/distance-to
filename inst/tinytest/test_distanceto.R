# === Test distance_to ----------------------------------------------------



# Packages ----------------------------------------------------------------
library(tinytest)
library(distanceto)

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

nc <- st_read(system.file("shape/nc.shp", package="sf"))
somenc <- nc[sample(length(nc), 5),]
ncpts <- sample_bbox(nc, npts)

nc_utm <- st_transform(nc, 26918)
nc_utm_pts <- sample_bbox(nc_utm[1, ], npts)


# Run ---------------------------------------------------------------------
d <- distance_to(ncpts, somenc, measure = 'geodesic')

dproj <- distance_to(nc_utm_pts, nc_utm)
dgeo <- d



# Tests -------------------------------------------------------------------
# Output types
expect_inherits(d, 'numeric')
expect_equal(typeof(d), 'double')

expect_equal(typeof(dgeo), typeof(dproj))
expect_equal(class(dgeo), class(dproj))


# Output limits
expect_true(all(d >= 0))

expect_equal(all(dgeo >= 0), all(dproj >= 0))


# Warnings
expect_warning(distance_to(nc_utm_pts, nc_utm, measure = 'geodesic'),
							 '"measure" ignored since x and y are not longlat')

# Errors
expect_error(distance_to(),
						 'x must be provided')
expect_error(distance_to(42),
						 'y must be provided')
expect_error(distance_to(ncpts, 42),
						 'x and y must be sf objects')
expect_error(distance_to(st_linestring(matrix(42, 0, 2)),
												 st_point(c(42, 42))),
						 'x must be a POINT or MULTIPOINT')

difcrs <- st_transform(ncpts, 32621)
expect_error(distance_to(ncpts, difcrs),
						 'crs of x and y must match')

# cant test: both x and y must be long lat degrees, or neither
# since covered by previous

expect_error(distance_to(ncpts, somenc, measure = NULL),
						 'measure is required')


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
