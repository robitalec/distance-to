#' distance-to
#'
#' The `distanceto` package is designed to quickly sample distances from points
#' features to other vector layers. Normally the approach for calculating distance
#' to (something) involves generating distance surfaces using raster based approaches
#' eg. `raster::distance` or `gdal_proximity` and subsequently point sampling these
#' surfaces. Since raster based approaches are a costly method that frequently leads
#' to memory issues or long and slow run times with high resolution data or large
#' study sites, we have opted to compute these distances using vector based
#' approaches. As a helper, there's a decidedly low-res raster based approach for
#' visually inspecting your region's distance surface. But the workhorse is
#' `distance_to`.
#'
#'
#' The `distanceto` package provides two functions:
#'
#' * `distance_to`
#' * `distance_raster`
#'
#' @docType package
#' @name distanceto
#' @aliases distanceto-package
"_PACKAGE"
