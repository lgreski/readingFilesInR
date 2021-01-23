#
# read NOAA sea surface temperature anomaly data 

noaaSSTData <- "https://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for"
download.file(noaaSSTData,"./data/wksst8110.for")
fileURL <- "./data/wksst8110.for"

# set addresses for fixed length fortran-style input file 
theAddresses <- c("1X","A9","5X","2F4.0","5X","2F4.0","5X","2F4.0","5X","2F4.0")

# define column names 
theColumns <- c("week","nino1and2sst","nino1and2ssta","nino3sst",
                "nino3ssta","nino34sst","nino34ssta",
                "nino4sst","nino4ssta")
df <- read.fortran(file=fileURL,theAddresses,skip = 4)
colnames(df) <- theColumns
head(df)
tail(df)

# read with base::read.fwf()
fwfCols <- c(-1,9,-5,4,4,-5,4,4,-5,4,4,-5,4,4)
df2 <- read.fwf(fileURL,widths=fwfCols,skip=4,
                    col.names=theColumns)

# read with readr::read_fwf()
library(readr)
df3 <- read_fwf(fileURL,fwf_cols(week=c(2,10),
                                 nino1and2sst=c(16,19),nino1and2ssta=c(20,23),
                                 nino3sst=c(29,32),nino3ssta=c(33,36),
                                 nino34sst=c(42,45),nino34ssta=c(46,49),
                                 nino4sst=c(55,58),nino4ssta=c(59,62)),
                skip=4)

library(testthat)
test_that("read.fortran equal to read.fwf",{
  expect_equal(nrow(df),nrow(df2))
  expect_equal(sum(df[["nino1and2sst"]]),sum(df2[["nino1and2sst"]]))
  expect_equal(sum(df[["nino1and2ssta"]]),sum(df2[["nino1and2ssta"]]))
  expect_equal(sum(df[["nino3sst"]]),sum(df2[["nino3sst"]]))
  expect_equal(sum(df[["nino3ssta"]]),sum(df2[["nino3ssta"]]))
  expect_equal(sum(df[["nino34sst"]]),sum(df2[["nino34sst"]]))
  expect_equal(sum(df[["nino34ssta"]]),sum(df2[["nino34ssta"]]))
  expect_equal(sum(df[["nino4sst"]]),sum(df2[["nino4sst"]]))
  expect_equal(sum(df[["nino4ssta"]]),sum(df2[["nino4ssta"]]))
})

test_that("read.fortran equal to read_fwf",{
  expect_equal(nrow(df),nrow(df3))
  expect_equal(sum(df[["nino1and2sst"]]),sum(df3[["nino1and2sst"]]))
  expect_equal(sum(df[["nino1and2ssta"]]),sum(df3[["nino1and2ssta"]]))
  expect_equal(sum(df[["nino3sst"]]),sum(df3[["nino3sst"]]))
  expect_equal(sum(df[["nino3ssta"]]),sum(df3[["nino3ssta"]]))
  expect_equal(sum(df[["nino34sst"]]),sum(df3[["nino34sst"]]))
  expect_equal(sum(df[["nino34ssta"]]),sum(df3[["nino34ssta"]]))
  expect_equal(sum(df[["nino4sst"]]),sum(df3[["nino4sst"]]))
  expect_equal(sum(df[["nino4ssta"]]),sum(df3[["nino4ssta"]]))
})

