library( reshape2)
library( stringr)
library( plyr)

# read in the data

kenyaProduction <- read.csv(
    "yield inputs/Kenya Production YF.csv",
    col.names= c(
        "place", "crop", 2005:2008),
    header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")

# year/season columns now have names like "X2007".

# melt() makes column names of those not in id.vars into variables

kenyaProductionSerial <- melt(
    kenyaProduction, 
    id.vars= c( "place", "crop"),
    ## id.vars= 1:2,  # same thing using column number
    value.name= "production")


# production values start with weird character so must get rid of first
# character in production, then convert to numeric

kenyaProductionSerial$production <-
    as.numeric( str_sub( kenyaProductionSerial$production, 2))


# break the year/season variable into parts and convert crop names to
# all lower case

kenyaProductionSerial <- within(
    kenyaProductionSerial, {
        year <- str_match(
            variable,
            "^X(\\d{4})$")[ ,2]
        crop <- tolower( crop) })


# reorder the columns and keep only the ones we want

kenyaProductionSerial <-
    kenyaProductionSerial[, c( "year", "place", "crop", "production")]


# repeat for area

kenyaArea <- read.csv(
    "yield inputs/Kenya Area Harvested YF.csv",
    col.names= c(
        "placeCode", "place", "cropCode", "crop",
        2006:2008),
    skip= 3, header= FALSE, stringsAsFactors= FALSE, na.strings= c( ".", ".."))


# there is no data for 2005 to go with the areas

kenyaArea <- within(
    kenyaArea, 
    X2005 <- NA)


## same use of melt() as before

kenyaAreaSerial <- melt(
    kenyaArea, 
    id.vars= colnames( kenyaArea)[ 1:4],
    value.name= "area")


## remove the same first character from the area statistics

kenyaAreaSerial$area <-
    as.numeric(
        str_sub( kenyaAreaSerial$area, 2))


# extract year variable and convert crop names to all lower case

kenyaAreaSerial <- within(
    kenyaAreaSerial, {
        year <- str_match(
            variable,
            "^X(\\d{4})$")[ ,2]
        crop <- tolower( crop) })


# reorder the columns and keep only the ones we want

kenyaAreaSerial <-
    kenyaAreaSerial[, c( "year", "place", "crop", "area")]


# merge the two data frames

kenya <- merge(
    kenyaProductionSerial,
    kenyaAreaSerial,
    by= c( "year", "place", "crop"))


kenya <- within( kenya,
    yield <- production / area)
                 

write.csv(
    kenya, "yield/Kenya.csv",
    na= "", row.names= FALSE)      
