
<!-- badges: start -->

[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-green.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
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

    ## Linking to GEOS 3.11.1, GDAL 3.6.3, PROJ 9.1.0; sf_use_s2() is TRUE

``` r
# Load nc data
nc <- st_read(system.file("shapes/sids.shp", package="spData"))
```

    ## Reading layer `sids' from data source 
    ##   `/home/alecr/R/x86_64-pc-linux-gnu-library/4.2/spData/shapes/sids.shp' 
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

    ##  [1] 108573.1190    853.4608 118417.6123  51536.3302 143143.2330 218285.7259
    ##  [7]  56784.4216 142665.4391  46833.9310 138812.2872  66651.4988 190312.2238
    ## [13]  21514.2519 155223.6789  36282.4187 230433.7776 142393.7304 137011.1487
    ## [19]  80001.9140 117340.7001  17811.4081 157349.3424 158989.0196 124539.8040
    ## [25] 161844.0718 158726.5087  69442.7506  68322.1046  20978.3661 228094.7548

``` r
# Add to ncpts
ncpts$dist <- dists
```

## Other approaches

- `nngeo::st_nn`
- `gdal_proximity`
- `raster::distance`
- GUI GIS applications
