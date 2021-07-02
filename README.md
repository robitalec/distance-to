
<!-- badges: start -->

[![R-CMD-check](https://github.com/robitalec/distance-to/workflows/R-CMD-check/badge.svg)](https://github.com/robitalec/distance-to/actions)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
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

    ## Linking to GEOS 3.9.1, GDAL 3.2.3, PROJ 8.0.1

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

# Measure distance from ncpts to first 5 of nc, printing result
dists <- distance_to(ncpts, ncsub, measure = 'geodesic')

head(dists, 30)
```

    ##  [1]  79851.44  87188.74 192377.82 171686.56  33223.37 153264.43  84889.23
    ##  [8] 164695.39 216864.40  18577.61  80896.37 128905.58 143141.38  22487.21
    ## [15]      0.00 214936.25 187577.76  58380.75  70774.74 225874.91 102702.77
    ## [22]  10444.36 111423.41      0.00  16081.69  39784.13 231695.98 140684.71
    ## [29]  93868.72  17832.23

``` r
# Add to ncpts
ncpts$dist <- dists
```

## Other approaches

-   `nngeo::st_nn`
-   `gdal_proximity`
-   `raster::distance`
-   GUI GIS applications
