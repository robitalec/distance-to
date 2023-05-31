# === Test distance_raster ------------------------------------------------




# Packages ----------------------------------------------------------------
library(tinytest)
library(distanceto)

library(spData)
library(sf)
library(raster)


# Data --------------------------------------------------------------------
nc <- st_read(system.file("shape/nc.shp", package="sf"))

data('seine', package = 'spData')
st_crs(seine) <- 2154

# Run ---------------------------------------------------------------------
rgeo <- distance_raster(nc, cellsize = 0.5, measure = 'geodesic')
rproj <- distance_raster(seine, 1e5)


# Tests -------------------------------------------------------------------
# Output types
expect_inherits(rgeo, 'RasterLayer')
expect_equal(typeof(rgeo), 'S4')

expect_equal(typeof(rgeo), typeof(rproj))
expect_equal(class(rgeo), class(rproj))


# Output limits
expect_equal(cellStats(rgeo >= 0, 'sum'), ncell(rgeo))

expect_equal(cellStats(rproj >= 0, 'sum'), ncell(rproj))


# Warnings
expect_warning(distance_raster(nc, cellsize = 100, measure = 'geodesic'),
							 'cellsize >= 100')

# Errors
# Not sure how to test atm
# Package "fasterize" needed for distance_raster(). Please install it.


expect_error(distance_raster(nc, 1e5, extent = 42),
						 'extent must be of class bbox from sf::st_bbox')

expect_error(distance_raster(nc, cellsize = 0.01),
						 'cellsize selected may result in long run times')

