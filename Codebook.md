#Codebook for Project 1:  Wearable Computing#
##John Hopkins Getting and Cleaning Data, codebook associated with file run_analysis.R##
April, 2015

Running the code: 
* R Program file:  run_analysis.R; fork the Github repository to a local directory.
* Raw source files:  8 .txt files are in the Github repository and should now also be in your local Github directory.  Alternately, you can source the original files at (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip), unzip, and place the required files in a directory with the .R program code.  Note that the .R code does not have the commands required for downloading, unzipping and managing the paths for the .txt files.
* Working Directory:  set the working directory to the location where you've stored the program code and raw files
* Package dependencies: packages "reshape2" and "plyr" are required.  The .R code includes commands to open these as libraries, but commands to install the packages are currently commented out under the assumption that every person in this course now already has these two packages installed.
* Output:  project1.txt, delimited using space as the separator, located in the same directory as the .R code




Characterizing the raw data: Eight Source (raw) Files are Used:  X_test.txt, y_test.txt, X_train.txt, y_train.txt, features.txt, and activity_labels.txt, subject_test.txt, subject_train.txt
* X_test.txt, y_test.txt, X_train.txt, y_train.txt, subject_test.txt, subject_train.txt:  measurement data detail files for wearable computing study use to compile the data detail file
* X_test and X_train contain 2947 and 7352 data observations respectively, each measured with 561 variables which are assumed to be the datapoints listed in the features.txt file.  y_test and y_train contain 2947 and 7352 data observations on one variable, which is assumed to be the activity number listed in the activity_labels.txt file (1:6). Subject_test.txt and subject_train.txt contain 2947 and 7352 datapoints on one variable which is assumed to be the subject ID number (1:30).
* features.txt:  source for features master file; the features file lists 561 data measurements.
* activity_labels.txt:  source for activity master data; the file lists six observations across two variables, one of which is apparently an id number corresponding to the variable recorded in y_test.txt and y_train.txt; the second is a description indicating a type of activity (walking, running upstairs, etc).
* X, y, and subject (either test or train)are a set which can be assembled to a single file via use of cbind.  the X file contains data observations while the y file identifies the activity under review on a given row in X, and the subject file identifies the subject under review on any given row in X.  The activity number from column y can be matched to the activity name found in activity_labels.txt.  The 561 columns of X can be assumed to match the  561 features in the features.txt file, in sequential order.  The featureID number preserves the original order in the features and X files. 
* The method used here is to first process data from features.txt to identify the required fields (mean and standard deviation) and to interpret the string to a meaningful name.  Files X, y, and subject are then bound via cbind and then bound test and train files are bound via rbind.
* strings in features.txt containing the substring "BodyBody" have been modified - the string is changed to "Body".  A selection routine has deleted all columns in X pertaining to metrics not on the list for mean and standard deviation measures.  The activityID in y files has been replaced with the activity name in activity.txt.  The subject ID in subject files has been replaced with "subject" plus the ID number.  Other than these changes all remaining data is as it is found in the raw .txt files.

Processing decisions for production of the tidy dataset (project1.txt):
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
  
  
  
Tidy Data Output File:  project1.txt
The output is in "wide" format with one key field (activity) and 66 variable fields.

Comprehensive List of Tidy Data Output File Variables:  Variable naming conventions differ from standard in that camelCase is used to help distinguish keywords.  The entire description has been placed in the variable name rather than abbreviations - cumbersome for length but hopefully clearer on meaning.  Per the recommendations in the project discussion, no attempt has been  made to de-construct the variables.

The following are the key field variables in the output:
  activity:  Walking, walking upstairs, walking downstairs, sitting, standing, running, laying.  These are the key activities during which measurements were taken during the study.
  subject:  subject1...subject30.  This is the subject ID for the 30 study participants.
  
The following are de-constructed components of the variables:  
    TimeDomainSignal:  
	FastFourierTransform:  
	Accelerometer:  
	Gyroscope:  
	Body:  
	Gravity:  
	Jerk:  
	XCoordinate:  
	YCoordinate:  
	ZCoordinate:  
	
The following are the variables in the output - these comprise 66 of 67 column headers in the output file (with "activity", the key field, as the remaining header):  
  TimeDomainSignalAccelerometerBodyXCoordinateYCoordinateMean
  TimeDomainSignalAccelerometerBodyYCoordinateMean
  TimeDomainSignalAccelerometerBodyYCoordinateZCoordinateMean
  TimeDomainSignalAccelerometerGravityXCoordinateYCoordinateMean
  TimeDomainSignalAccelerometerGravityYCoordinateMean
  TimeDomainSignalAccelerometerGravityYCoordinateZCoordinateMean
  TimeDomainSignalAccelerometerBodyJerkXCoordinateYCoordinateMean
  TimeDomainSignalAccelerometerBodyJerkYCoordinateMean
  TimeDomainSignalAccelerometerBodyJerkYCoordinateZCoordinateMean
  TimeDomainSignalGyroscopeBodyXCoordinateYCoordinateMean
  TimeDomainSignalGyroscopeBodyYCoordinateMean
  TimeDomainSignalGyroscopeBodyYCoordinateZCoordinateMean
  TimeDomainSignalGyroscopeBodyJerkXCoordinateYCoordinateMean
  TimeDomainSignalGyroscopeBodyJerkYCoordinateMean
  TimeDomainSignalGyroscopeBodyJerkYCoordinateZCoordinateMean
  TimeDomainSignalAccelerometerBodyMagnitudeYCoordinateMean
  TimeDomainSignalAccelerometerGravityMagnitudeYCoordinateMean
  TimeDomainSignalAccelerometerBodyJerkMagnitudeYCoordinateMean
  TimeDomainSignalGyroscopeBodyMagnitudeYCoordinateMean
  TimeDomainSignalGyroscopeBodyJerkMagnitudeYCoordinateMean
  FastFourierTransformAccelerometerBodyXCoordinateYCoordinateMean
  FastFourierTransformAccelerometerBodyYCoordinateMean
  FastFourierTransformAccelerometerBodyYCoordinateZCoordinateMean
  FastFourierTransformAccelerometerBodyJerkXCoordinateYCoordinateMean
  FastFourierTransformAccelerometerBodyJerkYCoordinateMean
  FastFourierTransformAccelerometerBodyJerkYCoordinateZCoordinateMean
  FastFourierTransformGyroscopeBodyXCoordinateYCoordinateMean
  FastFourierTransformGyroscopeBodyYCoordinateMean
  FastFourierTransformGyroscopeBodyYCoordinateZCoordinateMean
  FastFourierTransformAccelerometerBodyMagnitudeYCoordinateMean
  FastFourierTransformAccelerometerBodyJerkMagnitudeYCoordinateMean
  FastFourierTransformGyroscopeBodyMagnitudeYCoordinateMean
  FastFourierTransformGyroscopeBodyJerkMagnitudeYCoordinateMean
  TimeDomainSignalAccelerometerBodyXCoordinateYCoordinateStandardDeviation
  TimeDomainSignalAccelerometerBodyYCoordinateStandardDeviation
  TimeDomainSignalAccelerometerBodyYCoordinateZCoordinateStandardDeviation
  TimeDomainSignalAccelerometerGravityXCoordinateYCoordinateStandardDeviation
  TimeDomainSignalAccelerometerGravityYCoordinateStandardDeviation
  TimeDomainSignalAccelerometerGravityYCoordinateZCoordinateStandardDeviation
  TimeDomainSignalAccelerometerBodyJerkXCoordinateYCoordinateStandardDeviation
  TimeDomainSignalAccelerometerBodyJerkYCoordinateStandardDeviation
  TimeDomainSignalAccelerometerBodyJerkYCoordinateZCoordinateStandardDeviation
  TimeDomainSignalGyroscopeBodyXCoordinateYCoordinateStandardDeviation
  TimeDomainSignalGyroscopeBodyYCoordinateStandardDeviation
  TimeDomainSignalGyroscopeBodyYCoordinateZCoordinateStandardDeviation
  TimeDomainSignalGyroscopeBodyJerkXCoordinateYCoordinateStandardDeviation
  TimeDomainSignalGyroscopeBodyJerkYCoordinateStandardDeviation
  TimeDomainSignalGyroscopeBodyJerkYCoordinateZCoordinateStandardDeviation
  TimeDomainSignalAccelerometerBodyMagnitudeYCoordinateStandardDeviation
  TimeDomainSignalAccelerometerGravityMagnitudeYCoordinateStandardDeviation
  TimeDomainSignalAccelerometerBodyJerkMagnitudeYCoordinateStandardDeviation
  TimeDomainSignalGyroscopeBodyMagnitudeYCoordinateStandardDeviation
  TimeDomainSignalGyroscopeBodyJerkMagnitudeYCoordinateStandardDeviation
  FastFourierTransformAccelerometerBodyXCoordinateYCoordinateStandardDeviation
  FastFourierTransformAccelerometerBodyYCoordinateStandardDeviation
  FastFourierTransformAccelerometerBodyYCoordinateZCoordinateStandardDeviation
  FastFourierTransformAccelerometerBodyJerkXCoordinateYCoordinateStandardDeviation
  FastFourierTransformAccelerometerBodyJerkYCoordinateStandardDeviation
  FastFourierTransformAccelerometerBodyJerkYCoordinateZCoordinateStandardDeviation
  FastFourierTransformGyroscopeBodyXCoordinateYCoordinateStandardDeviation
  FastFourierTransformGyroscopeBodyYCoordinateStandardDeviation
  FastFourierTransformGyroscopeBodyYCoordinateZCoordinateStandardDeviation
  FastFourierTransformAccelerometerBodyMagnitudeYCoordinateStandardDeviation
  FastFourierTransformAccelerometerBodyJerkMagnitudeYCoordinateStandardDeviation
  FastFourierTransformGyroscopeBodyMagnitudeYCoordinateStandardDeviation
  FastFourierTransformGyroscopeBodyJerkMagnitudeYCoordinateStandardDeviation

  activityID:  activity ID number used for sorting the final output.


Summaries:

The datafiles X_test, y_test, X_train, and y_train present a very complex dataset, one that could be difficult to audit given the order of magnitude of having 5.8M datapoints arrayed with no identifying headers or row names.  Two steps have been taken to help with this audit process.  First, a unique row identifier is added to the activity table for each row, and this identifier is retained through to the activeMSD table output.  This identifier can then be used to trace individual records through the various stages of the process.  The row identifier is strictly for audit, it is not used in any subsequent stage of data processing.  Second, processing of the four files has been minimized.  This is the point of using only a number (1:561) as a column identifier in the raw datafile rather than trying to link the raw datafile to a processed features.csv file in order to apply meaningful headers.  In fact features.csv needs significant processing, and linking the two large files is a major complexity offering opportunities for error.  Just using numeric headers in the datafile minimizes these risks.

Processing of the features.csv file is the most complicated stage of the data cleaning process.  It is also the stage that involves the most discretionary decision making with regards to correct level of aggregation of the data.  As such, the intermediate master file featuresMas.csv is archived after processing.  The master file is also processed to a level beyond what is needed to complete the tidy dataset in that it includes data segmentation descriptors that are not used for aggregating data in the summary dataset.  The most likely outcome of the first analysis of the tidy dataset is that the researcher will decide to alter the level of aggregation and possibly include to change the subset of data included in the aggregation.  To accomplish this it is possible to review the featuresMas.csv file as a first solution.  In the case of level of aggregation the required segmentation is probably already defined in the file, so the solution is to change the processing of the activity table using the existing segmentation fields.  If more data is to be included or additional datapoints to be excluded then this may require a change in the way featuresMas.csv data is processed.  Here too, the best way to determine this is to review the existing featuresMas.csv file to make this determination.  Hence it is important to save this intermediate file in anticipation of changes in decisions with regards to level of aggregation and aggregation content.  Audit tools are less important for this file since it is relatively easy to audit all 561 datapoints.





Experimental Study:


NOTES:
eliminate use of plyr by eliminating the melt() function; if long data is desired, add plyr back and melt the existing tidy data output
Selected Intermediate Tables (not archived as output files):  
  featureMas:  features master list, features ID cross-reference number, master file for metric type (eg standard deviation and mean), master file for common language headers; raw data sourced from features.txt.  The full cross reference has not been archived, but if changes to the data segmentation or selection are desired then the first stage to doing so will be to View() or archive the featuresMas table to see if the required segmentations are already defined.  

Selected Intermediate Table Variables:


