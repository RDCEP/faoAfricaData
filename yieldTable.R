library( plyr)
library( reshape2)
library( stringr)

yieldFiles <- list.files( "yield", "csv$", full.names= TRUE)

## > yieldFiles
##  [1] "yield/Angola (Numbers calculated Yield).csv"                             
##  [2] "yield/Angola.csv"                                                        
##  [3] "yield/Cameroon.csv"                                                      
##  [4] "yield/Ghana.csv"                                                         
##  [5] "yield/Guinea Bissau- missing 2011 production- though no area for it .csv"
##  [6] "yield/kenya.csv"                                                         
##  [7] "yield/Malawi (Numbers calculated Yield).csv"                             
##  [8] "yield/Malawi.csv"                                                        
##  [9] "yield/Mali.csv"                                                          
## [10] "yield/Niger.csv"                                                         
## [11] "yield/rwanda.csv"                                                        
## [12] "yield/Togo.csv"                                                          

yieldFiles <- yieldFiles[ c( 1, 3, 4, 5, 6, 7, ##9,
                            10, 11, 12)]
yieldFileCodes <- c( "AGO", "CMR", "GHA", "GNB", "KEN", "MWI", #"MLI",
                    "NER", "RWA", "TGO")


loadYieldFile <- function( df) {
    ## with( df, {
    yieldDf <- read.csv( df$fn, stringsAsFactors= FALSE)
    ## yieldDf$iso <- df$iso
    yieldDf
}

yieldDf <- ddply(
    .data= data.frame(
        iso= yieldFileCodes,
        fn= yieldFiles,
        stringsAsFactors= FALSE),
    .variables= .( iso, fn),
    .fun= loadYieldFile)

yieldDf <- within( yieldDf, {
    crop <- tolower( crop)
    crop[ crop == "corn"] <- "maize"
    crop[ crop == "maize composite"] <- "maize"
    crop[ str_detect( crop, "soy")] <- "soy"})

## yieldTable <- acast(
##     data= yieldDf,
##     formula= iso + place ~ year ~ crop,
##     fun.aggregate= length,
##     value.var= "yield",
##     subset= .( crop %in% c( "maize", "wheat", "rice") & !is.na( yield)))


## yieldTable <- dcast(
##     data= yieldDf,
##     formula= crop+ iso + place ~ year,
##     fun.aggregate= length,
##     value.var= "yield",
##     subset= .( crop %in% c( "maize", "wheat", "rice", "soy") & !is.na( yield)))

yieldTable <- dcast(
    data= yieldDf,
    formula= iso + place ~ crop,
    fun.aggregate= length,
    value.var= "yield",
    subset= .( crop %in% c( "maize", "wheat", "rice", "soy") & !is.na( yield)))

write.csv( yieldTable, file= "yieldTable.csv")
