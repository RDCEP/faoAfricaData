library( reshape2)
library( stringr)
library( plyr)

# read in the data

togoProduction <- read.csv(
  "yield inputs/Togo Production YF.csv",
  col.names= c(
    "place", "crop", 2001:2011),
  header=TRUE, stringsAsFactors= FALSE, na.strings= "NONE")

# year/season columns now have names like "X2007".

# melt() makes column names of those not in id.vars into variables

togoProductionSerial <- melt(
  togoProduction, 
  id.vars= c( "place", "crop"),
    ## id.vars= 1:2,  # same thing using column number
  value.name= "production")


# break the year/season variable into parts and convert crop names to
# all lower case

togoProductionSerial <- within(
  togoProductionSerial, {
    year <- str_match(
      variable,
      "^X(\\d{4})$")[ ,2]
    crop <- tolower( crop) })


# reorder the columns and keep only the ones we want 

togoProductionSerial <-
  togoProductionSerial[, c( "year", "place", "crop", "production")]


# repeat for area

togoArea <- read.csv(
  "yield inputs/Togo Area Harvested YF.csv",
  col.names= c("place", "crop", 2001:2010),
  header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")

togoArea <- within( togoArea, { X2011 <- NA})

## same use of melt() as before

togoAreaSerial <- melt(
  togoArea, 
  id.vars= colnames(togoArea)[ 1:2],
  value.name= "area")


# extract year variable and convert crop names to all lower case

togoAreaSerial <- within(
  togoAreaSerial, {
    year <- str_match(
      variable,
      "^X(\\d{4})$")[ ,2]
    crop <- tolower( crop)
    place[ place == "Trays"] <- "Tops"
    place[ place == "Savannas"] <- "Savannah"
    place <- toupper( place)})


# reorder the columns and keep only the ones we want

togoAreaSerial <-
  togoAreaSerial[, c( "year", "place", "crop", "area")]


# merge the two data frames

togo <- merge(
  togoProductionSerial,
  togoAreaSerial,
  by= c( "year", "place", "crop"))



togo <- within( togo,
                    yield <- (production) / (area))
  

write.csv(
  togo, "yield/Togo.csv",
  na= "", row.names= FALSE)      
