## JH Stats Getting and Cleaning Data, Course Project 1:  Tidy dataset from
## UCI Human Activity Recognition Using Smartphones Dataset
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## Merges the training, subject, and test sets to create one data set.
## Extracts only the mean and standard deviation for each measurement. 
## Uses descriptive activity names to name the activities in the data set
## Appropriately labels the data set with descriptive variable names. 
## Creates a second, independent tidy data set 
## with the average of each variable for each activity, subject, and metric
## Export results as file "project1.txt"

## FUNCTIONS START********************************************************
## 1a.  Build features and activity master files:
##      Build features master file from "features.txt"
##      Assign featureID
##      Identify mean and std deviation in column metric
##      Assign common names
buildFeatures<-function() {
  features<-read.table("features.txt", header = FALSE, sep = "\t", col.names = "titleLong")
  features$featureID<- as.factor(1:nrow(features))
  features$metric = ""
  features$metric[grep("std", features$titleLong)]<-"StandardDeviation"
  features$metric[grep("mean()", features$titleLong)]<-"Mean"
  ## take out meanFreq and angle means
  features$metric[grep("meanFreq", features$titleLong)]<-""
  features$metric[grep("angle", features$titleLong)]<-""
  
  ## Build common name titles
  features$titleTrim<-features$titleLong
  for (i in 1:3) {
    features$titleTrim<-sub("^[0-9]", "", features$titleTrim)
  }
  features$titleTrim<-sub(" ", "", features$titleTrim)
  features$tidyTitle<-""
  vecFind<- c("^t", "^f", "Acc", "Gyro", "Body", "Gravity", "Jerk", "Mag", "[Xx]", "[Yy]", "[Zz]")
  vecRecord<-c("TimeDomainSignal", "FastFourierTransform", "Accelerometer", "Gyroscope", "Body", "Gravity", "Jerk", "Magnitude", "XCoordinate", "YCoordinate", "ZCoordinate")
  for (i in 1:length(vecFind)) {
    features$tidyTitle[grep(vecFind[i], features$titleTrim)]<-paste0(features$tidyTitle[grep(vecFind[i], features$titleTrim)], vecRecord[i])
  }
  features$tidyTitle<-paste0(features$tidyTitle, features$metric)
  return(features)
}

## 1. Build data detail file:
##    cbind metric, subject, and activityID datasets
##    rbind test and train datasets
##    select mean and std columns
##    add tidy names (from featuresMas)

mergeFiles<-function(featureMas) {
  x_test<-read.table("x_test.txt", header = FALSE)
  x_test<-cbind(x_test, read.table("subject_test.txt", header = FALSE))
  x_test<-cbind(x_test, read.table("y_test.txt", header = FALSE))

  activity<-read.table("x_train.txt", header = FALSE)
  activity<-cbind(activity, read.table("subject_train.txt", header = F))
  activity<-cbind(activity, read.table("y_train.txt", header = F))

  activity<-rbind(activity, x_test)
  ##activity$recordNum<-1:nrow(activity)  
  
  featureID<-1:561
  vecTidy<-featureMas$tidyTitle
  vecDelete<-featureMas$featureID[featureMas$metric == ""]
  names(activity)<-c(vecTidy, "subject", "activityID")
  activity<-activity[-as.numeric(vecDelete)]
  ##activity$subject<-paste0("subject", activity$subject)
  ##activity<-activity[-68]
  return(activity)
}

## 2. Add Activity key field from activeMas (activity.txt)
addKeyField<-function(activity) {
  activeMas<-read.table("activity_labels.txt", header = FALSE)
  names(activeMas)<-c("activityID", "activity")
  dflist<-list(activity, activeMas)
  activeDataKey<-join_all(dflist)
  activeDataKey<-activeDataKey[c(67, 69, 1:66, 68)]
  return(activeDataKey)
}

## 3. Create tidy dataset with averages by activity/subject; 
activeTidy<-function(active) {
  activeLong<-melt(active, c("subject", "activity", "activityID"), 3:68)
  activeSum<-ddply(activeLong, .(subject, activity, activityID, variable), summarize, metricMean = mean(value))
  activeSum<-arrange(activeSum, subject, activityID, variable)
  activeSum<-activeSum[-3]
  activeSum<-rename(activeSum, feature=variable, featureMean=metricMean)
  return(activeSum) 
}
## FUNCTIONS END***********************************************


## MAIN program START ******************************************
##install.packages("reshape2")
##install.packages("plyr")
library(reshape2)
library(dplyr)
                                      ## Function Calls:
featureMas<-buildFeatures()           ## 1a. build masters
activeData<-mergeFiles(featureMas)    ## 1. build datafile
activeDataKey<-addKeyField(activeData)  ## 2.  add activity key field
activeSum<-activeTidy(activeDataKey)   ## 3.  create tidy dataset
write.table(activeSum, "project1.txt", row.names = FALSE)  
                                   ##     write program1.txt output file
##MAIN program END ********************************************

