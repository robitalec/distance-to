#' Distance raster
#'
#' Warnings + recommend pt based
#'
#' @param x
#' @param cellsize in unit of projection
#'
#' @return
#' @export
#'
#' @examples
distance_raster <- function(x, y, cellsize) {
	g <- sf::st_make_grid(x, cellsize = cellsize, what = 'centers')

	g$dist <- distance_to(g, y)

	fasterize::fasterize(, raster(g))
}
