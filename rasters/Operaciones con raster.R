#Cargar Imagen
library(sp)
library(raster)
r <- raster("C:/Users/hsotelo/Desktop/land_coast_R_2_5_ver.asc")
plot(r)

#Cambio de valores en raster
cambio = r
cambio[which(cambio[]==2)] <- 1
plot(cambio)

#Guardar Imagen
writeRaster(x=cambio,filename="C:/Users/hsotelo/Desktop/land_coast_R_2_5_ver2.asc",format="ascii")

# Consultar imagen
coord <- data.frame(lon=12.8743,lat=-7.2356)
v <- extract(x=r,y=coord)

#Tif to raster
dir <- "/curie_data/ncastaneda/gap-analysis/gap_eggplantBRAHMS/species_richness"
library(raster)
test <- raster(paste0(dir,"/species-richness.tif"))
writeRaster(test, paste0(dir,"/sp_test.asc"),overwrite=T, NAflag=-9999, format="ascii")
# bioclims
bio_dir <- "/curie_data/ncastaneda/geodata/bio_2_5m"
bios <- list.files(bio_dir, pattern=".asc$", full.names=T)
bio.test <- raster(bios[1])

