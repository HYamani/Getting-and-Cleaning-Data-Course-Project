> setwd("~/Desktop/rhyam")


# load required packages
> library(data.table)
> library(dplyr)


> if (!file.exists("./data/UciHarDataset")) {
        dir.create("./data/UciHarDataset")
}

> fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
> download.file(fileUrl, destfile = ".data/UciHarDataset/Dataset.zip", method = "curl")
> list.files("./data")

> dateDownloaded <- date()
> dateDownloaded


# Read Activities files:

> ActivityTest <- read.table("./data/UciHarDataset/test/y_test.txt", header = FALSE)
> ActivityTrain <- read.table("./data/UciHarDataset/train/y_train.txt", header = FALSE)

# Read Subject Files:
        
> SubjectTest <- read.table("./data/UciHarDataset/test/subject_test.txt", header = FALSE)
> SubjectTrain <- read.table("./data/UciHarDataset/train/subject_train.txt", header = FALSE)

# Read Features files:

> FeaturesTest <- read.table("./data/UciHarDataset/test/x_test.txt", header = FALSE)
> FeaturesTrain <- read.table("./data/UciHarDataset/train/x_train.txt", header = FALSE)


# Merge data
> ActivityData <- rbind(ActivityTest, ActivityTrain)
> SubjectData <- rbind(SubjectTest, SubjectTrain)
> FeaturesData <- rbind(FeaturesTest, FeaturesTrain)

# naming columns

> colnames(ActivityData) <- "Activity"
> colnames(SubjectData) <- "Subject"

#Naming the columns
> FeaturesNames <- read.table("./data/UciHarDataset/features.txt", header = FALSE)
> colnames(features) <- t(featuresNames[2])

# Merge The Data
> DataComplete <- cbind(FeaturesData,ActivityData,SubjectData)


#Extracts only the measurements on the mean and standard deviation for each measurement

> columnsWithMeanSTD <- grep(".*Mean.*|.*Std.*", names(DataComplete), ignore.case=TRUE)

> AddedColumns <- c(columnsWithMeanSTD, 562, 563)

> FinalData <- DataComplete[,AddedColumns]

# Uses descriptive activity names to name the activities in the data set to name activitiesin the Data set

> ActivityNames <- read.table("./data/UciHarDataset/activity_labels.txt")
FinalData$Activity <- as.character(FinalData$Activity)
for (i in 1:6){
        FinalData$Activity[FinalData$Activity == i] <- as.character(ActivityNames[i,2])
}

# Part 4 - Appropriately labels the data set with descriptive variable names

> FinalData$Activity <- as.factor(FinalData$Activity)

# Replace accronymes

> names(FinalData)<-gsub("Acc", "Accelerometer", names(FinalData))
> names(FinalData)<-gsub("Gyro", "Gyroscope", names(FinalData))
> names(FinalData)<-gsub("BodyBody", "Body", names(FinalData))
> names(FinalData)<-gsub("Mag", "Magnitude", names(FinalData))
> names(FinalData)<-gsub("^t", "Time", names(FinalData))
> names(FinalData)<-gsub("^f", "Frequency", names(FinalData))
> names(FinalData)<-gsub("tBody", "TimeBody", names(FinalData))
> names(FinalData)<-gsub("-mean()", "Mean", names(FinalData), ignore.case = TRUE)
> names(FinalData)<-gsub("-std()", "STD", names(FinalData), ignore.case = TRUE)
> names(FinalData)<-gsub("-freq()", "Frequency", names(FinalData), ignore.case = TRUE)
> names(FinalData)<-gsub("angle", "Angle", names(FinalData))
> names(FinalData)<-gsub("gravity", "Gravity", names(FinalData))

# Part 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

> FinalData$Subject <- as.factor(FinalData$Subject)
