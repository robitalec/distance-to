
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
    ## Bounding box:  xmin: -84.32 ymin: 33.88 xmax: -75.46 ymax: 36.59
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

    ##  [1]  58577 197193  22441  38363 126321  43659   2916  68251 111654  19194
    ## [11] 135570 183110 143165 158988 256598 136884 114782  74949  38387 104202
    ## [21]  85040  31816  12697 133322  83122  50428  33060      0 113531 136244

``` r
# Add to ncpts
ncpts$dist <- dists
```

## Other approaches

-   `nngeo::st_nn`
-   `gdal_proximity`
-   `raster::distance`
-   GUI GIS applications
