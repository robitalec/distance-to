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
distance_raster <- function(y, cellsize, extent = NULL, expand = NULL) {
	# check cellsize ~~ crs units

	if (!is.null(extent) & class(extent) != 'bbox') {
		stop('extent must be of class bbox from sf::st_bbox')
	}

	if (!is.null(extent) & is.null(expand)) {
		# check if extent is bbox
		x <- extent
	} else if (is.null(extent) & !is.null(expand)) {
		x <- st_bbox(y) - (st_bbox(y) * rep(c(-expand, expand), 2))
	} else if (is.null(extent) & is.null(expand)) {
		x <- y
	} else if (!is.null(extent) & !is.null(expand)) {
		# check if extent is bbox
		x <- extent - (extent * rep(c(-expand, expand), 2))
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


	pols$dist <- dist

	fasterize::fasterize(
		pols,
		fasterize::raster(pols, res = cellsize),
		field = 'dist'
	)
}
