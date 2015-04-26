#Codebook for Project 1:  Wearable Computing#
##John Hopkins Getting and Cleaning Data, codebook associated with file run_analysis.R##
April, 2015

##Running the code: 
* R Program file:  run_analysis.R; fork the Github repository () to a local directory.
* Raw source files:  8 .txt files are in the Github repository and should now also be in your local Github directory.  Alternately, you can source the original files at (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), unzip, and place the required files in a directory with the .R program code.  Note that the .R code does not have the commands required for downloading, unzipping and managing the paths for the .txt files.
* Working Directory:  set the working directory to the location where you've stored the program code and raw files
* Package dependencies: packages "reshape2" and "plyr" are required.  The .R code includes commands to open these as libraries, but commands to install the packages are currently commented out under the assumption that every person in this course now already has these two packages installed.
* Output:  project1.txt, delimited using space as the separator, located in the same directory as the .R code

##Project Description:  Create a tidy dataset from the UCI datasets on Human Activity Recognition Using Smartphones dataset (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones); the tidy data will provide the mean for all metrics pertaining to standard deviation and mean across all subjects and activities.  There are 30 subjects, six activities, 33 metrics involving standard deviation and 33 metrics involving mean.  The final tidy dataset (project1.txt) is long, including columns for subject, activity, metric name, and metric mean.

##Collection of the raw data: quoting directly from the features_info.txt file provided by the UCI project team:
"The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 
"Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).
"Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).
"These signals were used to estimate variables of the feature vector for each pattern:  '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions."

##Notes on the original raw data:  Eight Source (raw) Files are Used:  X_test.txt, y_test.txt, X_train.txt, y_train.txt, features.txt, and activity_labels.txt, subject_test.txt, subject_train.txt
* X_test.txt, y_test.txt, X_train.txt, y_train.txt, subject_test.txt, subject_train.txt:  measurement data detail files for wearable computing study use to compile the data detail file
* X_test and X_train contain 2947 and 7352 data observations respectively, each measured with 561 variables which are assumed to be the datapoints listed in the features.txt file.  y_test and y_train contain 2947 and 7352 data observations on one variable, which is assumed to be the activity number listed in the activity_labels.txt file (1:6). Subject_test.txt and subject_train.txt contain 2947 and 7352 datapoints on one variable which is assumed to be the subject ID number (1:30).
* features.txt:  source for features master file; the features file lists 561 data measurements.
* activity_labels.txt:  source for activity master data; the file lists six observations across two variables, one of which is apparently an id number corresponding to the variable recorded in y_test.txt and y_train.txt; the second is a description indicating a type of activity (walking, running upstairs, etc).
* X, y, and subject (either test or train)are a set which can be assembled to a single file via use of cbind.  the X file contains data observations while the y file identifies the activity under review on a given row in X, and the subject file identifies the subject under review on any given row in X.  The activity number from column y can be matched to the activity name found in activity_labels.txt.  The 561 columns of X can be assumed to match the  561 features in the features.txt file, in sequential order.  The featureID number preserves the original order in the features and X files. 
* The method used here is to first process data from features.txt to identify the required fields (mean and standard deviation) and to interpret the string to a meaningful name.  Files X, y, and subject are then bound via cbind and then bound test and train files are bound via rbind.

##Guide to creating the tidy datafile:  project1.txt
* The output is in "wide" format with one key field (activity) and 66 variable fields.
* "Tidy Data" by Hadley Wickham (Journal of Statistical Software, http://vita.had.co.nz/papers/tidy-data.pdf) was used as a source document for many decisions used in this project. 
* Process outline by function:  Master files are first built from features.txt and activity_labels.txt; the raw data files (X_train.txt, y_train.txt, X_test.txt, y_test.txt)are then combined to a single file in mergeRawFiles; in the same function, the tidy column labels are applied via the featuresMas features master file
	* buildFeature:  output featureMas table, the features master file.  Starting with features.txt, add the column "metric" and identify all mean and standard deviation metrics.  Add a column tidyTitle for a column header title in a standardized format; match patterns in the features.txt description string to develop the appropriate title.  The feature master file is then used in mergeFiles.
	* mergeFiles:  output activeData table, the composite data table containing test and train data.  Cbind x_test, y_test, and subject_test; cbind x_train, y_train, and subject_train, then rbind the test and train datasets. This function also adds the appropriate column titles based on the featureMas table, and deletes unneeded columns based also on featureMas.  The output of this process is 68 columns by 10,299 rows.  The 68 columns include 33 metrics for mean and 33 metrics for standard deviation (ordered according to the sequence found in the X_ files), one column for activity ID, and one column for subject.
	* addKeyField:  output activeDataKey table.  Adds activity name to activeData file via join with activeMas table.  Re-orders the columns such that the subject and activity key fields are on the left rather than the right (no re-ordering is done to the mean and standard deviation columns other than to shift them two columns to the right).  The resulting file has 69 columns and 10,299 rows.
	* tidyAverages:  output project1.txt, the tidy dataset.  
* Filter decisions:  Per directions, mean and standard deviation measures were selected, all other records rejected, leaving 66 columns from the original 561.  Selection is based directly on an extract of all metrics with "std()" and "mean()", thus rejecting the substrings "meanFreq" and "gravityMean" - these appear to be different measures altogether vs the means represented by the remaining metrics.  The determination of this classification is based on an analysis of the information provided by study authors in the read.me and features_info.txt files.  The substring "BodyBody" was changed to "Body" in six metric names.
* Transformation decisions:  Decisions regarding cbind of X, y, and subject files is based on study of numeric patterns in the files - this appears to be the correct way to assemble the data, and this method does have meaning in that all X datapoints then represent measures, y datapoints represent activities, and subject datapoints represent subjects.  The read.me file notes the meaning of "test" and "train", hence the decision to rbind the two datasets is natural.  Strings describing metrics in features.txt seemed cryptic and thus have been replaced with longer strings that are hopefully more descriptive.  The decoder under variables (below) gives the meaning of each term found in the metric descriptions.  The metrics are not de-constructed to major groups (eg accelerometer, gyroscope...); doing so leaves too many gaps in the data and, as per the discussion notes (https://class.coursera.org/getdata-013/forum/thread?thread_id=30) it will be better practice to leave the metrics consolidated as found in the original file.
* Aggregation decisions:  Aggregation takes place only in the tidyAverages function when the 10,299 rows of the table activeDataKey are summarized as means by activity across all datapoints collected in the study.  The aggregation is requested as part of the project.
* Sort decisions:  Sort order of the metric columns is exactly as per the original file - no value is achieved by changing this sort order.  Subjects are ordered 1 to 30 in descending order.  Activities are ordered as per the activies.txt file - this is accomplished by retaining the activityID along with the activity name, the output file is ordered by the ID.
* Other decisions:  Fairly long metric names have been used as column headers.  This is to help with comprehending the meaning of each metric - the user will find that they can read the "de-constructed" descriptions below in order to understand each component of the metric title.  Per the comment above, it does not make sense to deconstruct the metric itself, however de-construction is a useful tool for understanding the long metric titles.  All words in the metric titles start with a capital letter to help with reading.  With regards to the order of actions that our program should carry out, note that the code completes step 4 (label the dataset with descriptive variable names) is done immediately after consolidating datasets and in conjunction with elimination of metrics not pertaining to the mean and standard deviation measures.  This works best with this particular version of code, and the difference may pertain to the use of a master features file for holding much of the required information.

##Cleaning the data:
* strings in features.txt containing the substring "BodyBody" have been modified - the string is changed to "Body".  A selection routine has deleted all columns in X pertaining to metrics not on the list for mean and standard deviation measures.  The activityID in y files has been replaced with the activity name in activity.txt.  The subject ID in subject files has been replaced with "subject" plus the ID number.  Other than these changes all remaining data is as it is found in the raw .txt files.

##Description of the variables in the tidy dataset project1.txt:
###Variable 1:  subject:  subject ID listed in the raw files subject_train.txt and subject_text.txt.  There are 30 subjects in all.  The ID has been left as-is without appending a name such as "subject1" based on a reading of preferred data layout in Wickham's paper on tidy data.

###Variable 2:  activity:  Activity name listed in the raw file activity_labels.txt; the label is attached to the dataset in x_test.txt and x_train.txt via the activity ID found in y_test.txt and y_train.txt.  The activity ID has been used to sort the file, however is deleted after sorting, so only the activity label is left in the tidy data file (project1.txt).

###Variable 3:  variable:  The metric applied during the study.  There are a total of 33 mean metrics and 33 standard deviation metrics applied.  No attempt has been made here to de-construct the variable to group metrics such as acceleration, gravity, etc since this results in numerous gaps in the data.  It is, however, useful to de-construct the meaning of the names in the metric, and so a de-constructed definition for each component is provided below.  The de-constructed meaning is based on readme.txt and features-info.txt files provided with the original dataset.
* TimeDomainSignal: Signals captured at a constant rate of 50Hz and subsequently filtered with a 3rd order low pass Butterworth filter with a corner frequency of 20Hz.
* FastFourierTransform:  Fast fourier transform of selected signals.
* Accelerometer: Feature derived from the accelerometer 3-axial raw signal.
* Gyroscope: Feature derived from the gyroscope 3-axial raw signal.
* Body: Body acceleration signal derived via use of low pass Butterworth filter with a corner frequency of 0.3Hz.
* Gravity: Gravity acceleration signal derived via use of a low pass Butterworth filter with a corner frequency of 0.3Hz.
* Jerk: Jerk signal of the body linear acceleration and angular velocity.
* Magnitude: Magnitude of the body linear acceleration and angular velocity as calculated using the Euclidean norm
* XCoordinate: Estimated x coordinate feature vector
* YCoordinate: Estimated y coordinate feature vector
* ZCoordinate: Estimated z coordinate feature vector

###Variable 4:  metricMean:  the mean of all datapoints associated with the metric in the "variable" column.  This is the final summary form requested of this project.

##Sources:
UCI website:  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
UCI data download:  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Project discussion concerning optimal tidy dataset and code:  https://class.coursera.org/getdata-013/forum/thread?thread_id=30
Wickham article on tidy data:  http://vita.had.co.nz/papers/tidy-data.pdf

  







