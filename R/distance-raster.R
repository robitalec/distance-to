#' Distance to raster
#'
#' Generates a distance surface from layer `y`.
#'
#' Calculates the distance of each pixel to the features in layer `y`.
#' First, generates a regular grid of points in the bounding box of `y` or optionally provided
#' `extent`. Then measures the distance from each point to the nearest feature
#' in layer `y` using `distanceto::distance_to()`. Finally, returns the grid
#' of distances, rasterized using the excellent package `fasterize`.
#'
#' Note: this function is intended to provide a rough, low-res look at your
#' distance surface. The function `distanceto::distance_to()` should be used
#' for all precise measurements from points to features, as it avoids the
#' costly procedure of generating an entire distance surface by calculating
#' geographic distances directly between points `x` and features in layer `y`.
#'
#' The features in layer `y` are expected to be an `sf` object.
#' If the input CRS of features in layer `y` is longlat, eg. 4326,
#' the distance is returned as measured by `geodist::geodist`. Otherwise, if the
#' input CRS indicates projected coordinates, the distance measured is the
#' euclidean distance.
#'
#' @param cellsize in unit of projection
#' @param y feature layer to measure distance to. Expecting an `sf` point, line
#' or polygon compatible with `sf::st_coordinates` such as an `sf`, `sfc`
#' or `sfg` object.
#' @param extent optional alternative extent bbox
#' @param expand 0-1 scaling eg. 5% expansion = 0.05
#' @param measure method used to measure geographic distances.
#' See `geodist::geodist` for more information. Ignored if CRS of `y`
#' indicates projected coordinates.
#'
#' @return
#' @export
#'
#' @examples
#' # Load sf
#' library(sf)
#'
#' # Load nc data
#' nc <- st_read(system.file("shapes/sids.shp", package="spData"))
#' st_crs(nc) <- "+proj=longlat +datum=NAD27"
#'
#' # Select first 5 of nc
#' ncsub <- nc[1:5,]
#'
#' # Generate a distance raster from some of nc within extent of all of nc
#' distance_raster(somenc, 1e4, st_bbox(nc))
distance_raster <- function(y, cellsize, extent = NULL, expand = NULL,
														measure = NULL, check = TRUE) {
	# TODO: add measure arg
	if (!requireNamespace("fasterize", quietly = TRUE)) {
		stop("Package \"fasterize\" needed for distance_raster(). Please install it.",
				 call. = FALSE)
	}

	if (!is.null(extent) & class(extent) != 'bbox') {
		stop('extent must be of class bbox from sf::st_bbox')
	}

	if (!is.null(extent) & is.null(expand)) {
		x <- extent
	} else if (is.null(extent) & !is.null(expand)) {
		x <- sf::st_bbox(y) - (sf::st_bbox(y) * rep(c(-expand, expand), 2))
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
