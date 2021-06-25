#' Distance raster
#'
#' Warnings + recommend pt based
#'
#' @param cellsize in unit of projection
#' @param y
#' @param extent optional alternative extent bbox
#' @param expand 0-1 scaling eg. 5% expansion = 0.05
#'
#' @return
#' @export
#'
#' @examples
distance_raster <- function(y, cellsize, extent = NULL, expand = NULL, check = TRUE) {
	if (!is.null(extent) & class(extent) != 'bbox') {
		stop('extent must be of class bbox from sf::st_bbox')
	}

	if (!is.null(extent) & is.null(expand)) {
		x <- extent
	} else if (is.null(extent) & !is.null(expand)) {
		x <- st_bbox(y) - (st_bbox(y) * rep(c(-expand, expand), 2))
	} else if (is.null(extent) & is.null(expand)) {
		x <- sf::st_bbox(y)
	} else if (!is.null(extent) & !is.null(expand)) {
		x <- extent - (extent * rep(c(-expand, expand), 2))
	}

	if (check) {
		if ((diff(x[c(1, 3)]) / cellsize) > 500 | (diff(x[c(2, 4)]) / cellsize) > 500) {
			stop('cellsize selected may result in long run times', '\n', '\n',
					 '  distance_raster is meant to provide an approximate distance surface', '\n',
					 '  see distance_to for exact measurements', '\n','\n',
					 '  turn off "check" to prevent this warning'
			)
		}
	}


	pols <- sf::st_as_sf(sf::st_make_grid(
		x,
		cellsize = cellsize,
		what = 'polygons'
	))

	pts <- sf::st_make_grid(
		x,
		cellsize = cellsize,
		what = 'centers'
	)

	dist <- distance_to(pts, y)

	dist[dist < cellsize] <- 0

	pols$dist <- dist

	fasterize::fasterize(
		pols,
		fasterize::raster(pols, res = cellsize),
		field = 'dist'
	)
}
