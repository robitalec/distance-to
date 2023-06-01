# distanceto 0.0.3 (2023-05-31)

* fix errors with environment variable "_R_CHECK_DEPENDS_ONLY_" [#11](https://github.com/robitalec/distance-to/pull/11)
* update R CMD check GitHub Actions to V2 [#10](https://github.com/robitalec/distance-to/pull/10)
* fix extent check in distance_raster [#9](https://github.com/robitalec/distance-to/pull/9)
* add `lwgeom` to Suggests [#8](https://github.com/robitalec/distance-to/pull/8)
* remove example data and dependency on `spData` [#7](https://github.com/robitalec/distance-to/pull/7)
* add CITATION.cff with `cffr`
* fix R CMD check with GitHub Actions for Mac [#6](https://github.com/robitalec/distance-to/pull/6)

# distanceto 0.0.2 (2021-07-01)

* add basic set of tests for `distance_to` and `distance_raster` with [`tinytest`](https://github.com/markvanderloo/tinytest/)
* fill `distance_raster` man
* fix distance calculation when crs indicates long lat, unprojected coordinates
* basic intro vignette
* use GitHub Actions for test workflow
* add basic pkgdown site
* add "measure" argument to `distance_raster`


# distanceto 0.0.1 (2021-06-26)

* initial 0.0.1 with `distance_to()` and `distance_raster()`
