##Load Library
library(dplyr)
##Download Zip and Unzip
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","./UCIHarDataset.zip")
unzip("./UCIHarDataset.zip")

##Import Data
feature <- read.table("./UCIHARDataset/features.txt", sep = " ", col.names = c("id","name"))
activitylabels <- read.table("./UCIHARDataset/activity_labels.txt", , col.names = c("id", "activity"))
#mm <- data.frame(col.name=measure[2])

xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("activity"))
subjecttrain <- read.table("./UCIHARDataset/train/subject_train.txt", col.names = c("subject"))
##Create Column Names and Rename
featurelist <- feature[[2]]
fl <- gsub("\\(\\)|\\(|\\)|-|,","",featurelist)
colnames(xtrain) <- as.array(fl)

##Bind Columns
train <- cbind(ytrain,subjecttrain,xtrain)


xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("activity"))
subjecttest <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"))
colnames(xtest) <- as.array(fl)
test <- cbind(ytest,subjecttest,xtest)

traintest <- rbind(train,test)


#fl <- gsub("-","",featurelist)
fl <- gsub("\\(\\)|\\(|\\)|-","",featurelist)
#colnames(traintest) <- as.array(fl)
ttdata <- traintest[,grep("subject|activity|mean|std", colnames(traintest))]
#ttdata1 <- ttdata[,!grep("meanFreq", colnames(ttdata))]
##Add Activity Name
ttdata$activityname <- activitylabels[ttdata[,1],]$activity

tidydata <- ttdata %>%
    group_by(activityname,subject) %>%
    select(activity:subject, everything()) %>%
    summarise_each(funs(mean))
 
