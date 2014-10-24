install.packages("dplyr")
library(dplyr)
library(data.table)
library(reshape2)

# read the activity labels
setwd("C:/Users/pabulson/Documents/Data Science/John Hopkins/Getting and Cleaning Data/Project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
activityLabels <- read.table("activity_labels.txt", header=FALSE, na.strings="?")
colnames(activityLabels) <- c("activityID","activityName")

# read the training data
setwd("C:/Users/pabulson/Documents/Data Science/John Hopkins/Getting and Cleaning Data/Project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train")
trainActivity <- read.table("y_train.txt", header=FALSE, na.strings="?")
trainValues <- read.table("X_train.txt", header=FALSE, na.strings="?")
trainSubject <- read.table("subject_train.txt", header=FALSE, na.strings="?")

# read the test data
setwd("C:/Users/pabulson/Documents/Data Science/John Hopkins/Getting and Cleaning Data/Project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test")
testActivity <- read.table("y_test.txt", header=FALSE, na.strings="?")
testValues <- read.table("X_test.txt", header=FALSE, na.strings="?")
testSubject <- read.table("subject_test.txt", header=FALSE, na.strings="?")

# merge the training and test sets to create one data set
mergedValues <- rbind(trainValues,testValues)
mergedActivity <- rbind(trainActivity, testActivity)
mergedSubject <- rbind(trainSubject, testSubject)

# appropriately label the data set with descriptive variable names
setwd("C:/Users/pabulson/Documents/Data Science/John Hopkins/Getting and Cleaning Data/Project/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
headers <- read.table("features.txt", header=FALSE, na.strings="?")
colnames(mergedSubject) <- "subject"
colnames(mergedActivity) <- "activityID"
colnames(mergedValues) <- t(headers[2])

# merge the three datasets into one
completeDataSet <- cbind(mergedSubject, mergedActivity, mergedValues)
        
# uses descriptive activity names to name the activities in the data set
completeDataSet <- merge(completeDataSet, activityLabels,by="activityID",sort=FALSE,all=FALSE)

# extract only the measurements on the mean and standard deviations for each measurement
# subsetting via grep command
extractData <- cbind(completeDataSet[2], completeDataSet[564], completeDataSet[,grep("std\\(\\)|mean\\(\\)",colnames(completeDataSet))])

# create a second, independent tidy data set with the average of each variable for each activity and each subject
extractData.dt <- data.table(extractData)
tidyData <- melt(extractData.dt, id=c("subject","activityName"))
averageBySubjectActivityMeasurement <- unique(tidyData[,list(average=ave(value)),by='subject,activityName,variable'])
averageBySubjectActivityMeasurement <- averageBySubjectActivityMeasurement[with(averageBySubjectActivityMeasurement,order(subject,variable,activityName)),]

# write the data
write.table(averageBySubjectActivityMeasurement, file="tidyDataSet.txt", row.name=FALSE)