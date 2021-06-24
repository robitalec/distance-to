library(nabor)
# install.packages('spData')
library(sf)

nc <- st_read(system.file("shapes/sids.shp", package="spData")[1], quiet=TRUE)


somenc <- nc[sample(length(nc), 10),]

pts <- st_sample(nc, 100)

plot(pts)


