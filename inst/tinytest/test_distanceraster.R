# === Test distance_raster ------------------------------------------------




# Packages ----------------------------------------------------------------
library(tinytest)
library(distanceto)

library(sf)


# Data --------------------------------------------------------------------
nc <- st_read(system.file("shape/nc.shp", package="sf"))

nc_utm <- st_transform(nc, 26918)


# Note: package 'fasterize' required for distance_raster
if (require(fasterize, quietly = TRUE)) {
	# Run -------------------------------------------------------------------
	rgeo <- distance_raster(nc, cellsize = 0.5, measure = 'geodesic')
	rproj <- distance_raster(nc_utm, 1e5)

	# Tests -----------------------------------------------------------------
	# Output types
	expect_inherits(rgeo, 'RasterLayer')
	expect_equal(typeof(rgeo), 'S4')

	expect_equal(typeof(rgeo), typeof(rproj))
	expect_equal(class(rgeo), class(rproj))


	# Output limits
	# Note: package 'raster' required for cellStats, ncell
	if (require(raster, quietly = TRUE)) {
		expect_equal(cellStats(rgeo >= 0, 'sum'), ncell(rgeo))
		expect_equal(cellStats(rproj >= 0, 'sum'), ncell(rproj))
	}


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

}
