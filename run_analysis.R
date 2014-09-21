## Data Clean course - Assignment

### Zip file was downloaded and unzipped into working directory
## read necessary text files in data frames

## features provides variable names for test and train data sets
features <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")

## read in test data, and set colnames to features
test <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt")
names(test)<- features$V2

## read in Subject and Labels(which is the activity code) and bind to test data set
testLabels <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/Y_test.txt",
                         col.names = "Label")
testSubject <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt",
                          col.names= "Subject")

testSet<- cbind(testSubject$Subject, testLabels$Label, test)
names(testSet)[1:2] <- c("Subject", "Label")


## read in train data and set colnames to features
train <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
names(train) <- features$V2

## read in subject and activity Label and bind to train data
trainLabels <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/Y_train.txt",
                          col.names = "Label")
trainSubject <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt",
                           col.names = "Subject")

trainSet <- cbind(testSubject$Subject, testLabels$Label, test)
names(trainSet)[1:2] <- c("Subject", "Label")

## combine test and train data into one data frame

fullSet <- rbind(testSet, trainSet)

## from full set select only variable that report mean or std 

selectMean <- grep("-mean()", names(fullSet), fixed = TRUE)
selectStd <- grep("-std()", names(fullSet), fixed = TRUE)
selectCol <- c("1","2", selectMean, selectStd)

fullSetReduce<-cbind(fullSet$Subject, fullSet$Label,subset(fullSet, select = selectMean), subset(fullSet, select = selectStd))
names(fullSetReduce)[1:2] <- c("Subject", "Label")

### Add activity labels

activity <- read.table("./getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt")
names(activity)[1:2] <- c("Label", "Activity")

finalSet <- merge(fullSetReduce, activity, by.x = "Label", by.y = "Label", all = TRUE)

## Calculate mean of each variable in the dataframe by Subject and Activity to produce final\
## tidy data set

library(plyr)

tidyDataSet<- ddply(finalSet, .(finalSet$Subject, finalSet$Activity), function(finalSet) colwise(mean) (finalSet[,3:68]))
names(tidyDataSet)[1,2] <- c("Subject", "Activity")

write.table (tidyDataSet, file = "./tidyDataSet.txt", row.names = FALSE)
