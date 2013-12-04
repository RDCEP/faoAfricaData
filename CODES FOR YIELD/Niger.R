library( reshape2)
library( stringr)
library( plyr)

# read in the data

nigerProduction <- read.csv(
  "yield inputs/Niger Production YF.csv",
  col.names= c(
    "place", "crop", 2000:2011),
  header=TRUE, stringsAsFactors= FALSE, na.strings= "NONE")

# year/season columns now have names like "X2007".

# melt() makes column names of those not in id.vars into variables

nigerProductionSerial <- melt(
  nigerProduction, 
  id.vars= c( "place", "crop"),
  ## id.vars= 1:2,  # same thing using column number
  value.name= "production")


# break the year/season variable into parts and convert crop names to
# all lower case

nigerProductionSerial <- within(
  nigerProductionSerial, {
    year <- str_match(
      variable,
      "^X(\\d{4})$")[ ,2]
    crop <- tolower( crop)
  place[ place == "CUN"] <- "Niamey"})

# reorder the columns and keep only the ones we want 

nigerProductionSerial <-
  nigerProductionSerial[, c( "year", "place", "crop", "production")]


# repeat for area

nigerArea <- read.csv("yield inputs/Niger Area Harvested YF.csv",
  col.names= c("place", "crop", 2000:2011),
  header= TRUE, stringsAsFactors= FALSE, na.strings= "NONE")

# Multiple Year Production data that does not have Area harvested



## same use of melt() as before

nigerAreaSerial <- melt(
  nigerArea, 
  id.vars= colnames(nigerArea)[ 1:2],
  value.name= "area")


# extract year variable and convert crop names to all lower case

nigerAreaSerial <- within(
  nigerAreaSerial, {
    year <- str_match(
      variable,
      "^X(\\d{4})$")[ ,2]
    crop <- tolower( crop) })



# reorder the columns and keep only the ones we want

nigerAreaSerial <-
  nigerAreaSerial[, c( "year", "place", "crop", "area")]


# merge the two data frames

niger <- merge(
  nigerProductionSerial,
  nigerAreaSerial,
  by= c( "year", "place", "crop"))

niger <- within( niger,
                       yield <- as.integer(production) / as.integer(area))


write.csv(
  niger, "yield/Niger.csv",
  na= "", row.names= FALSE)      
