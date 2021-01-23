#
# example: read inline data with read.table()

textData <- "id Country                        Relationship_type
1 Algeria                                      2
2 Bulgaria                                     1
3 USA                                          2
4 Algeria                                      3
5 Germany                                      2
6 USA                                          1
7 Algeria                                      1
8 Bulgaria                                     3
9 USA                                          2
10 Algeria                                     2
11 Germany                                     1
12 USA                                         3"


df <- read.table(text=textData,header=TRUE)