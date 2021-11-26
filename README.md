
<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/robitalec/distance-to/workflows/R-CMD-check/badge.svg)](https://github.com/robitalec/distance-to/actions)
[![CRAN
status](https://www.r-pkg.org/badges/version/distanceto)](https://cran.r-project.org/package=distanceto)
<!-- badges: end -->

# distance-to

## Overview

The `distanceto` package is designed to quickly sample distances from
points features to other vector layers. Normally the approach for
calculating distance to (something) involves generating distance
surfaces using raster based approaches eg. `raster::distance` or
`gdal_proximity` and subsequently point sampling these surfaces. Since
raster based approaches are a costly method that frequently leads to
memory issues or long and slow run times with high resolution data or
large study sites, we have opted to compute these distances using vector
based approaches. As a helper, there’s a decidedly low-res raster based
approach for visually inspecting your region’s distance surface. But the
workhorse is `distance_to`. See the [Example](#example).

## Install

``` r
install.packages('distanceto', repos = 'https://robitalec.r-universe.dev')
```

## Example

``` r
library(distanceto)
library(sf)
```

    ## Linking to GEOS 3.9.1, GDAL 3.3.1, PROJ 8.0.1

``` r
# Load nc data
nc <- st_read(system.file("shapes/sids.shp", package="spData"))
```

    ## Reading layer `sids' from data source 
    ##   `/home/alecr/R/x86_64-pc-linux-gnu-library/4.1/spData/shapes/sids.shp' 
    ##   using driver `ESRI Shapefile'
    ## Simple feature collection with 100 features and 22 fields
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
    ## CRS:           NA

``` r
st_crs(nc) <- "+proj=longlat +datum=NAD27"

# Set number of sampling points
npts <- 1e3

# Sample points in nc
ncpts <- st_sample(nc, npts)

# Select first 5 of nc
ncsub <- nc[1:5,]

# Measure distance from ncpts to first 5 of nc
dists <- distance_to(ncpts, ncsub, measure = 'geodesic')

head(dists, 30)
```

    ##  [1]      0.000 178035.835 131322.178  73400.661      0.000  20034.159
    ##  [7] 121285.602 146600.944  59751.849 108922.084  77796.030  25107.692
    ## [13]  74461.054      0.000  52540.105  83764.474      0.000 124205.509
    ## [19]  95812.577  52703.559      0.000   7470.529  48566.962  37029.617
    ## [25] 163566.636 259729.919  39321.158 102596.096 112533.316 198722.848

``` r
# Add to ncpts
ncpts$dist <- dists
```

## Other approaches

-   `nngeo::st_nn`
-   `gdal_proximity`
-   `raster::distance`
-   GUI GIS applications
