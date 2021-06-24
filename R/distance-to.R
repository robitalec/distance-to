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
