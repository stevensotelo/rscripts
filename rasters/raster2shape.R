
# Convertir raster a shapefile
# Basado en:
# https://johnbaumgartner.wordpress.com/2012/07/26/getting-rasters-into-shape-from-r/
# Instalar también:
# http://trac.osgeo.org/osgeo4w/


# ============================================================================= #
# Internet case
# ============================================================================= #

library(raster)
library(rasterVis)
library(maptools)

download.file('http://dl.dropbox.com/u/1058849/blog/NEcountries.asc.zip', destfile={f <- tempfile()}, quiet=TRUE, cacheOK=FALSE)
unzip(f, exdir={d <- tempdir()})
library(rasterVis)
r <- raster(file.path(d, 'NEcountries.asc'), crs=CRS('+proj=longlat'))
levelplot(r, margin=FALSE, col.regions=rainbow)

gdal_polygonizeR <- function(x, outshape=NULL, gdalformat = 'ESRI Shapefile', 
                             pypath=NULL, readpoly=TRUE, quiet=TRUE) {
  if (isTRUE(readpoly)) require(rgdal)
  if (is.null(pypath)) {
    pypath <- Sys.which('gdal_polygonize.py')
  }
  if (!file.exists(pypath)) stop("Can't find gdal_polygonize.py on your system.") 
  owd <- getwd()
  on.exit(setwd(owd))
  setwd(dirname(pypath))
  if (!is.null(outshape)) {
    outshape <- sub('\\.shp$', '', outshape)
    f.exists <- file.exists(paste(outshape, c('shp', 'shx', 'dbf'), sep='.'))
    if (any(f.exists)) 
      stop(sprintf('File already exists: %s', 
                   toString(paste(outshape, c('shp', 'shx', 'dbf'), 
                                  sep='.')[f.exists])), call.=FALSE)
  } else outshape <- tempfile()
  if (is(x, 'Raster')) {
    require(raster)
    writeRaster(x, {f <- tempfile(fileext='.asc')})
    rastpath <- normalizePath(f)
  } else if (is.character(x)) {
    rastpath <- normalizePath(x)
  } else stop('x must be a file path (character string), or a Raster object.')
  system2('python', args=(sprintf('"%1$s" "%2$s" -f "%3$s" "%4$s.shp"', 
                                  pypath, rastpath, gdalformat, outshape)))
  if (isTRUE(readpoly)) {
    shp <- readOGR(dirname(outshape), layer = basename(outshape), verbose=!quiet)
    return(shp) 
  }
  return(NULL)
}

# r <- raster("/home/hachicanoy/NEcountries.asc")
# p <- gdal_polygonizeR(r)
# proj4string(p) <- "+proj=longlat +datum=WGS84"
# writePolyShape(p,"/home/hachicanoy/shapeTest/")

# ============================================================================= #
# EggplantBRAHMS case
# ============================================================================= #

library(raster)
library(rasterVis)

r <- raster("/curie_data/ncastaneda/gap-analysis/gap_eggplantBRAHMS/species_richness/sp_test.asc")
gdal_polygonizeR <- function(x, outshape=NULL, gdalformat = 'ESRI Shapefile', 
                             pypath=NULL, readpoly=TRUE, quiet=TRUE) {
  if (isTRUE(readpoly)) require(rgdal)
  if (is.null(pypath)) {
    pypath <- Sys.which('gdal_polygonize.py')
  }
  if (!file.exists(pypath)) stop("Can't find gdal_polygonize.py on your system.") 
  owd <- getwd()
  on.exit(setwd(owd))
  setwd(dirname(pypath))
  if (!is.null(outshape)) {
    outshape <- sub('\\.shp$', '', outshape)
    f.exists <- file.exists(paste(outshape, c('shp', 'shx', 'dbf'), sep='.'))
    if (any(f.exists)) 
      stop(sprintf('File already exists: %s', 
                   toString(paste(outshape, c('shp', 'shx', 'dbf'), 
                                  sep='.')[f.exists])), call.=FALSE)
  } else outshape <- tempfile()
  if (is(x, 'Raster')) {
    require(raster)
    writeRaster(x, {f <- tempfile(fileext='.asc')})
    rastpath <- normalizePath(f)
  } else if (is.character(x)) {
    rastpath <- normalizePath(x)
  } else stop('x must be a file path (character string), or a Raster object.')
  system2('python', args=(sprintf('"%1$s" "%2$s" -f "%3$s" "%4$s.shp"', 
                                  pypath, rastpath, gdalformat, outshape)))
  if (isTRUE(readpoly)) {
    shp <- readOGR(dirname(outshape), layer = basename(outshape), verbose=!quiet)
    return(shp) 
  }
  return(NULL)
}
system.time(p <- gdal_polygonizeR(r))

library(maptools)
print(proj4string(p))
proj4string(p) <- "+proj=longlat +datum=WGS84"

writePolyShape(p,"/home/hachicanoy/test/")
