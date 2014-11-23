# File downloaded as gcdata2.zip
# Unzipped in wd to get ~gcunz/UCI HAR Dataset/test.....
# and                   ~gcunz/UCI HAR Dataset/train.....

#also     ~gcunz/UCI HAR Dataset/activity_labels
#         ~gcunz/UCI HAR Dataset/features
#         ~gcunz/UCI HAR Dataset/features_info
#         ~gcunz/UCI HAR Dataset/README

# test
#         ~gcunz/UCI HAR Dataset/test/subject_test  # subject id (1 column)
#         ~gcunz/UCI HAR Dataset/test/y_test        # activity codes (1 column)
#         ~gcunz/UCI HAR Dataset/test/X_test        # features (multicolumn)

# train
#         ~gcunz/UCI HAR Dataset/train/subject_train
#         ~gcunz/UCI HAR Dataset/train/y_train
#         ~gcunz/UCI HAR Dataset/train/X_train

# also includes test and train directories of Inertial Signals
# still not sure how these are related (raw data of some kind), so not incluuded

testsubjects <- read.table("gcunz/UCI HAR Dataset/test/subject_test.txt")
testX <- read.table("gcunz/UCI HAR Dataset/test/X_test.txt")
testY <- read.table("gcunz/UCI HAR Dataset/test/Y_test.txt")

# str(testsubjects)
# 'data.frame':    2947 obs. of  1 variable:
# $ V1: int  2 2 2 2 2 2 2 2 2 2 ...
# NOTE: testX also has a variable called V1
#             'data.frame':    2947 obs. of  561 variables
#       testY  ditto
#             'data.frame':    2947 obs. of  1 variable:

# create test as a copy of testX, then add subject and Y as new columns 
test <- testX
test$subject <- testsubjects[,1]
test$actcode <- testY[,1]
# names(test)

trainsubjects <- read.table("gcunz/UCI HAR Dataset/train/subject_train.txt")
trainX <- read.table("gcunz/UCI HAR Dataset/train/X_train.txt")
trainY <- read.table("gcunz/UCI HAR Dataset/train/Y_train.txt")

# check that the ids are unique (that is, nobody is in both test and train)
# trainsubjects %in% testsubjects
# [1] FALSE

# create train as a copy of trainX, then add subject and Y as new columns 
train <- trainX
train$subject <- trainsubjects[,1]
train$actcode <- trainY[,1]
# names(train)

# combine test and train data, by row
testtrain <- data.frame(rbind(test, train))

# str(testtrain)
# 'data.frame':    10299 obs. of  563 variables

activitylabels <- read.table("gcunz/UCI HAR Dataset/activity_labels.txt")
# activitylabels

# change labels to lower case, and get rid of _ symbols
activitylabels$V2 <- tolower(activitylabels$V2)
activitylabels$V2 <- gsub(pattern = "_", replacement = "", x = activitylabels$V2)

# rename the columns in activitylabels, as V1 and V2 exist in testtrain already
library(data.table)
setnames(activitylabels, c("V1", "V2"), c("actcode", "activity"))

# merge the activitylabels columns into testtrain
# note that actcode will still be present - consider deleting it later
testtrain <- merge(y = testtrain, x = activitylabels, by = "actcode")
# names(testtrain)

features <- read.table("gcunz/UCI HAR Dataset/features.txt")
# change all of features$V2 strings to lower case, and get rid of _ symbols
features$V2 <- tolower(features$V2)
features$V2 <- gsub(pattern = "_", replacement = "", x = features$V2)
features$V2 <- gsub(pattern = "-", replacement = "", x = features$V2)

# testtrain has actcode in col 1, activity in col 2, V1-V561 in cols 3-563
# and subject in col 564
# use the names in features to rename the columns in testtrain
setnames(testtrain, 3:563, as.character(features$V2))
# names(testtrain)

meancolindices <- grep(pattern = "mean", x = names(testtrain) )
stdcolindices <- grep(pattern = "std", x = names(testtrain))
colsrequired <- c("1", "2", "564", meancolindices, stdcolindices)
colsrequired <- as.integer(colsrequired)

extract <- testtrain[,colsrequired]

tidymeans <- aggregate( . ~ subject + activity, extract, mean)
write.table(tidymeans, file = "tidymeans.txt", row.name=FALSE)

         