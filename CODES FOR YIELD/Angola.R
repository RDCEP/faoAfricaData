library( reshape2)
library( stringr)
library( plyr)

# read in the data

angolaProduction <- read.csv("yield inputs/Angola Production YF.csv",
                col.names= c("year", "place", "crop", "production"),
                header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")



angolaProductionSerial <-
  angolaProduction[, c( "year", "place", "crop", "production")]

angolaProductionSerial <- within(
  angolaProductionSerial,
  crop <- tolower(crop))

# repeat for area

angolaArea <- read.csv( "yield inputs/Angola Area Harvested YF.csv",
                          col.names= c("year","place", "crop", "area" ),
                              header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")


angolaAreaSerial <-
  angolaArea[, c( "year", "place", "crop", "area")]

angolaAreaSerial <- within(
    angolaAreaSerial,
    { area <- str_replace_all( area, ",", "")
      area <- str_replace_all( area, " ", "")
      area <- as.numeric( area)})

angolaAreaSerial <- within(
  angolaAreaSerial,
  crop <- tolower(crop))

# merge the two data frames

angola <- merge(
  angolaProductionSerial,
  angolaAreaSerial,
  by= c( "year", "place", "crop")
  , all= TRUE)



angola <- within(
    angola,
    yield <-
      as.numeric( str_replace_all( production, " ", "")) /
      area)



write.csv(
  angola, "yield/Angola.csv",
  na= "", row.names= FALSE)      
