#
# example: read inline data with read.csv()

textData <- "customer_id|gender|past_3_years_bike_related_purchases|DOB|job_industry_category|wealth_segment|owns_car|tenure|state
 1|Female| 93|19644|Health|Mass Customer|Yes|11|New South Wales
 2|Male| 81|29571|Financial Services|Mass Customer|Yes|16|New South Wales
 5|Female| 56|28258|n/a|Affluent Customer|Yes|8|New South Wales
 8|Male| 31|22735|n/a|Mass Customer| No|7|New South Wales
 9|Female| 97|26733|Argiculture|Affluent Customer|Yes| 8|New South Wales
12|Male| 58|34536|Manufacturing|Mass Customer| No| 8|QLD"

data <- read.csv(text = textData,
                 header = TRUE,
                 na.strings = c("n/a","na"),
                 sep="|")

data
