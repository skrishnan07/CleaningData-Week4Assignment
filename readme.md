========================================================
###Human Activity Recognition Using Smartphones Dataset


###Cleaning Data Project
###Getting and Cleaning Data
###Final Assignment
==================================================================

The following files are includes in this Github Repository

###X_tidy.txt  Contains the tidy version of the combined test and training date from the original study
        
Following changes were made:
* Combined the training and test data for a total of ~10200 samples
* Retained only the mean and standard deviation values estimated for each of the inertial signals in time and frequency        domains
* Replace activity codes with English words for the activities
* Removed parentheses and blanks from signal names and prefixed them with either Mean- or Std- to indicate the type of measurement



###X_summary.txt  Contains the aggregated version of the tidy data, aggregated by subject and type of activity.
Contains 40 combinations of subject and activity. 



####run_analysis.R

Contains the R script that contains the main runAnalysis function and several other supporting function.  When the script runs
it produces the two data files under the “tidy” directory. It is expected to run at the same level as the original root folder for the project.

Detailed instructions of how to run the script is captured in the Script-Explanation.html notebook compiled from R-Studio



###Script-Explanation.html      

Contains a HTML notebook combined from comments placed in the code. The documentation for each function explains the purpose of the function. Several key steps are also further documented


###Code Book.pdf

Contains the code book for the data set.  Most of the description was culled from the contents in the original read.me file and pieced together from the features_info.txt file that accompanied the distribution








####Script Explanation

####  This function performs the tasks of cleaning up data sets chosen
####  for the Getting and Cleaning Data course final asignment from
####  the UCI Human Activity Recognition Using Smartphones project
        
####  The directory containing the original "README.txt" provided
####  by the project data scientists is refered in the rest of this
####  R script and associated document as the "root" directory
        
####  This script is assumed to reside at the same level and
####  reads the input data from sub-directories under there
####  the resulting, merged, tidy dataset is then written out
#### into a sub-folder called "tidy".  
        
#### the tidy folder will have the following files
#### X_tidy.txt   Contains the merged data set from part 4 of the assignment
#### X_summary.txt  Contains the summary data set from part 5 of the assignment
        
#### Initialize all filenames and useful variable names using symbolic constants
#### Easy to edit it all in one place in case one makes mistkes
        
#### File name and column names for internal activity_labels table

#### File name and column names for internal activity_labels table
ACTIVITY_LABEL_FILE <- "activity_labels.txt"
ACTIVITY_CODE_COLUMN <- "ActivityCode"
ACTIVITY_LABEL_COLUMN <- "Activity"

#### File name and column names for internal included_features table
FEATURES_FILE <- "features.txt"
FEATURES_DATA_COLUMN_COL <- "DataColumn"
FEATURES_NAME_COL <- "Feature"


#### File name and column names for trainig and test files
SUBJECT_TEST_FILE <- "test/subject_test.txt"
SUBJECT_TRAIN_FILE <- "train/subject_train.txt"
SUBJECT_COL <- "Subject"

SUBJECT_TEST_FILE <- "test/subject_test.txt"
SUBJECT_TRAIN_FILE <- "train/subject_train.txt"
SUBJECT_COL <- "Subject"

#### Y Column (Activity) file names. 
Y_TEST_FILE  <- "test/y_test.txt"
Y_TRAIN_FILE  <- "train/y_train.txt"
Y_COL_NAME  <- "Activity"


X_TEST_FILE  <- "test/X_test.txt"
X_TRAIN_FILE  <- "train/X_train.txt"

#### directory name for the output files
TIDY_DIR <- "tidy"

#### File Name for the output file for holding the tidy data
X_TIDY_FILE <- file.path(TIDY_DIR, "X_tidy.txt", fsep = .Platform$file.sep)

#### File Name for the output file for holding the tidy data
X_SUMMARY_FILE <- file.path(TIDY_DIR, "X_summary.txt", fsep = .Platform$file.sep)


#### Begining of the main Analysis Procedure


#### Call the function to do any initial work if needed
initWorkEnvironment()

#### Read in the names of the Activity Labels and create a simple look-up table
activity_labels = readActivityNames(ACTIVITY_LABEL_FILE, ACTIVITY_CODE_COLUMN,  ACTIVITY_LABEL_COLUMN)

#### Read in the features table and filter out all but the mean() and std() features
#### This function also renames the features in a user friendly manner
#### See detailed comments for the extractFeaturesList function. 

included_features = extractFeaturesList(FEATURES_FILE, FEATURES_DATA_COLUMN_COL, FEATURES_NAME_COL)


#### So far we have processed common tables
#### now we need to process the training and test data sets separately
#### The processing code is exactly identical except for filenames and locations

#### Pass in values corresponding the training data
train_data  <- extractDataHAR(SUBJECT_TRAIN_FILE, SUBJECT_COL, Y_TRAIN_FILE, Y_COL_NAME, X_TRAIN_FILE, activity_labels, included_features)

#### Pass in values corresponding the test data
test_data  <- extractDataHAR(SUBJECT_TEST_FILE, SUBJECT_COL, Y_TEST_FILE, Y_COL_NAME, X_TEST_FILE, activity_labels, included_features)

tidy_data <- rbind(train_data, test_data)


#### Save the file to to the output folder
saveTidyData(TIDY_DIR, X_TIDY_FILE, tidy_data)

print("Finished running analysis.")
print("You may load the tidy data using the following command : ")
print("read.table(filename, header = TRUE)")
print("where filename = tidy/X_tidy.txt")


#### Now work on the summary data
summary_data = summarizeDataHAR(tidy_data)

#### Now work on the summary data
saveSummaryData(TIDY_DIR, X_SUMMARY_FILE, summary_data)

#### Functions

#### Perform any initialization steps as necessary
initWorkEnvironment <- function()


#### Function extractFeaturesList  - extracts the Feature Set
#### Read in the features table and filter out all but the mean() and std() features
#### Note:  only the features that have either one of the following patterns in the name are selected
####    -mean()   OR  -std()  
#### In particular other fetures such as "meanFreq()"  and the various averaged features such as 
#### gravityMean(), etc. are also omitted since all these omitted measurements are seperate emitities
#### altogether, not tied to the mean() and std() features, which are selected

#### This function also changes rhe feature names to be ore user friendly 
extractFeaturesList <- function(filename, col_name_data_col, col_name_feature_name)

 #### reads the activity names from the "activity_labels.txt" file

#### At this time also remame the fetaure mame as follows
#### Remove the () from the feature name and also capitalize and move the mean and std to the front
#### example "tBodyAcc-mean()-X" becomes "Mean-tBodyAcc-X" and tBodyAcc-std()-X" becomes "Std-tBodyAcc-X"
#### Process the entries for the Standard Deviation using the same technique



#### Function extractDataHAR - accepts the location of the subject, and X and Y data files
####  It also receives the included-features list constructed earlier
####  The column positions of the features table are used to pick the columns to include from the raw X data
####  The names of the features contained in the second column of the included-features table is used to
####  rename the columns of the X data

#### finally the subject and activity data are combined in the same table 

extractDataHAR  <- function(subject_file, subject_col, y_file, y_col, x_file, act_labels, incl_features)



#### Saves the summary in the output folder
#### Creates the "tidy" folder if not already present
saveSummaryData <- function(dirname, filename, summ_data)
