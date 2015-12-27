

library(data.table)
library(reshape2)

# read the files 

# Set path and read file
subjectTrainDataFile <- file.path("UCI HAR Dataset", "train", 
                                  "subject_train.txt")
subjectTestDataFile <- file.path("UCI HAR Dataset", "test", 
                                 "subject_test.txt")
subjectTrain <- fread(trainDataFile)
subjectTest  <- fread(testDataFile)

activityTrainDataFile <- file.path("UCI HAR Dataset", "train", "Y_train.txt")
activityTestDataFile <- file.path("UCI HAR Dataset", "test", "Y_test.txt")
activityTrain <- fread(activityTrainDataFile)
activityTest <- fread(activityTestDataFile)

trainDataFile <- file.path("UCI HAR Dataset", "train", "X_train.txt")
testDataFile <- file.path("UCI HAR Dataset", "test", "X_test.txt")
trainData <- read.table(trainDataFile)
trainDataTable <- data.table(trainData)
testData <- read.table(testDataFile)
testDataTable <- data.table(testData)


# 1. Merges the training and the test sets to create one data set.

# Join the train and test datasets

subjectData <- rbind(subjectTrain, subjectTest)
setnames(subjectData, "V1", "Subject")

activityData <- rbind(activityTrain, activityTest)
setnames(activityData, "V1", "ActivityNr")

fullData <- rbind(trainDataTable, testDataTable)

# Add activity and measurements to subjects

subjectAndActivity <- cbind(subjectData, activityData)
fullSubjectAndActivity <- cbind(subjectAndActivity, fullData)

# check
names(fullSubjectAndActivity)

# set unique key on the table that is subject and the activity
setkey(fullSubjectAndActivity, Subject, ActivityNr)

# 2. Extracts only the measurements on the mean and standard deviation 
# for each measurement.

# The features.txt file describes the variables that represent the measurements
# for the mean and standard deviation

featureFile <- file.path("UCI HAR Dataset", "features.txt")
featuresData <- fread(featureFile)
# give meaningful names to the feature columns
setnames(featuresData, names(featuresData), c("FeatureNr", "FeatureName"))

# get only the measurements for the mean and the standard deviation as 
# mentioned in featureName

meanAndStdSearch <- "mean\\(\\)|std\\(\\)"
featuresData <- featuresData[grepl(meanAndStdSearch, FeatureName)]
featuresData

# We need to match the measurements in featuresData to the columns in 
# fullSubjectAndActivity, so we need to have the labels starting with V
# in a need variable FeatureCode

featuresData$FeatureCode <- featuresData[, paste0("V", FeatureNr)]
# head(featuresData)

# Get only these feature codes from fullSubjectAndActivity

filterOnFeatureCode <- c(key(fullSubjectAndActivity), featuresData$FeatureCode)
fullSubjectAndActivity <- fullSubjectAndActivity[,filterOnFeatureCode, 
                                                 with=FALSE] 


# 3. Uses descriptive activity names to name the activities in the data set

# File activity_labels.txt has descriptive activity names
activityNamesFile <- file.path("UCI HAR Dataset", "activity_labels.txt")
activityNamesData <- fread(activityNamesFile)

# Rename columns in activity names dataset
setnames(activityNamesData, names(activityNamesData), 
         c("ActivityNr", "ActivityName"))


# 4. Appropriately labels the data set with descriptive variable names.

# Now use these descriptive names in the main dataset with the subjects
fullSubjectAndActivity <- merge(fullSubjectAndActivity, activityNamesData,
                                by = "ActivityNr", all.x = TRUE)
names(fullSubjectAndActivity)

# Now activity name should be aaded to the key
setkey(fullSubjectAndActivity, Subject, ActivityNr, ActivityName)

# The data table needs to be melted 
fullSubjectAndActivity <- data.table(melt(fullSubjectAndActivity,
                                          key(fullSubjectAndActivity),
                                          variable.name = "FeatureCode"))

# Activity should also be merged to the main data set

fullSubjectAndActivity <- merge(fullSubjectAndActivity,
                                featuresData[, list(FeatureNr,
                                                    FeatureCode,
                                                    FeatureName)],
                                by = "FeatureCode",
                                all.x = TRUE)

# We will now make two factor variables out of the existing variables
# for feature and activity names

fullSubjectAndActivity$ActivityClass <- 
    factor(fullSubjectAndActivity$ActivityName)
fullSubjectAndActivity$FeatureClass <- 
    factor(fullSubjectAndActivity$FeatureName)

# The variable Feature Name is actually composed of different features.
# We will now separate them by using grepl.

# We start with feature names that have with 2 features inside

grepFeatureInFullData <- function (regexpression) {
    grepl(regexpression, fullSubjectAndActivity$FeatureClass)
}

n <- 2 # number of features inside
featureMatrix <- matrix(seq(1,n), nrow = n)

# feature domain
regexpMatrix <- matrix(c(grepFeatureInFullData("^t"), 
                         grepFeatureInFullData("^f")), 
                       ncol=nrow(featureMatrix))
fullSubjectAndActivity$FeatureDomain <- factor(regexpMatrix %*% featureMatrix, 
                                               labels=c("Time", "Freq"))

# feature Instrument
regexpMatrix <- matrix(c(grepFeatureInFullData("Acc"), 
                         grepFeatureInFullData("Gyro")), 
                       ncol=nrow(featureMatrix))
fullSubjectAndActivity$FeatureInstrument <- 
    factor(regexpMatrix %*% featureMatrix, 
            labels=c("Accelerometer", "Gyroscope"))
    

# feature acceleration
regexpMatrix <- matrix(c(grepFeatureInFullData("BodyAcc"), 
                         grepFeatureInFullData("GravityAcc")), 
                       ncol=nrow(featureMatrix))
fullSubjectAndActivity$FeatureAcceleration <- 
    factor(regexpMatrix %*% featureMatrix, 
            labels=c(NA, "Body", "Gravity"))

# feature Stats
regexpMatrix <- matrix(c(grepFeatureInFullData("mean()"), 
                         grepFeatureInFullData("std()")), 
                       ncol=nrow(featureMatrix))
fullSubjectAndActivity$FeatureStats <- factor(regexpMatrix %*% featureMatrix, 
                                                     labels=c("Mean", "SD"))

# features with 1 feature inside
fullSubjectAndActivity$FeatureJerk <- factor(grepFeatureInFullData("Jerk"),
                                             labels=c(NA, "Jerk"))
fullSubjectAndActivity$FeatureMagnitude <- factor(grepFeatureInFullData("Mag"),
                                             labels=c(NA, "Magnitude"))

# Finally features with 3 features inside
n <- 3 # number of features inside
featureMatrix <- matrix(seq(1,n), nrow = n)
regexpMatrix <- matrix(c(grepFeatureInFullData("-X"), 
                         grepFeatureInFullData("-Y"), 
                         grepFeatureInFullData("-Z")), 
                       ncol=nrow(featureMatrix))
fullSubjectAndActivity$FeatureAxis <- factor(regexpMatrix %*% featureMatrix, 
                                             labels=c(NA, "X", "Y", "Z"))
    
# Check if the Feature Class covers all 

nr_rowsInFeatureClass <- nrow(fullSubjectAndActivity[, .N, 
                                                     by=c("FeatureClass")])
nr_rowsInNewFeatureNames <- nrow(fullSubjectAndActivity[, .N, 
                                                     by=c("FeatureDomain", 
                                                          "FeatureAcceleration", 
                                                          "FeatureInstrument",
                                                          "FeatureStats",
                                                          "FeatureJerk", 
                                                          "FeatureMagnitude",
                                                          "FeatureAxis")])
# Same number of rows?
nr_rowsInFeatureClass == nr_rowsInNewFeatureNames
# TRUE
# FeatureClass can now be removed as its subclasses replace it

# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject

setkey(fullSubjectAndActivity, Subject, ActivityClass, FeatureDomain,
       FeatureAcceleration, FeatureInstrument, FeatureJerk, FeatureMagnitude,
       FeatureStats, FeatureAxis)

TidySubjectAndActivity <- fullSubjectAndActivity[, list(count = .N, 
                                                        average = mean(value)),
                                                 by=key(fullSubjectAndActivity)]

# generate the text file with the tidy dataset
datasetFilename <- "ActivityTrackingUsingSmartphones.txt"
write.table(TidySubjectAndActivity, datasetFilename, 
            quote=FALSE, sep="\t", row.names=FALSE)





