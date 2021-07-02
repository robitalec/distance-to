# === Test distance_raster ------------------------------------------------




# Packages ----------------------------------------------------------------
library(tinytest)
library(distanceto)

library(spData)
library(sf)



# Data --------------------------------------------------------------------
nc <- st_read(system.file("shapes/sids.shp", package="spData"))
st_crs(nc) <- "+proj=longlat +datum=NAD27"

data('seine', package = 'spData')


# Run ---------------------------------------------------------------------
rgeo <- distance_raster(nc)
rproj <- distance_raster(seine)



# Tests -------------------------------------------------------------------
# Output types
expect_inherits(rgeo, 'raster')
expect_equal(typeof(rgeo), 'double')

expect_equal(typeof(rgeo), typeof(rproj))
expect_equal(class(rgeo), class(rproj))


# Output limits
expect_true(all(d >= 0))

expect_equal(all(rgeo >= 0), all(rproj >= 0))


# Errors
# Not sure how to test atm
# Package "fasterize" needed for distance_raster(). Please install it.


expect_error(distance_raster(nc, extent = 42),
						 'extent must be of class bbox from sf::st_bbox')

expect_error(distance_raster(nc, cellsize = 0.1),
						 'cellsize selected may result in long run times')

