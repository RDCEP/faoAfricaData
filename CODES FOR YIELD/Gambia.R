library( reshape2)
library( stringr)
library( plyr)

# read in the data

gambiaProduction <- read.csv(
  "yield inputs/Gambia Produciton YF.csv",
  col.names= c(
    "place", "crop", 1987:2011),
    header=TRUE, stringsAsFactors= FALSE, na.strings= c("..","...","NONE"))

# year/season columns now have names like "X2007".

# melt() makes column names of those not in id.vars into variables

gambiaProductionSerial <- melt(
  gambiaProduction, 
  id.vars= c( "place", "crop"),
  ## id.vars= 1:2,  # same thing using column number
  value.name= "production")


# break the year/season variable into parts and convert crop names to
# all lower case

gambiaProductionSerial <- within(
  gambiaProductionSerial, {
    year <- str_match(
      variable,
      "^X(\\d{4})$")[ ,2]
    crop <- tolower( crop) })

# Reorder to keep what we want

gambiaProductionSerial <- 
  gambiaProductionSerial[, c( "year", "place", "crop", "production")]



# repeat for area
gambiaArea <- read.csv(
  "yield inputs/Gambia Area Harvested YF.csv",
  col.names= c( "place","crop", 1987:2000),
  header= TRUE, stringsAsFactors= FALSE, na.strings= c("NONE", "..", "..."))

# Add missing yrs. gambiaArea <- 

gambiaArea <- within( gambiaArea, { X2001 <- NA})
gambiaArea <- within( gambiaArea, { X2002 <- NA})
gambiaArea <- within( gambiaArea, { X2003 <- NA})
gambiaArea <- within( gambiaArea, { X2004 <- NA})
gambiaArea <- within( gambiaArea, { X2005 <- NA})
gambiaArea <- within( gambiaArea, { X2006 <- NA})
gambiaArea <- within( gambiaArea, { X2007 <- NA})
gambiaArea <- within( gambiaArea, { X2008 <- NA})
gambiaArea <- within( gambiaArea, { X2009 <- NA})
gambiaArea <- within( gambiaArea, { X2010 <- NA})
gambiaArea <- within( gambiaArea, { X2011 <- NA})

## same use of melt() as before

gambiaAreaSerial <- melt(
  gambiaArea, 
  id.vars= colnames(gambiaArea)[ 1:2],  
  value.name= "area")


# extract year variable and convert crop names to all lower case

gambiaAreaSerial <- within(
  gambiaAreaSerial, {
    year <- str_match(
      variable,
      "^X(\\d{4})$")[ ,2]
    crop <- tolower( crop) })


# reorder the columns and keep only the ones we want

gambiaAreaSerial <-
  gambiaAreaSerial[, c( "year", "place", "crop", "area")]

#name of place, fix

gambiaAreaSerial <- within(
  gambiaAreaSerial,
  place [ place=="Kuntaur and Janjanbureh (Central River)"] <-"Janjabureh and Kuntaur (Central River)")
                  

# merge the two data frames

gambia <- merge(
  gambiaProductionSerial,
  gambiaAreaSerial,
  by= c( "year", "place", "crop"),
  all=TRUE)


##yield 
  
gambia <- within( gambia,
                    yield <- 
                      as.integer( str_replace_all( production, ",", "")) /
                      as.integer( str_replace_all( area,       ",", "")))  
  

write.csv(
  gambia, "yield/Gambia.csv",
  na= "", row.names= FALSE)      
