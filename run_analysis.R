runAnalysis <- function()
{
        ##  This function performs the tasks of cleaning up data sets chosen
        ##  for the Getting and Cleaning Data course final asignment from
        ##  the UCI Human Activity Recognition Using Smartphones project
        
        ##  The directory containing the original "README.txt" provided
        ##  by the project data scientists is refered in the rest of this
        ##  R script and associated document as the "root" directory
        
        ##  This script is assumed to reside at the same level and
        ##  reads the input data from sub-directories under there
        ##  the resulting, merged, tidy dataset is then written out
        ## into a sub-folder called "tidy".  
        
        ## the tidy folder will have the following files
        ## X_tidy.txt   Contains the merged data set from part 4 of the assignment
        ## X_summary.txt  Contains the summary data set from part 5 of the assignment
        
        ## Initialize all filenames and useful variable names using symbolic constants
        ## Easy to edit it all in one place in case one makes mistkes
        
        ## File name and column names for internal activity_labels table
        ACTIVITY_LABEL_FILE <- "activity_labels.txt"
        ACTIVITY_CODE_COLUMN <- "ActivityCode"
        ACTIVITY_LABEL_COLUMN <- "Activity"
        
        ## File name and column names for internal included_features table
        FEATURES_FILE <- "features.txt"
        FEATURES_DATA_COLUMN_COL <- "DataColumn"
        FEATURES_NAME_COL <- "Feature"
        
        
        ## File name and column names for trainig and test files
        SUBJECT_TEST_FILE <- "test/subject_test.txt"
        SUBJECT_TRAIN_FILE <- "train/subject_train.txt"
        SUBJECT_COL <- "Subject"
        
        SUBJECT_TEST_FILE <- "test/subject_test.txt"
        SUBJECT_TRAIN_FILE <- "train/subject_train.txt"
        SUBJECT_COL <- "Subject"
        
        ## Y Column (Activity) file names. 
        Y_TEST_FILE  <- "test/y_test.txt"
        Y_TRAIN_FILE  <- "train/y_train.txt"
        Y_COL_NAME  <- "Activity"
        
        
        X_TEST_FILE  <- "test/X_test.txt"
        X_TRAIN_FILE  <- "train/X_train.txt"
        
        ## directory name for the output files
        TIDY_DIR <- "tidy"
        
        ## File Name for the output file for holding the tidy data
        X_TIDY_FILE <- file.path(TIDY_DIR, "X_tidy.txt", fsep = .Platform$file.sep)
        
        ## File Name for the output file for holding the tidy data
        X_SUMMARY_FILE <- file.path(TIDY_DIR, "X_summary.txt", fsep = .Platform$file.sep)
        
        
        ## Begining of the main Analysis Procedure
        
        
        ## Call the function to do any initial work if needed
        initWorkEnvironment()
        
        ## Read in the names of the Activity Labels and create a simple look-up table
        activity_labels = readActivityNames(ACTIVITY_LABEL_FILE, ACTIVITY_CODE_COLUMN,  ACTIVITY_LABEL_COLUMN)
        
        ## Read in the features table and filter out all but the mean() and std() features
        ## This function also renames the features in a user friendly manner
        ## See detailed comments for the extractFeaturesList function. 
        
        included_features = extractFeaturesList(FEATURES_FILE, FEATURES_DATA_COLUMN_COL, FEATURES_NAME_COL)
        
        
        ## So far we have processed common tables
        ## now we need to process the training and test data sets separately
        ## The processing code is exactly identical except for filenames and locations
        
        ## Pass in values corresponding the training data
        train_data  <- extractDataHAR(SUBJECT_TRAIN_FILE, SUBJECT_COL, Y_TRAIN_FILE, Y_COL_NAME, X_TRAIN_FILE, activity_labels, included_features)
        
        ## Pass in values corresponding the test data
        test_data  <- extractDataHAR(SUBJECT_TEST_FILE, SUBJECT_COL, Y_TEST_FILE, Y_COL_NAME, X_TEST_FILE, activity_labels, included_features)
        
        tidy_data <- rbind(train_data, test_data)
        
        print("Dimensions of tidy_data:")
        print(dim(tidy_data))
        print(names(tidy_data))
        
        
        saveTidyData(TIDY_DIR, X_TIDY_FILE, tidy_data)
        
        print("Finished running analysis.")
        print("You may load the tidy data using the following command : ")
        print("read.table(filename, header = TRUE)")
        print("where filename = tidy/X_tidy.txt")
        
        
        ## Now work on the summary data
        summary_data = summarizeDataHAR(tidy_data)
        
        ## Now work on the summary data
        saveSummaryData(TIDY_DIR, X_SUMMARY_FILE, summary_data)
        
        print("Finished running analysis.")
        print("You may load the summary data using the following command : ")
        print("read.table(filename, header = TRUE)")
        print("where filename = tidy/X_summary.txt")
    
}

## Perform any initialization steps as necessary
initWorkEnvironment <- function()
{
        ## Contains code to initialize working directory, etc.,
        ## currently this is just a [;ace-holder function
        
        print.default("Working Environment Initialized")
        print.default("Current Working Directory: ")
        print.default(getwd())
        
        
}

## Reads the Activity Names from the Activity Labels file
readActivityNames <- function(filename, col_name_act_code, col_name_act_label)
{
        ## reads the activity names from the "activity_labels.txt" file
        
        act_table <- read.table(filename)
        colnames(act_table) <- c(col_name_act_code, col_name_act_label)
        return(act_table)
        
}

## Function extractFeaturesList  - extracts the Feature Set
## Read in the features table and filter out all but the mean() and std() features
## Note:  only the features that have either one of the following patterns in the name are selected
##    -mean()   OR  -std()  
## In particular other fetures such as "meanFreq()"  and the various averaged features such as 
## gravityMean(), etc. are also omitted since all these omitted measurements are seperate emitities
## altogether, not tied to the mean() and std() features, which are selected

## This function also changes rhe feature names to be ore user friendly 
extractFeaturesList <- function(filename, col_name_data_col, col_name_feature_name)
{
        ## reads the activity names from the "activity_labels.txt" file
        
        feat_table <- read.table(filename)
        colnames(feat_table) <- c(col_name_data_col, "TEMP")
        
        ## Now filter it using criteria for fetaure name
        feat_table <- feat_table[grepl("\\-(mean|std)\\(", feat_table[, 2], ignore.case = FALSE), ]
        
        ## At this time also remame the fetaure mame as follows
        ## Remove the () from the feature name and also capitalize and move the mean and std to the front
        ## example "tBodyAcc-mean()-X" becomes "Mean-tBodyAcc-X" and tBodyAcc-std()-X" becomes "Std-tBodyAcc-X"
        
        temp1 <- feat_table[grepl("mean", feat_table[,2]),]
        temp2 <- gsub("\\-mean\\(\\)", "", temp1[, 2])
        temp3 <- gsub("^", "Mean-", temp2)
        temp1[, 3] <- temp3 
        meanFeat <-  temp1[, c(1, 3)]
        colnames(meanFeat) <- c(col_name_data_col, col_name_feature_name)
        
        
        ## Process the entries for the Standard Deviation using the same technique
        temp1 <- feat_table[grepl("std", feat_table[,2]),]
        temp2 <- gsub("\\-std\\(\\)", "", temp1[, 2])
        temp3 <- gsub("^", "Std-", temp2)
        temp1[, 3] <- temp3 
        stdFeat <-  temp1[, c(1, 3)]
        colnames(stdFeat) <- c(col_name_data_col, col_name_feature_name)
        
        ## Put the Feature List Together and put it back in the original order
        allFeat <- rbind(meanFeat, stdFeat)
        feat_table <- allFeat[order(allFeat[,1]),]
        
}


## Function extractDataHAR - accepts the location of the subject, and X and Y data files
##  It also receives the included-features list constructed earlier
##  The column positions of the features table are used to pick the columns to include from the raw X data
##  The names of the features contained in the second column of the included-features table is used to
##  rename the columns of the X data

## finally the subject and activity data are combined in the same table 

extractDataHAR  <- function(subject_file, subject_col, y_file, y_col, x_file, act_labels, incl_features)
{
        # First read all the raw data
        
        ## Read the subject table
        subject_table <- read.table(subject_file)
        colnames(subject_table) <- c(subject_col)

        y_table <- read.table(y_file)
        colnames(y_table) <- c(names(act_labels)[1])
        
        ## Process the y_table data to replace activity codes with activity names and subset the Activity label column
        y_table <- merge(y_table, act_labels, all = FALSE)
        colnames(y_table) <- c(names(act_labels))
        y_table <- y_table[c(y_col)]
        
        

        ## Read the main data table in its entirity
        x_table <- read.table(x_file)

        ## Before proceeding further, filter by only the required columns
        ## based on the column numbers matching each feature of interest
        ## this information was constructed earlier in the extractFeaturesList function in the incl_features table
        ## At this stage, also apply the user-friendly column names, which are also in the incl_features table
        
        filtered_x_table <- x_table[, incl_features[,1]]
        colnames(filtered_x_table) <- incl_features[,2]
        
        x_data_table <- cbind(subject_table, y_table, filtered_x_table)
}

## Perform any initialization steps as necessary
summarizeDataHAR <- function(tidy_data)
{
        ## Contains code to initialize working directory, etc.,
        ## currently this is just a [;ace-holder function
        
        ## use the aggregate function.  Aggregate over columns 3:68
        ## using factors from the first two columns.
        ## use the reverse order for setting up the factor to aggregate first by activity and then by subject
        ## Finally reverse the column arrangement to get the data in the right order.
        
        num_factor_cols <- 2;
        first_agg_col = num_factor_cols+1;
        total_cols <- ncol(tidy_data)
        
        fac_cols <- num_factor_cols:1
        agg_cols <- first_agg_col:total_cols
        
        
        temp1 <- aggregate.data.frame(tidy_data[, agg_cols], tidy_data[, fac_cols], FUN = mean)
        
        arrange_col <- c (fac_cols, agg_cols)
        
        summary_table <- temp1[, arrange_col]
        

        
        print("Sumary Completed. Dimensions of the summary table are as show below:")
        print(dim(summary_table))
        
        return (summary_table)
}

## Saves the result in the ouytput folder
## Creates the "tidy" folder if not already present
saveTidyData <- function(dirname, filename, tidy_data)
{
        ## writes the tidy data into a table
        
  
        if (!file.exists(dirname))
        {
                print("Creating tidy directry to save output")
                dir.create(file.path(dirname))
        } 
        
        write.table(tidy_data, filename, row.names = FALSE)
        print("Saving tidy data in tidy directory")
        
}

## Saves the summary in the output folder
## Creates the "tidy" folder if not already present
saveSummaryData <- function(dirname, filename, summ_data)
{
        ## writes the tidy data into a table
        
        
        if (!file.exists(dirname))
        {
                print("Creating tidy directry to save output")
                dir.create(file.path(dirname))
        } 
        
        write.table(summ_data, filename, row.names = FALSE)
        print("Saving summary data in tidy directory")
        
}