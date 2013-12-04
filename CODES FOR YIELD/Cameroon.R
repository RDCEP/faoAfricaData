library( reshape2)
library( stringr)
library( plyr)

# read in the data

cameroonProduction <- read.csv(
  "yield inputs/Cameroon Production YF.csv",
  col.names= c(
    "place", "crop", 1998:2008),
  header=TRUE, stringsAsFactors= FALSE, na.strings= "NONE")

# year/season columns now have names like "X2007".

# melt() makes column names of those not in id.vars into variables

cameroonProductionSerial <- melt(
  cameroonProduction, 
  id.vars= c( "place", "crop"),
  ## id.vars= 1:2,  # same thing using column number
  value.name= "production")


# break the year/season variable into parts and convert crop names to
# all lower case

cameroonProductionSerial <- within(
  cameroonProductionSerial, {
    year <- str_match(
      variable,
      "^X(\\d{4})$")[ ,2]
    crop <- tolower( crop) })


# reorder the columns and keep only the ones we want 

cameroonProductionSerial <-
  cameroonProductionSerial[, c( "year", "place", "crop", "production")]


# repeat for area

cameroonArea <- read.csv(
  "yield inputs/Cameroon Area Harvested YF.csv",
  col.names= c("place", "crop", 1998:2008),
  header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")



## same use of melt() as before

cameroonAreaSerial <- melt(
  cameroonArea, 
  ##id.vars= colnames(cameroonArea)[ 1:4],
  id.vars= colnames(cameroonArea)[ 1:2],  
  value.name= "area")


# extract year variable and convert crop names to all lower case

cameroonAreaSerial <- within(
  cameroonAreaSerial, {
    year <- str_match(
      variable,
      "^X(\\d{4})$")[ ,2]
    crop <- tolower( crop) })


# reorder the columns and keep only the ones we want

cameroonAreaSerial <-
  cameroonAreaSerial[, c( "year", "place", "crop", "area")]


# merge the two data frames

cameroon <- merge(
  cameroonProductionSerial,
  cameroonAreaSerial,
  by= c( "year", "place", "crop"),
  all= TRUE)


cameroon <- within( cameroon,
                 yield <- as.integer(production) / as.integer(area))


write.csv(
  cameroon, "yield/Cameroon.csv",
  na= "", row.names= FALSE)      
