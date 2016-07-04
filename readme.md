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