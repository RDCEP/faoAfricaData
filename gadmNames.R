
library( plyr)
library( stringr)
library( ascii)
options( asciiType= "org")

gadmFiles <- list.files(
  path= "Shapefiles/R Data",
  recursive= TRUE,
  full.names= TRUE)

gadmFileSummary <- data.frame(
  str_match(
    gadmFiles,
    "^.*([A-Z]{3})_adm([0-3])\\.RData$"),
  stringsAsFactors= FALSE)

colnames( gadmFileSummary) <-
  c( "fn", "iso", "adm")

gadmNames <- ldply(
  .data= gadmFileSummary$fn,
  .fun= function( fn) {
    load( fn)
    cols <- c(
      "ISO",
      colnames( gadm@data)[ str_detect( colnames( gadm@data), "^(VAR)*NAME")])
    df <- gadm@data[ , cols]
    colnames( df)[ str_detect( colnames( df), "^VARNAME")] <-
        "VARNAME"
    df})

## If a call to write.csv() does not appear immediately below 
## it is because that section of source code was not tangled
## from pSIMS_FAO_Data.org.  We are editing gadmNames.csv by 
## hand for now.

write.csv( gadmNames[ gadmNames$ISO == "RWA",
                     c( "ISO", "NAME_0", "NAME_1", "NAME_2", "VARNAME")],
    file= "gadmNamesRWA.csv",
    row.names= FALSE,
    na= "")

write.csv( gadmNames[ gadmNames$ISO == "MWI",
                     c( "ISO", "NAME_0", "NAME_1", "NAME_2", "VARNAME")],
    file= "gadmNamesMWI.csv",
    row.names= FALSE,
    na= "")

| iso | fn                                                           | adm |
|-----+--------------------------------------------------------------+-----|
| AGO | Shapefiles/R Data/Angola/AGO_adm1.RData                      |   1 |
| BDI | Shapefiles/R Data/Burundi/BDI_adm1.RData                     |   1 |
| BEN | Shapefiles/R Data/Benin/BEN_adm1.RData                       |   1 |
| BFA | Shapefiles/R Data/Burkina Faso/BFA_adm1.RData                |   1 |
| BFA | Shapefiles/R Data/Burkina Faso/BFA_adm2.RData                |   2 |
| CIV | Shapefiles/R Data/Côte d'Ivoire/CIV_adm1.RData               |   1 |
| CMR | Shapefiles/R Data/Cameroon/CMR_adm1.RData                    |   1 |
| ETH | Shapefiles/R Data/Ethiopia/ETH_adm1.RData                    |   1 |
| GHA | Shapefiles/R Data/Ghana/GHA_adm1.RData                       |   1 |
| GMB | Shapefiles/R Data/Gambia/GMB_adm1.RData                      |   1 |
| GNB | Shapefiles/R Data/Guinea-Bissau/GNB_adm1.RData               |   1 |
| KEN | Shapefiles/R Data/Kenya/KEN_adm1.RData                       |   1 |
| MLI | Shapefiles/R Data/Mali/MLI_adm1.RData                        |   1 |
| MOZ | Shapefiles/R Data/Mozambique/MOZ_adm1.RData                  |   1 |
| MWI | Shapefiles/R Data/Malawi/MWI_adm1.RData                      |   1 |
| NER | Shapefiles/R Data/Niger/NER_adm1.RData                       |   1 |
| NGA | Shapefiles/R Data/Nigeria/NGA_adm1.RData                     |   1 |
| RWA | Shapefiles/R Data/Rwanda/RWA_adm1.RData                      |   1 |
| RWA | Shapefiles/R Data/Rwanda/RWA_adm2.RData                      |   2 |
| TGO | Shapefiles/R Data/Togo/TGO_adm1.RData                        |   1 |
| TZA | Shapefiles/R Data/United Republic of Tanzania/TZA_adm1.RData |   1 |
| ZMB | Shapefiles/R Data/Zambia/ZMB_adm1.RData                      |   1 |
