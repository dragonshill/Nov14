Codebook for Nov 2014 GCD project.

See GitHub repo Nov14 for the    run_analysis.R  code.

The original data file was downloaded as gcdata2.zip  from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
and unzipped into my working directory as
                        ~gcunz/UCI HAR Dataset/test.....
  and                   ~gcunz/UCI HAR Dataset/train.....

 also     ~gcunz/UCI HAR Dataset/activity_labels
         ~gcunz/UCI HAR Dataset/features
         ~gcunz/UCI HAR Dataset/features_info
         ~gcunz/UCI HAR Dataset/README

 test
         ~gcunz/UCI HAR Dataset/test/subject_test  # subject id (1 column)
         ~gcunz/UCI HAR Dataset/test/y_test        # activity codes (1 column)
         ~gcunz/UCI HAR Dataset/test/X_test        # features (multicolumn)

 train
         ~gcunz/UCI HAR Dataset/train/subject_train
         ~gcunz/UCI HAR Dataset/train/y_train
         ~gcunz/UCI HAR Dataset/train/X_train

It also includes test and train directories of Inertial Signals
but I'm  still not sure how these are related (raw data of some kind), so not incluuded.

I used read.table to read the test and train datasets into R.
I combined the three test files by adding them as columns,
then I used rbind to combine the test with the train data.

I read in the activity_labels as a dataframe, and used them to add meaningful names to the activities.
I read in the features as a dataframe, and used them to add names to the measurement columns.

This produced a dataframe with 10299 observations of 563 variables.

These variables included 

subject     -   the subject identifier, 1-30
activity    -   the name of the activity being undertaken : 
                Walking, Walking upstairs, walking downstairs, sitting, standing, laying
actcode     -   the code number of the activity

and 560 different measurement variables.

I tidied up the text of the labels by converting to lower case and deleting _ characters.

I then searched for mean and std in the measurement columns, and extracted those columns plus subject and activity into a new dataframe called extract.


To find the means of each mean and std column by subject and activity, I used the aggregate function from the stats package.
This created a new dataframe, tidymeans, with 180 rows (subjects * activities) and 89 columns.

