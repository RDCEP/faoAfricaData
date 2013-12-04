library( reshape2)
library( stringr)
library( plyr)

# read in the data

rwandaArea <- read.csv(
    "yield inputs/Rwanda Area Harvested YF.csv",
    col.names= c(
        "placeCode", "place", "cropCode", "crop",
        paste( rep( 2007:2010, each=2), c("A", "B"))),
    skip= 4, header= FALSE, stringsAsFactors= FALSE, na.strings= "..")

# year/season columns now have names like "X2007.A".
# R automatically prefixes "X" so that names start with letters
# and fills spaces with ".".  This behavior may be overridden but
# it is fine for our purposes.


# melt() makes column names of those not in id.vars into variables

rwandaAreaSerial <- melt(
    rwandaArea, 
    id.vars= colnames( rwandaArea)[ 1:4],
    value.name= "area")


# area values start with weird character so must get rid of first
# character in area, then convert to numeric

rwandaAreaSerial$area <-
    as.numeric( str_sub( rwandaAreaSerial$area, 2))


# break the year/season variable into parts and convert crop names to
# all lower case

rwandaAreaSerial <- within(
    rwandaAreaSerial, {
        yearSeason <- str_match(
            variable,
            "^X(\\d{4})\\.([AB])$")
        year <- yearSeason[ ,2]
        season <- yearSeason[ ,3]
        yearSeason <- NULL
        crop <- tolower( crop) })


# reorder the columns and keep only the ones we want

rwandaAreaSerial <-
    rwandaAreaSerial[, c( "year", "season", "place", "crop", "area")]


# repeat for production

rwandaProduction <- read.csv(
    "yield inputs/Rwanda Production YF.csv",
    col.names= c(
        "placeCode", "place", "cropCode", "crop",
        paste( rep( 2007:2009, each=2), c("A", "B"))),
    skip= 4, header= FALSE, stringsAsFactors= FALSE, na.strings= "..")


# there is no data for 2010 to go with the areas

rwandaProduction <- within(
    rwandaProduction, {
        X2010.A <- NA
        X2010.B <- NA })


## same use of melt() as before

rwandaProductionSerial <- melt(
    rwandaProduction, 
    id.vars= colnames( rwandaArea)[ 1:4],
    value.name= "production")


## remove the same first character from the production statistics,
## then assume that commas are decimal points, so replace them with
## periods before the conversion from character strings to numerics

rwandaProductionSerial$production <-
    as.numeric(
        str_replace(
            str_sub( rwandaProductionSerial$production, 2),
            fixed( ","),
            "."))


# break the year/season variable into parts and convert crop names to
# all lower case

rwandaProductionSerial <- within(
    rwandaProductionSerial, {
        yearSeason <- str_match(
            variable,
            "^X(\\d{4})\\.([AB])$")
        year <- yearSeason[ ,2]
        season <- yearSeason[ ,3]
        yearSeason <- NULL
        crop <- tolower( crop) })


# reorder the columns and keep only the ones we want

rwandaProductionSerial <-
    rwandaProductionSerial[, c( "year", "season", "place", "crop", "production")]


# merge the two data frames

rwanda <- merge(
    rwandaProductionSerial,
    rwandaAreaSerial,
    by= c( "year", "season", "place", "crop"))


## now we see that production equals area in many instances so this
## data is very suspect


rwanda <- within( rwanda,
    yield <- production / area)
                 

write.csv(
    rwanda, "yield/rwanda.csv",
    na= "", row.names= FALSE)      
