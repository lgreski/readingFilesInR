#
# readPUMSWithHipread.R
#
# author    date       description
# ========= ========== ========================
# lgreski   2021-01-28 initial version

library(hipread)

# read the code book person record columns through 5% value description
library(readxl)
cellRange <- "A2:J1219"
person <- read_xls("./data/5%_PUMS_record_layout.xls",
                     sheet=2,
                     range=cellRange)

# fix data error in spreadsheet: missing value for RT column 
person$RT <- "P"

person <- person[!is.na(person$VARIABLE) & !is.na(person$LO),][,1:7]
## remove duplicate rows 
person <- unique(person)

## remove NA rows by setting length to a numeric variable, and processing
## with !is.na
person$LEN <- as.numeric(person$LEN)
person <- person[!is.na(person$LEN),]

## set widths vector to LEN (length) column 
colWidths <- person$LEN

## sum of lengths should be <= 316, per person
sum(person$LEN)

# read household data dictionary
cellRange <- "A2:J632"
household <- read_xls("./data/5%_PUMS_record_layout.xls",
                      sheet=1,
                      range=cellRange)

# remove blank rows and columns specific to 1% sample, 
# then drop LO and VALUE DESCRIPTION. If the 5% sample LO column is blank
# the row belongs to the 1% sample only 
household <- household[!is.na(household$VARIABLE) & !is.na(household$LO),][,1:7]
## remove duplicate rows 
household <- unique(household)

## remove NA rows by setting length to a numeric variable, and processing
## with !is.na
household$LEN <- as.numeric(household$LEN)
household <- household[!is.na(household$LEN),]

## set widths vector to LEN (length) column 
colWidths <- household$LEN

## sum of lengths should be <= 266, per household
sum(household$LEN)

# now, read data with hipread_list()

data <- hipread_list(
  "./data/Georgia/PUMS5_13.TXT",
  list(
    H = hip_fwf_widths(
      household$LEN,
      household$VARIABLE,
      rep("c",length(household$VARIABLE))
    ),
    P = hip_fwf_widths(
      person$LEN,
      person$VARIABLE,
      rep("c",length(person$VARIABLE))
    )
  ),
  hip_rt(1, 1)
)

# number of observations in person file
df <- data[["P"]]
nrow(df)
# run a simple analysis
df$AGE <- as.numeric(df$AGE)
hist(df$AGE)
summary(df$AGE)
