library(nabor)
# install.packages('spData')
library(sf)

nc <- st_read(system.file("shapes/sids.shp", package="spData")[1], quiet=TRUE)


somenc <- nc[sample(length(nc), 10),]

pts <- st_sample(nc, 100)

plot(pts)

# check if st_crs is same

#' Distance to
#'
#' @param x
#' @param y
#'
#' @return
#' @export
#'
#' @examples
distance_to <- function(x, y) {
	# if (length(unique(st_geometry_type(y))) != 1) {
	# 	stop('st_geometry_type(y) shows mixed geometry types')
	# }

	dists <- knn(data = sf::st_coordinates(x),
							 query = sf::st_coordinates(y),
							 k = 1L)

	if (sf::st_geometry_type(y, FALSE) == 'POINT' | sf::st_geometry_type(y, FALSE) == 'LINE') {
		dists
	} else {
		# check st_within
		# if within, set to 0
		# if outside, preserve dist in knn
		# dists
	}
}
z <- knn(st_coordinates(pts),
				 st_coordinates(somenc),
				 1)

# NOTE:
# The underlying libnabo does not have a signalling value to identify
# indices for invalid query points (e.g. those containing an NA).
# In this situation, the index returned by libnabo will be 0 and
# knn will therefore return an index of 1. However the distance
# will be Inf signalling a failure to find a nearest neighbour.

# this is good for linear or pts
