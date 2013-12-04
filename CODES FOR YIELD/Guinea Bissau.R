library( reshape2)
library( stringr)
library( plyr)

# read in the data

guineabissauProduction <- read.csv("yield inputs/Guinea Bissau Production YF TRANSLATED.csv",
                            col.names= c(
                              "year", "place", "crop", "production"),
                            header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")



guineabissauProductionSerial <-
  guineabissauProduction[, c( "year", "place", "crop", "production")]

guineabissauProductionSerial <- within(
  guineabissauProductionSerial, 
  crop <- tolower(crop))


# repeat for area

guineabissauArea <- read.csv( "yield inputs/Guinea Bissau Area Harvested YF TRANSLATED.csv",
                       col.names= c( "year","place", "crop", "area" ),
                       header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")


guineabissauAreaSerial <-
  guineabissauArea[, c( "year", "place", "crop", "area")]


guineabissauAreaSerial <- within(
  guineabissauAreaSerial, 
  crop <- tolower(crop))

# merge the two data frames

guineabissau <- merge(
  guineabissauProductionSerial,
  guineabissauAreaSerial,
  by= c( "year", "place", "crop"))


guineabissau <- within( guineabissau,
                 yield <- (production) / (area))


write.csv(
  guineabissau, "yield/Guinea Bissau.csv",
  na= "", row.names= FALSE)      
