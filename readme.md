#==================================================================
#Human Activity Recognition Using Smartphones Dataset


##Cleaning Data Project
##Getting and Cleaning Data
##Final Assignment
#==================================================================

The following files are includes in this Github Repository

i. X_tidy.txt  Contains the tidy version of the combined test and training date from the original study
        
Following changes were made:
* Combined the training and test data for a total of ~10200 samples
* Retained only the mean and standard deviation values estimated for each of the inertial signals in time and frequency        domains
* Replace activity codes with English words for the activities
* Removed parentheses and blanks from signal names and prefixed them with either Mean- or Std- to indicate the type of measurement



ii. X_summary.txt  Contains the aggregated version of the tidy data, aggregated by subject and type of activity.
Contains 40 combinations of subject and activity. 



iii.  run_analysis.R

Contains the R script that contains the main runAnalysis function and several other supporting function.  When the script runs
it produces the two data files under the “tidy” directory. It is expected to run at the same level as the original root folder for the project.

Detailed instructions of how to run the script is captured in the Script-Explanation.html notebook compiled from R-Studio



iv. Script-Explanation.html      

Contains a HTML notebook combined from comments placed in the code. The documentation for each function explains the purpose of the function. Several key steps are also further documented


v. Code Book.pdf

Contains the code book for the data set.  Most of the description was culled from the contents in the original read.me file and pieced together from the features_info.txt file that accompanied the distribution