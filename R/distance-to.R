#' Distance to
#'
#' Measures the distance from points x to features in layer y.
#'
#' Uses the function `nabor::knn` to determine the distance from each point in `x`
#' to the nearest feature in layer `y`. If the input CRS is longlat, eg. EPSG 4326,
#' the distance is returned as measured by `geodist::geodist`. Otherwise, if the
#' input CRS indicates projected coordinates, the distance returned is the
#' euclidean distance. Both `x` and `y` are expected to be `sf` objects and
#' the distances are returned as vector, easily added to input `x` with `$<-`
#' or other methods. If `y` is a 'POLYGON' or 'MULTIPOLYGON' object, the
#' distance returned for points in `x` within features in `y` are set to 0.
#'
#' @param x points to measure distances from, to layer `y`. Expecting an `sf`
#' point compatible with `sf::st_coordinates` such as an `sf`, `sfc` or
#' `sfg` object with geometry type 'POINT' or 'MULTIPOINT'. CRS of `x` should match CRS of `y`.
#' @param y feature layer to measure distance to. Expecting an `sf` point, line
#' or polygon compatible with `sf::st_coordinates` such as an `sf`, `sfc`
#' or `sfg` object. CRS of `y` should match CRS of `x`.
#' @param measure method used to measure geographic distances between longlat
#' `x` and `y` objects. See `geodist::geodist` for more information. Ignored if
#' CRS of `x` and `y` indicated projected coordinates.
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
#' # Set number of sampling points
#' npts <- 1e3
#'
#' # Sample points in nc
#' ncpts <- st_sample(nc, npts)
#'
#' # Select first 5 of nc
#' ncsub <- nc[1:5,]
#'
#' # Measure distance from ncpts to first 5 of nc, printing result
#' distance_to(ncpts, ncsub, measure = 'geodesic')
#'
#' # or add to ncpts
#' ncpts$dist <- distance_to(ncpts, ncsub, measure = 'geodesic')
#'
distance_to <- function(x, y, measure = NULL) {
	if (missing(x)) stop('x must be provided')
	if (missing(y)) stop('y must be provided')

	if (!all(any(c('sf', 'sfc', 'sfg') %in% class(x)) &
					any(c('sf', 'sfc', 'sfg') %in% class(y)))) {
		stop("x and y must be sf objects")
	}

	if (!all(sf::st_geometry_type(x, TRUE) %in% c('POINT', 'MULTIPOINT'))) {
		stop('x provided must be a POINT or MULTIPOINT as determined by sf::st_geometry_type')
	}

	if (sf::st_crs(x) != sf::st_crs(y)) {
		stop('crs of x and y must match - see sf::st_crs(x) and sf::st_crs(y)')
	}

	if (sf::st_is_longlat(x) != sf::st_is_longlat(y)) {
		stop('both x and y must be long lat degrees, or neither - see sf::st_is_longlat')
	}

	xcoor <- sf::st_coordinates(x)[, c(1, 2)]
	ycoor <- sf::st_coordinates(y)[, c(1, 2)]

	if (sf::st_is_longlat(x) & sf::st_is_longlat(y)) {
		d <- distance_to_lonlat(xcoor, ycoor, measure)
	} else {
		d <- distance_to_proj(xcoor, ycoor, measure)
	}

	if (sf::st_geometry_type(y, FALSE) %in% c('POLYGON', 'MULTIPOLYGON')){
		d[lengths(sf::st_intersects(x, y)) > 0] <- 0
	}

	return(d)
}


distance_to_lonlat <- function(xcoor, ycoor, measure) {
	if (is.null(measure)) {
		stop('measure is required if x and y are longlat - see geodist::geodist')
	}
	g <- geodist::geodist(
		xcoor,
		ycoor,
		paired = FALSE,
		measure = measure
	)
	apply(g, 1, min)
}


distance_to_proj <- function(xcoor, ycoor, measure = NULL) {
	if (!is.null(measure)) {
		warning('"measure" ignored since x and y are not longlat - see sf::st_is_longlat')
	}
	dists <- nabor::knn(data = ycoor, query = xcoor, k = 1L)
	as.vector(dists[['nn.dists']])
}
