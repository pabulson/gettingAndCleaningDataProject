gettingAndCleaningDataProject
=============================

Getting and Cleaning Data Project

Assignment (or requirements)

Create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names. 

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Assumptions

1) The zip file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip has been downloaded and uncompressed.

2) The working directory is currently set to the extracted "UCI HAR Dataset" directory (or folder).


Directions

1) Execute the run_analysis.R scripts from the "UCI HAR Dataset" directory (or folder) after unzipping the required zipfile.


Algorithm

1) Read the activity labels into memory (walking, laying, standing, etc).

2) Read the training data subjects, activities, and values into memory.

3) Read the testing data subjects, activities, and values into memory.

4) Merge the training/testing data into one combined dataset and thus satisfying requirement #1.

5) At this point the combined training/testing dataset has no column labels, so label all the columns and thus satisfy requirement #4.

6) Using the labels dataset, merge with the combined dataset such that each activity now has a meaningful label (walking, laying, standing, etc). Very similar to join statement in SQL. Requirement #3 is now satisfied.

7) The data of interest (per requirement #2) is the mean and standard deviation for each measurement. That data is extracted using the grep command. There was much debate around whether to include certain columns such as meanFreq() vs mean(). I opted for a very literal interpretation and only included those with mean() and not those with meanFreq(). It appears from the discussion that there was no clear consensus on which was right.

8) Now things get interesting. The final requirement seeks a tidy dataset, but does not actually indicate what the tidy dataset will be used for. That makes it difficult to design the tidy dataset because part of the design process is to establish the intended use of the dataset. In other words, what is tidy data is dependent on the subsequent analysis. I opted to define an observation as the subject (i.e. human), activity (e.g. walking), and measurement (e.g. tBodyAcc-mean()-X). The primary justification I submit is the paper found at http://vita.had.co.nz/papers/tidy-data.pdf. My belief was that the existing dataset suffered from column headers as values, not variable names, so I opted to melt or translate the data such that each measurement became a row. I also included the alternative (not melting) as a peace offering to those that disagree.

9) Wrote the data to a file using the required commend write.table().

Results
The final data format is
subject     activityName    variable            values
1           standing        tBodyAcc-mean()-X   0.278917629
