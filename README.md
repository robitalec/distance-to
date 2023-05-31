
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

    ## Linking to GEOS 3.11.2, GDAL 3.7.0, PROJ 9.2.0; sf_use_s2() is TRUE

``` r
# Load nc data
nc <- st_read(system.file("shape/nc.shp", package="sf"))
```

    ## Reading layer `nc' from data source 
    ##   `/home/alecr/R/x86_64-pc-linux-gnu-library/4.3/sf/shape/nc.shp' 
    ##   using driver `ESRI Shapefile'
    ## Simple feature collection with 100 features and 14 fields
    ## Geometry type: MULTIPOLYGON
    ## Dimension:     XY
    ## Bounding box:  xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
    ## Geodetic CRS:  NAD27

``` r
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

    ##  [1] 237543.35 217923.10  91920.82 225703.62  63642.69 141852.37 178301.66
    ##  [8]  88882.68  20298.52      0.00 100173.24 149001.91  68735.30  11992.49
    ## [15] 151591.39 162214.72  67969.38 227235.50  49860.75  42067.82  50899.94
    ## [22]  69211.60 111186.57  35096.09  95508.78 105467.67  31168.95 209061.13
    ## [29]  48339.16  25743.09

``` r
# Add to ncpts
ncpts$dist <- dists
```

## Other approaches

- `nngeo::st_nn`
- `gdal_proximity`
- `raster::distance`
- GUI GIS applications
