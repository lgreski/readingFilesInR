#
# download and read multiple states' PUMS data

theStates <- c("Alabama","Alaska","Arizona")
library(readr)
library(readxl)
# read and clean codebook
source("./readAndCleanCodebookPersonFile.R")

# create data directory if needed
if(!dir.exists("./data")) dir.create("./data")

dfList <- lapply(theStates,function(x){
  # create data directory if needed
  theDirectory <- paste0("./data/",x)
  if(!dir.exists(theDirectory)) dir.create(theDirectory)
  if(!file.exists(paste0("./data/all_",x,".zip"))) {
       download.file(paste0("https://www2.census.gov/census_2000/datasets/PUMS/FivePercent/",x,
                            "/all_",x,".zip"), paste0("./data/all_",x,".zip"),
                     method="curl",
                     mode="wb")
       unzip(paste0("./data/all_",x,".zip"),exdir=paste0("./data/",x))
  }
  # find correct file
  theFile <- list.files(path=theDirectory,pattern="^PUMS",full.names=TRUE)
  # separate person records from household records
  system.time(theInput <- readLines(theFile,n = -1))
  recType <- sapply(theInput,substr,1,1)
  names(recType) <- NULL
  splitData <- split(theInput,recType)
  df <- read_fwf(splitData[["P"]],
                             fwf_widths(colWidths,col_names = colNames))
  df$STATE <- x
  # write out data frame as RDS file, using state name
  saveRDS(df,paste0("./data/",x,"_person.RDS"))
  df # return data frame to parent environment
})
names(dfList) <- theStates

