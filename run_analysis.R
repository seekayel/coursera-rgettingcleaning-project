# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject.


# 1 WALKING
# 2 WALKING_UPSTAIRS
# 3 WALKING_DOWNSTAIRS
# 4 SITTING
# 5 STANDING
# 6 LAYING

library("dplyr")
library("data.table")

cols<-c(1,2,3,4,5,6,41,42,43,44,45,46,81,82,83,84,85,86,121,122,123,124,125,126,161,162,163,164,165,166,201,202,214,215,227,228,240,241,253,254,266,267,268,269,270,271,345,346,347,348,349,350,424,425,426,427,428,429,503,504,516,517,529,530,542,543,555,556,557,558,559,560,561)

col_names<-c("person",
             "activity",
             "tBodyAcc-mean()-X",
             "tBodyAcc-mean()-Y",
             "tBodyAcc-mean()-Z",
             "tBodyAcc-std()-X",
             "tBodyAcc-std()-Y",
             "tBodyAcc-std()-Z",
             "tGravityAcc-mean()-X",
             "tGravityAcc-mean()-Y",
             "tGravityAcc-mean()-Z",
             "tGravityAcc-std()-X",
             "tGravityAcc-std()-Y",
             "tGravityAcc-std()-Z",
             "tBodyAccJerk-mean()-X",
             "tBodyAccJerk-mean()-Y",
             "tBodyAccJerk-mean()-Z",
             "tBodyAccJerk-std()-X",
             "tBodyAccJerk-std()-Y",
             "tBodyAccJerk-std()-Z",
             "tBodyGyro-mean()-X",
             "tBodyGyro-mean()-Y",
             "tBodyGyro-mean()-Z",
             "tBodyGyro-std()-X",
             "tBodyGyro-std()-Y",
             "tBodyGyro-std()-Z",
             "tBodyGyroJerk-mean()-X",
             "tBodyGyroJerk-mean()-Y",
             "tBodyGyroJerk-mean()-Z",
             "tBodyGyroJerk-std()-X",
             "tBodyGyroJerk-std()-Y",
             "tBodyGyroJerk-std()-Z",
             "tBodyAccMag-mean()",
             "tBodyAccMag-std()",
             "tGravityAccMag-mean()",
             "tGravityAccMag-std()",
             "tBodyAccJerkMag-mean()",
             "tBodyAccJerkMag-std()",
             "tBodyGyroMag-mean()",
             "tBodyGyroMag-std()",
             "tBodyGyroJerkMag-mean()",
             "tBodyGyroJerkMag-std()",
             "fBodyAcc-mean()-X",
             "fBodyAcc-mean()-Y",
             "fBodyAcc-mean()-Z",
             "fBodyAcc-std()-X",
             "fBodyAcc-std()-Y",
             "fBodyAcc-std()-Z",
             "fBodyAccJerk-mean()-X",
             "fBodyAccJerk-mean()-Y",
             "fBodyAccJerk-mean()-Z",
             "fBodyAccJerk-std()-X",
             "fBodyAccJerk-std()-Y",
             "fBodyAccJerk-std()-Z",
             "fBodyGyro-mean()-X",
             "fBodyGyro-mean()-Y",
             "fBodyGyro-mean()-Z",
             "fBodyGyro-std()-X",
             "fBodyGyro-std()-Y",
             "fBodyGyro-std()-Z",
             "fBodyAccMag-mean()",
             "fBodyAccMag-std()",
             "fBodyBodyAccJerkMag-mean()",
             "fBodyBodyAccJerkMag-std()",
             "fBodyBodyGyroMag-mean()",
             "fBodyBodyGyroMag-std()",
             "fBodyBodyGyroJerkMag-mean()",
             "fBodyBodyGyroJerkMag-std()",
             "angle(tBodyAccMean,gravity)",
             "angle(tBodyAccJerkMean),gravityMean)",
             "angle(tBodyGyroMean,gravityMean)",
             "angle(tBodyGyroJerkMean,gravityMean)",
             "angle(X,gravityMean)",
             "angle(Y,gravityMean)",
             "angle(Z,gravityMean)")

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileURL, "./dataset.zip", method="curl")
unzip("./dataset.zip", exdir=".")


# Pull in train data
train_activity<-fread('./UCI HAR Dataset/train/y_train.txt', header=FALSE)
train_activity<-data.table(factor(train_activity$V1, levels=1:6, labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")))

train_person<-fread('./UCI HAR Dataset/train/subject_train.txt', header=FALSE)

train_set<-cbind(train_person, train_activity, fread('./UCI HAR Dataset/train/X_train.txt', select=cols, header=FALSE))
names(train_set) <- col_names

# Pull in the test data
test_activity<-fread('./UCI HAR Dataset/test/y_test.txt', header=FALSE)
test_activity<-data.table(factor(test_activity$V1, levels=1:6, labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")))

test_person<-fread('./UCI HAR Dataset/test/subject_test.txt', header=FALSE)

test_set<-cbind(test_person, test_activity, fread('./UCI HAR Dataset/test/X_test.txt', select=cols, header=FALSE))
names(test_set) <- col_names


# Merge the test & train data
data<-rbind(train_set,test_set)

final_data <- data %>% group_by(person, activity) %>% summarise_each(funs(mean))

write.table(final_data, file='./analysis_output.txt', row.name=FALSE)

