#
# read GA 2000 American Community Survey data 
#
# https://www2.census.gov/census_2000/datasets/PUMS/FivePercent

# create data directories if needed
if(!dir.exists("./data")) dir.create("./data")
if(!dir.exists("./data/Georgia")) dir.create("./data/Georgia")

# download & extract Georgia file if necessary 
system.time(if(!file.exists("./data/Georgia/PUMS5_13.TXT")){
  download.file("https://www2.census.gov/census_2000/datasets/PUMS/FivePercent/Georgia/all_Georgia.zip",
                "./data/all_Georgia.zip",
                method="curl",
                mode="wb")
   unzip("./data/all_Georgia.zip",exdir="./data/Georgia")
})

# download record layout if necessary
if(!file.exists("./data/5%_PUMS_record_layout.xls")) {
  download.file("https://www2.census.gov/census_2000/datasets/PUMS/FivePercent/5%25_PUMS_record_layout.xls",
                "./data/5%_PUMS_record_layout.xls",
                method="curl",
                mode="wb")
}

# download record counts if necessary
if(!file.exists("./data/5%_PUMS_pop_housing_counts.xls")) {
  download.file("https://www2.census.gov/census_2000/datasets/PUMS/FivePercent/5%_PUMS_pop_housing_counts.xls",
                "./data/5%_PUMS_pop_housing_counts.xls",
                method="curl",
                mode="wb")
}

# separate person records from household records
system.time(theInput <- readLines("./data/Georgia/PUMS5_13.TXT",n = -1))
recType <- sapply(theInput,substr,1,1)
names(recType) <- NULL
splitData <- split(theInput,recType)

# verify that total rows across split vectors equals number 
# of elements in original file
(length(splitData[[1]])+ length(splitData[[2]])) == length(theInput)

# read the code book person record columns through 5% value description
library(readxl)
cellRange <- "A2:J1219"
codeBook <- read_xls("./data/5%_PUMS_record_layout.xls",
                     sheet=2,
                     range=cellRange)

# fix data error in spreadsheet: missing value for RT column 
codeBook$RT <- "P"

# remove blank rows and columns specific to 1% sample, 
# then drop LO and VALUE DESCRIPTION. If the 5% sample LO column is blank
# the row belongs to the 1% sample only 
codeBook <- codeBook[!is.na(codeBook$VARIABLE) & !is.na(codeBook$LO),][,1:7]
## remove duplicate rows 
codeBook <- unique(codeBook)

## remove NA rows by setting length to a numeric variable, and processing
## with !is.na
codeBook$LEN <- as.numeric(codeBook$LEN)
codeBook <- codeBook[!is.na(codeBook$LEN),]

## set widths vector to LEN (length) column 
colWidths <- codeBook$LEN

## sum of lengths should be <= 316, per codebook
sum(codeBook$LEN)

## set column names to the VARIABLE column in codebook
colNames <- codeBook$VARIABLE

library(readr)
system.time(df <- read_fwf(splitData[["P"]],
               fwf_widths(colWidths,col_names = colNames)))

# run a simple analysis
df$AGE <- as.numeric(df$AGE)
hist(df$AGE)
summary(df$AGE)

# legacy approach: write records to files and read the person file
# warning: this requires about 10 minutes of runtime for GA file
inFile <- "./data/Georgia/PUMS5_13.TXT"
outputPersonFile <- "./data/Georgia/PUMS_person.txt"
outputHouseholdFile <- "./data/Georgia/PUMS_household.txt"

system.time(theInput <- readLines(inFile,n = -1))
system.time(theResult <- lapply(theInput,function(x) {
  if(substr(x,1,1)=="P") {cat(x,file=outputPersonFile,sep="\n",append=TRUE)}
  else {cat(x,file=outputHouseholdFile,sep="\n",append=TRUE)}
}))

# read split raw data file
system.time(df <- read_fwf("./data/Georgia/PUMS_person.txt",
                           fwf_widths(colWidths,col_names = colNames)))

print(object.size(theInput),units="Mb")
