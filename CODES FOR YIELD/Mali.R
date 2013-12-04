library( reshape2)
library( stringr)
library( plyr)

# read in the data

maliProduction <- read.csv("yield inputs/Mali Production YF TRANSLATED.csv",
  col.names= c(
    "year", "place", "crop", "production"),
  header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")



maliProductionSerial <-
  maliProduction[, c( "year", "place", "crop", "production")]

maliProductionSerial <- within(
    maliProductionSerial,
    { crop <- str_replace_all( crop, " ", "")
    crop <- tolower( crop)})


# repeat for area

maliArea <- read.csv("yield inputs/Mali Area Harvested YF TRANSLATED.csv",
  col.names= c( "year","place", "crop", "area" ),
  header= TRUE, stringsAsFactors= FALSE, na.strings= c( "NONE", " ..", " ."))


maliAreaSerial <-
  maliArea[, c( "year", "place", "crop", "area")]

maliAreaSerial <- within(
    maliAreaSerial,
    { place <- str_replace_all( place, " ", "")
      crop <- str_replace_all( crop, " ", "")
      crop <- tolower( crop)})


# merge the two data frames as a test took out 

mali <- merge(
  maliProductionSerial,
  maliAreaSerial,
  all= TRUE,
  by= c( "year", "place", "crop"))


mali <- within( mali,
                 yield <- as.integer(production) / as.integer(area))


write.csv(
  mali, "yield/Mali.csv",
  na= "", row.names= FALSE)      
