library( reshape2)
library( stringr)
library( plyr)

# read in the data

malawiProduction <- read.csv("yield inputs/Malawi Production YF.csv",
                           col.names= c(
                             "year", "place", "crop", "production"),
                           header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")



malawiProductionSerial <-
  malawiProduction[, c( "year", "place", "crop", "production")]

malawiProductionSerial <- within(
  malawiProductionSerial,
  crop <- tolower(crop))

# repeat for area

malawiArea <- read.csv( "yield inputs/Malawi Area Harvested YF.csv",
                      col.names= c( "year","place", "crop", "area" ),
                      header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")


malawiAreaSerial <-
  malawiArea[, c( "year", "place", "crop", "area")]


malawiAreaSerial <- within(
  malawiAreaSerial,
  crop <- tolower(crop))

# merge the two data frames as a test took out 

malawi <- merge(
  malawiProductionSerial,
  malawiAreaSerial,
  by= c( "year", "place", "crop"),
  all=TRUE)



                  
malawi <- within( malawi,
              yield <- 
                    as.integer( str_replace_all( production, " ", "")) /
                    as.integer( str_replace_all( area,       " ", "")))
                  
                  
                  
write.csv(
  malawi, "yield/Malawi.csv",
  na= "", row.names= FALSE)      
