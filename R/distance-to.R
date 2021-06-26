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
distance_to <- function(x, y, measure = NULL) {
	if (!all(sf::st_geometry_type(seinepts, TRUE) %in% c('POINT', 'MULTIPOINT'))) {
		stop('x provided must be a POINT or MULTIPOINT as determined by sf::st_geometry_type')
	}

	# TODO: necessary?
	# if (length(unique(sf::st_geometry_type(y))) != 1) {
	# 	stop('sf::st_geometry_type(y) shows mixed geometry types')
	# }

	if (sf::st_crs(x) != sf::st_crs(y)) {
		stop('sf::st_crs(x) must be the same as sf::st_crs(y)')
	}

	if (sf::st_is_longlat(x) != sf::st_is_longlat(y)) {
		stop('both x and y must be long lat degrees, or neither')
	}

	xcoor <- sf::st_coordinates(x)[, c(1, 2)]
	ycoor <- sf::st_coordinates(y)[, c(1, 2)]
	dists <- nabor::knn(data = ycoor, query = xcoor, k = 1L)

	if (sf::st_is_longlat(x) & sf::st_is_longlat(y)) {
		if (is.null(measure)) {
			stop('measure is required if x and y are longlat - see geodist::geodist')
		}
		dists[['nn.dists']] <- geodist::geodist(
			xcoor,
			ycoor[dists[['nn.idx']],],
			paired = TRUE,
			measure = measure
		)
	} else {
		if (!is.null(measure)) warning('"measure" ignored since x and y are not longlat')
	}

	if (sf::st_geometry_type(y, FALSE) %in%
						 c('POLYGON', 'MULTIPOLYGON')){
		dists[['nn.dists']][lengths(st_intersects(x, y)) > 0] <- 0
	}

	as.vector(dists[['nn.dists']])
}
