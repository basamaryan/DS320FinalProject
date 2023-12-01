rm(list = ls())
library(data.table)
library(ISLR)
library(dplyr)
library(gbm)
library(xgboost)
library(plotmo)
library(caret) #http://topepo.github.io/caret/index.html
library(Metrics)
library(glmnet)
library(e1071)
library(Rtsne)
library(ClusterR)
library(lubridate)
library(esquisse)



CPI<- fread('~/Desktop/DS320/CPI.csv')
#PPI<- fread('~/Desktop/DS320/PPI.csv')
M<- fread('~/Desktop/DS320/Money.csv')
Crude<- fread('~/Desktop/DS320/Crude_Oil.csv')

month_mapping <- c(
  "January" = 1, "February" = 2, "March" = 3, "April" = 4,
  "May" = 5, "June" = 6, "July" = 7, "August" = 8,
  "September" = 9, "October" = 10, "November" = 11, "December" = 12
)

# Apply the mapping to create a new column with numeric values
CPI$MonthNumeric <- month_mapping[CPI$Period]
summary(CPI)
order <- c("Year","MonthNumeric","Consumer Price Index")
CPI <- CPI[,order]
colnames(CPI)[colnames(CPI) == "Over-the-Month Percent Change"] <- "Monthly_change"
CPI$Monthly_change <- as.numeric(gsub("%", "", CPI$Monthly_change))

CPI$Monthly_change <- as.numeric(gsub("%", "", CPI$Monthly_change))
CPI <- CPI %>%
  mutate(Result = ifelse(Monthly_change > 0, 1, 0))

Crude$Date <- as.Date(Crude$Date)
Crude$Year <- year(Crude$Date)
Crude$Month <- month(Crude$Date)
Crude$Day <- day(Crude$Date)

M$V1 <- as.Date(M$V1)
M$Year <- year(M$V1)
M$Month <- month(M$V1)
M$Day <- day(M$V1)

colnames(CPI)[colnames(CPI) == "MonthNumeric"] <- "Month"

merged_data <- merge(Crude,CPI ,by = c("Year", "Month"))
merged_data <- merge(merged_data, M, by = c("Year", "Month"))

master <- merged_data[, c("Year", "Month", "Date", "Close", "Volume","V2","Result")]

fwrite(master, '~/Desktop/DS320/master.csv')
