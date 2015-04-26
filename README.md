# Project1_Wearable_Computing

##Obtaining the files:  Fork the Github repository (https://github.com/csapng/Project1_Wearable_Computing)
##Reading the output:  
* project1.txt, delimited using space as the separator, located in Github directory. To read in R use read.table("project1.txt", header = TRUE); anticipate a tidy long file, 11881 rows by 4 columns (subject, activity, feature, featureMean).

##Running the code: 
* R Program file:  run_analysis.R, found in Github repository.
* Raw source files:  8 .txt files are in the Github repository and should now also be in your local Github directory.  Alternately, you can source the original files at (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), unzip, and place the required files in a directory with the .R program code.  Note that the .R code does not have the commands required for downloading, unzipping and managing the paths for the .txt files.
* Working Directory:  set the working directory to the location where you've stored the program code and raw files
* Package dependencies: packages "reshape2" and "dplyr" are required.  The .R code includes commands to open these as libraries, but commands to install the packages are currently commented out under the assumption that every person in this course now already has these two packages installed.

##Project Description:  
Create a tidy dataset from the UCI datasets on Human Activity Recognition Using Smartphones dataset (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones); the tidy data will provide the mean for all measurements pertaining to standard deviation and mean across all subjects and activities.  There are 30 subjects, six activities, 33 measurements involving standard deviation and 33 measurements involving mean.  The final tidy dataset (project1.txt) is long, including columns for subject, activity, measurement name, and measurement mean.

For additional information refer to the codebook in this repository
