library( reshape2)
library( stringr)
library( plyr)

# read in the data

ghanaProduction <- read.csv("yield inputs/Ghana Production YF.csv",
                             col.names= c(
                               "year", "place", "crop", "production"),
                             header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")


ghanaProductionSerial <-
  ghanaProduction[, c( "year", "place", "crop", "production")]


ghanaProductionSerial <- within(
  ghanaProductionSerial,
  crop <- tolower(crop))


# repeat for area

ghanaArea <- read.csv( "yield inputs/Ghana Area Harvested YF.csv",
                        col.names= c( "year","place", "crop", "area" ),
                        header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")


ghanaAreaSerial <-
  ghanaArea[, c( "year", "place", "crop", "area")]



ghanaAreaSerial <- within(
  ghanaAreaSerial,
  crop <- tolower(crop))


# merge the two data frames. 

ghana <- merge(
  ghanaProductionSerial,
  ghanaAreaSerial,
  by= c( "year", "place", "crop"))


ghana <- within( ghana,
                yield <- as.integer(production) / as.integer(area))
                  
                
                  
write.csv(
      ghana, "yield/Ghana.csv",
      na= "", row.names= FALSE)      
                  