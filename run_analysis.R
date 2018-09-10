##Getting & Cleaning Data - Week 4 Peer Assignment
##clean workspace & set working directory
rm(list=ls())
setwd("//ccn.carecompassnetwork.org/shares/RedirectedFolders/rfrancis/Desktop/R Data/data")

##Download Data
filename <- "dataset.zip"
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename)
}
if(!file.exists("UCI HAR Dataset")){
  unzip(filename)
}

##Load Labels
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")
features_need <- features[grep("mean|std", features[,2]), ]

##Load Data
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
train_data_need <- train_data[, as.numeric(features_need[,1])]
train_labels <- read.table("./UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")
test_data_need <- test_data[, as.numeric(features_need[,1])]
test_labels <- read.table("./UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")

##Combine Data into files with lables
train <- cbind(train_subject, train_labels, train_data_need)
test <- cbind(test_subject, test_labels, test_data_need)

##Merge Data into one dataset
mergeddata <- rbind(train, test)

##Clean Data (rename merged data with descriptive variable names)
features_need[,2]<- gsub("-", "_", features_need[,2])
features_need[,2]<- gsub("[()]", "", features_need[,2])
colnames(mergeddata) <- c("subject", "activity", features_need[,2])

##Use descriptive activity names to name activities in dataset
mergeddata$activity <- factor(mergeddata$activity, levels = activity_labels[,1], labels = activity_labels[,2])

##Create a tidy dataset with the average of each variabale for each activity and each subject
data_summary <- aggregate(mergeddata[,3:ncol(mergeddata)], by=list(mergeddata$subject, mergeddata$activity), FUN=mean, na.rm=TRUE)
colnames(data_summary) [1:2] <- c("subject", "activity")
write.table(data_summary, file = "results.txt", row.names = FALSE)
print(data_summary)



