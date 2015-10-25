library(data.table)
library(reshape2)
library(tidyr)

# read the activity labels
activityLabels <- read.table("activity_labels.txt", header=FALSE, na.strings="?")
colnames(activityLabels) <- c("activityID","activityName")

# read the training data
trainActivity <- read.table("train/y_train.txt", header=FALSE, na.strings="?")
trainValues <- read.table("train/X_train.txt", header=FALSE, na.strings="?", nrows=7400, colClasses=c(rep("numeric", 561)))
trainSubject <- read.table("train/subject_train.txt", header=FALSE, na.strings="?")

# read the test data
testActivity <- read.table("test/y_test.txt", header=FALSE, na.strings="?")
testValues <- read.table("test/X_test.txt", header=FALSE, na.strings="?", nrows=3000, colClasses=c(rep("numeric", 561)))
testSubject <- read.table("test/subject_test.txt", header=FALSE, na.strings="?")

# merge the training and test sets to create one data set
mergedValues <- rbind(trainValues,testValues)
mergedActivity <- rbind(trainActivity, testActivity)
mergedSubject <- rbind(trainSubject, testSubject)

# appropriately label the data set with descriptive variable names
headers <- read.table("features.txt", header=FALSE, na.strings="?")
colnames(mergedSubject) <- "subject"
colnames(mergedActivity) <- "activityID"
colnames(mergedValues) <- t(headers[2])

# merge the three datasets into one
completeDataSet <- cbind(mergedSubject, mergedActivity, mergedValues)

# uses descriptive activity names to name the activities in the data set
completeDataSet <- merge(completeDataSet, activityLabels,by="activityID",sort=FALSE,all=FALSE)

# extract only the measurements on the mean and standard deviation for each measurement
# subsetting via grep command
extractData <- cbind(completeDataSet[2], completeDataSet[564], completeDataSet[,grep("std\\(\\)|mean\\(\\)",colnames(completeDataSet))])

# create a second, independent tidy data set with the average of each variable for each activity and each subject
extractData.dt <- data.table(extractData)
tidyData <- melt(extractData.dt, id=c("subject","activityName"))
averageBySubjectActivityMeasurement <- unique(tidyData[,list(average=ave(value)),by='subject,activityName,variable'])
averageBySubjectActivityMeasurement <- averageBySubjectActivityMeasurement[with(averageBySubjectActivityMeasurement,order(subject,variable,activityName)),]
averageBySubjectActivityMeasurement <- separate(data=averageBySubjectActivityMeasurement, col=variable, into=c("measure","function", "direction"))

# write the data
write.table(averageBySubjectActivityMeasurement, file="tidyDataSetWithMelt.txt", row.name=FALSE)


# alternative dataset (without melting)
# different people will interpret tidy differently
tidyData2 <- extractData.dt
alternative <- tidyData2[,lapply(.SD, mean), by=c("subject","activityName")]

# write the data
write.table(alternative, file="tidyDataSetWithoutMelt.txt", row.name=FALSE)

