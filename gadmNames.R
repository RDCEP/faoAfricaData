
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
