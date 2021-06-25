#' Distance to
#'
#' nabor = Euclidean distance
#'
#' @param x pts
#' @param y layer
#'
#' @return
#' @export
#'
#' @examples
distance_to <- function(x, y) {
	if (length(unique(st_geometry_type(y))) != 1) {
		stop('sf::st_geometry_type(y) shows mixed geometry types')
	}

	if (sf::st_crs(x) == sf::st_crs(y)) {
		stop('st_crs(x) must be the same as st_crs(y)')
	}

	dists <- nabor::knn(data = sf::st_coordinates(y)[, c(1, 2)],
											query = sf::st_coordinates(x)[, c(1, 2)],
											k = 1L)$nn.dists

	if (sf::st_is_longlat(x) != sf::st_is_longlat(y)) {
		stop('both x and y must be long lat degrees, or neither')
	} else if (sf::st_is_longlat(x) & sf::st_is_longlat(y)) {
		# recalculate dist with geodist
		# optional geodist dependency
	}

	if (sf::st_geometry_type(y, FALSE) %in%
			c('POINT', 'MULTIPOINT', 'LINESTRING', 'MULTILINESTRING')) {
		dists
	} else if (sf::st_geometry_type(y, FALSE) %in%
						 c('POLYGON', 'MULTIPOLYGON')){
		dists[lengths(st_intersects(x, y)) > 0] <- 0
		dists
	}
}
