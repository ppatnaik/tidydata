library(dplyr)
library(tidyr)

#Check if data has be extracted
if(!file.exists("UCI HAR Dataset/"))
    #Unzip datafile
    if(file.exists("getdata_projectfiles_UCI HAR Dataset.zip"))
        unzip("getdata_projectfiles_UCI HAR Dataset.zip")

#load column labels
ftrActivity <- read.table("UCI HAR Dataset/activity_labels.txt")
ftrColNames <- read.table("UCI HAR Dataset/features.txt")

#load test data
ftrTestData <- read.table("UCI HAR Dataset/test/X_test.txt", col.names=ftrColNames$V2)
ftrTestLabels <- read.table("UCI HAR Dataset/test/y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt") %>%
    rename(Subject=V1)


#load train data
ftrTrainData <- read.table("UCI HAR Dataset/train/X_train.txt", col.names=ftrColNames$V2)
ftrTrainLabels <- read.table("UCI HAR Dataset/train/y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt") %>%
    rename(Subject=V1)

# load data as tbl_df
testdata <- tbl_df(ftrTestData) %>% 
    select(contains("mean"), contains("std")) %>%
    cbind(ftrTestLabels ) %>%
    cbind(testSubjects ) 
    
traindata <- tbl_df(ftrTrainData) %>% 
    select(contains("mean"), contains("std")) %>%
    cbind(ftrTrainLabels) %>%
    cbind(trainSubjects) 
#    mutate(Source="train")

mdata <- merge(testdata, traindata, all = TRUE) %>% 
    left_join(ftrActivity) %>%
    rename(Activity=V2) %>%
    select(-(V1)) 


names(mdata) <-gsub("tB", "TimeB", names(mdata))
names(mdata) <-gsub(".mean...", "Mean.", names(mdata))
names(mdata) <-gsub("tG", "TimeG", names(mdata))
names(mdata) <-gsub(".mean..", "Mean", names(mdata))
names(mdata) <-gsub("fB", "FreqB", names(mdata))
names(mdata) <-gsub("n.q...", "nQ.", names(mdata))
names(mdata) <-gsub(".std...", "Std.", names(mdata))
names(mdata) <-gsub(".std..", "Std", names(mdata))
names(mdata) <-gsub("n.q..", "nQ", names(mdata))
names(mdata) <-gsub(".X.gravityMean.", "GravityMean.X", names(mdata))
names(mdata) <-gsub(".Y.gravityMean.", "GravityMean.Y", names(mdata))
names(mdata) <-gsub(".Z.gravityMean.", "GravityMean.Z", names(mdata))
names(mdata) <-gsub("n.gravityMean.", "nGravityMean", names(mdata))
names(mdata) <-gsub("Mean.gravity.", "MeanGravity", names(mdata))
names(mdata) <-gsub("Mean..gravityMean.", "MeanGravityMean", names(mdata))
names(mdata) <-gsub("angle.T", "AngleT", names(mdata))
names(mdata) <-gsub("angleGravity", "AngleGravity", names(mdata))

# Group data by subject and activity
mygrp <- group_by(mdata, Subject, Activity) %>% summarise_each(funs(mean))
write.table(mygrp, file = "SummaryData.txt", row.names = FALSE)

#cleanup
rm(mygrp)
rm(mdata)
rm(testdata)
rm(traindata)
rm(ftrTestData)
rm(ftrTestLabels)
rm(ftrTrainData)
rm(ftrTrainLabels)
rm(trainSubjects)
rm(testSubjects)
rm(ftrActivity)
rm(ftrColNames)


