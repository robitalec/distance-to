library(tinytest)
library(distanceto)

library(spData)
library(sf)

npts <- 1e4

sample_bbox <- function(shape, n) {
	bbox <- sf::st_bbox(shape)
	sf::st_as_sf(data.frame(
		x = runif(n, bbox[1], bbox[3]),
		y = runif(n, bbox[2], bbox[4])
	), coords = c('x', 'y'),
	crs = sf::st_crs(shape))
}


nc <- st_read(system.file("shapes/sids.shp", package="spData"))
st_crs(nc) <- "+proj=longlat +datum=NAD27"
somenc <- nc[sample(length(nc), 5),]
ncpts <- sample_bbox(nc, npts)




# Full globe
measure <- 'geodesic'
full <- st_as_sf(expand.grid(lon = seq(-180, 180, 5), lat = seq(-90, 90, 5)),
								 coords = c('lon', 'lat'), crs = 4326)
i <- sample(nrow(full), nrow(full) / 2)
o <- seq.int(nrow(full))[!seq.int(nrow(full)) %in% i]
d <- distance_to(full[i,], full[o,], measure = measure)
g <- geodist::geodist(
	st_coordinates(full[i,]),
	st_coordinates(full[o,]),
	measure = measure
)

cbind(full[i,], full[o,][d$nn.idx,])#[d$nn.dists == 0,]

geodist::geodist(
	st_coordinates(full[i,][d$nn.dists == 0,]),
	st_coordinates(full[o,][d$nn.idx,][d$nn.dists == 0,]),
	paired = TRUE,
	measure = 'geodesic'
)

checki <- full[i,]
checki$dist <- d
mapview::mapview(checki[checki$dist == 0,], zcol = 'dist') +
	mapview::mapview(full[o,], col.regions = 'red')
# geometry       geometry.1
# 1    POINT (140 85)   POINT (140 90)
# 2   POINT (100 -80)  POINT (105 -80)
# 3    POINT (-5 -90)  POINT (-10 -90)
# 4  POINT (-130 -60) POINT (-130 -65)
# 5     POINT (75 50)    POINT (80 50)
# 6    POINT (65 -35)   POINT (60 -35)
# 7    POINT (20 -90)   POINT (20 -85)
# 8   POINT (-155 10)   POINT (-155 5)
# 9    POINT (-25 65)   POINT (-30 65)
# 10  POINT (-115 15)  POINT (-115 10)
# dist = 0
