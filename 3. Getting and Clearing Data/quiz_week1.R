setwd('Documents/Data_Science/3. Getting and Clearing Data')
library(data.table)
fileUrl <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv'
download.file(fileUrl, destfile = './data_quiz_week1.csv', method = 'curl')
data <- read.csv('data_quiz_week1.csv')
dt <-  as.numeric(data$VAL)
table(dt[dt == 24])

library(xlsx)
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx'
download.file(fileURL, destfile = './data_quiz_week1.xlsx', mode="w", method = 'curl')
rowIndex = 18 : 23
colIndex = 7 : 15
dat <- read.xlsx("./data/gas.xlsx", sheetIndex = 1, rowIndex = rowIndex, colIndex = colIndex, header = TRUE)
sum(dat$Zip * dat$Ext, na.rm=T)


library(XML)
file_url <-'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml'
data <- xmlTreeParse(sub("s", "", file_url), useInternalNodes = TRUE)
rootNode <- xmlRoot(data)
xmlName(rootNode)
rootNode[[1]][[1]]
zipc <- xpathSApply(rootNode, '//zipcode', xmlValue)
length(zipc[zipc == 21231])


fileUrl2 <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv'
download.file(fileUrl2, destfile = './quiz_week1_5.csv', method = 'curl')
data <- read.csv('quiz_week1_5.csv')

DT <- fread('quiz_week1_5.csv')
# We can change the value of "race" according to our needs
race <- 1000

# This method use the features of data.table.
# replicate(race, function for measuring time(function being tested)[bit of 
# function for measuring time result which exploring with str suggests the 
# specific user time is in])
horse1 <- replicate(race, unname(system.time(DT[, mean(pwgtp15), by = SEX]))[1])

# This method will be slowest because it has two parts, and can be leave out of
# the speed race
system.time({mean(DT[DT$SEX == 1, ]$pwgtp15); mean(DT[DT$SEX == 2, ]$pwgtp15)})

# Wrong coding script: the "by" argument is not used, so 
# "mean(DT$pwgtp15, by = DT$SEX)" is just the same as "mean(DT$pwgtp15)"
mean(DT$pwgtp15, by = DT$SEX)

# This method use tapply() function to solve the problem:
horse2 <- replicate(race, unname(system.time(tapply(DT$pwgtp15, DT$SEX, mean)))[1])

# This method use split() and sapply() functions to solve the problem:
horse3 <- replicate(race, unname(system.time(sapply(split(DT$pwgtp15, DT$SEX), mean)))[1])

# Wrong coding script: it doesn't meet the need of the question
rowMeans(DT)[DT$SEX == 1]
rowMeans(DT)[DT$SEX == 2]

# Calculate the mean of each horse and choose which is the fastest horse, namely
# the fastest way to calculate the average value of the variable "pwgtp15"
mean(horse1)
mean(horse2)
mean(horse3)

# All three results show that the horse3 is the fastest horse. That means the 
# method using split() and sapply() functions is the most effective way.
# Results 1:
# > mean(horse1)
# [1] 0.001261
# > mean(horse2)
# [1] 0.001615
# > mean(horse3)
# [1] 0.000998

# Results 2:
# > mean(horse1)
# [1] 0.001168
# > mean(horse2)
# [1] 0.001608
# > mean(horse3)
# [1] 0.001074

# Results 3:
# > mean(horse1)
# [1] 0.001207
# > mean(horse2)
# [1] 0.001741
# > mean(horse3)
# [1] 0.00102

# Futhermore:
# We can see how the measure times are based on the batches in the computers 
# chip cycle if we just make graphs of each individual result
plot(horse1)
plot(horse2)
plot(horse3)

# The cumulative average changes:
horse1_av <- cumsum(horse1) / seq_along(horse1)
horse2_av <- cumsum(horse2) / seq_along(horse2)
horse3_av <- cumsum(horse3) / seq_along(horse3)

# Plot lines (horse1 use red line; horse2 use blue line; horse3 use black line):
# Making sure the y axis is at the right height
topY <- max(horse1_av, horse2_av, horse3_av)
lowY <- min(horse1_av, horse2_av, horse3_av)
plot(horse1_av, type = "l", col = "#FF000099", ylim = c(lowY, topY), 
     xlab = "distance", ylab = "average time")
lines(horse2_av, col = "#0000FF99")
lines(horse3_av, col = "#00000099")

# Also, we can plot points of all three horses:
topY <- max(horse1, horse2, horse3)
lowY <- min(horse1, horse2, horse3)
plot(horse1, type = "p", col = "#FF000099", ylim = c(lowY, topY), 
     xlab = "distance", ylab = "user time")
points(horse2, col = "#0000FF99")
points(horse3, col = "#00000099")
