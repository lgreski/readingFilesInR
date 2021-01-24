#
# read and clean codebook for person files

# download record layout if necessary
if(!file.exists("./data/5%_PUMS_record_layout.xls")) {
  download.file("https://www2.census.gov/census_2000/datasets/PUMS/FivePercent/5%25_PUMS_record_layout.xls",
                "./data/5%_PUMS_record_layout.xls",
                method="curl",
                mode="wb")
}
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
