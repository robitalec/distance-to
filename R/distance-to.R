#' Distance to
#'
#' @param x pts
#' @param y layer
#'
#' @return
#' @export
#'
#' @examples
distance_to <- function(x, y) {
	# if (length(unique(st_geometry_type(y))) != 1) {
	# 	stop('st_geometry_type(y) shows mixed geometry types')
	# }

	dists <- knn(data = sf::st_coordinates(y),
							 query = sf::st_coordinates(x),
							 k = 1L)$nn.dists

	if (sf::st_geometry_type(y, FALSE) %in%
			c('POINT', 'MULTIPOINT', 'LINESTRING', 'MULTILINESTRING')) {
		dists
	} else {
		# dists[sf::st_within(x, y, sparse = FALSE)] <- 0
		dists
	}
}
