library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(rjson)

# Loading the data sets

fileName <- "/Users/gfonteno/data/Rstudio/springboard/0.capstone-project/FlowData.csv"
flowData = read.csv(fileName, header = TRUE)

fileName <- "/Users/gfonteno/data/Rstudio/springboard/0.capstone-project/SensorData.csv"
sensorData = read.csv(fileName, header = TRUE)

# Cleaning the flow/host data sets

#1) Remove ROWs with non IPv4 addresses in Source and Destination

flowData <- flowData %>% 
  filter(str_detect(src_address, ".*?(\\d+\\.\\d+\\.\\d+\\.\\d+).*?")) %>%
  filter(str_detect(dst_address, ".*?(\\d+\\.\\d+\\.\\d+\\.\\d+).*?"))

#2) Remove ROWs with no (missing) destination HOSTNAME

flowData <- with(flowData, flowData[!(dst_hostname == "" | is.na(dst_hostname)), ])

#3) Merge data sets, flows and hosts

data <- merge(sensorData, flowData, by.x=c('host_name'), by.y=c('dst_hostname'))

#4) Add new column Total Packet, total_pkts

data$total_pkts <- data$rev_pkts + data$fwd_pkts

#5) Add new column Total Bytes, total_bytes

data$total_bytes <- data$rev_bytes + data$fwd_bytes

#6) Add new column Platform Type, platform_type

data <- data %>% 
  mutate(platform_type = ifelse(str_detect(platform, ".*?(^MS.+).*?"), 0, 1))

#7) Add new column time, time_min

data <- data %>% mutate(time_min = format(as.POSIXct(strptime(data$timestamp,"%Y-%m-%dT%H:%M:%S",tz="")) ,format = "%I:%M"))

#Logistic Regrsssion

# Generate a TEST AND TRAINING SET
set.seed(100)
split = sample.split(data$platform_type, SplitRatio = 0.55)
dataTrain = subset(data, split == TRUE)
nrow(dataTrain)
dataTest = subset(data, split == FALSE)
nrow(dataTest)

# Determine the total for each field of the dependent variable
table(dataTrain$platform_type)

# Update the dependent variable field to convert it to a vector
data$platform_type <- as.factor(data$platform_type)

# Logistic Regression
platformLog = glm(platform_type ~ proto + total_pkts, data = dataTrain, family = binomial)
summary(platformLog)

# Prediction
predictTrain = predict(platformLog, type="response")
summary(predictTrain)

# Display the mean of the Training set
tapply(predictTrain, dataTrain$platform_type, mean)

# 1 is Windows Platform
# 0 is Linux


