Getting and Cleaning Data Project

Process the data captured in the zipfile https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to create a tidy dataset that meets the following requirements

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names. 

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


The features_info.txt included in the zipfile fully explains the original dataset. A brief excerpt of which is included here. 
This is taken directly from the original dataset codebook.
    "The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 


    Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 


    Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 


    These signals were used to estimate variables of the feature vector for each pattern:  
    '-XYZ' is used to denote 3-axial signals in the X, Y and Z directions."



Process/Translation steps

1) Read the activity labels into memory (walking, laying, standing, etc).

2) Read the training data subjects, activities, and values into memory.

3) Read the testing data subjects, activities, and values into memory.

4) Merge the training/testing data into one combined dataset and thus satisfying requirement #1.

5) Read the headers into memory and label all the columns of the combined dataset, thus satisfy requirement #4.

6) Merge the activity labels dataset with the combined dataset so that each activity has a meaningful label (walking, laying, standing, etc). Very similar to join statement in SQL. Requirement #3 is now satisfied.

7) The data of interest (per requirement #2) is the average of the mean and standard deviations for each measurement. That data is extracted using the grep command. There was much debate around whether to include certain columns such as meanFreq() vs mean(). I opted for a very literal interpretation and only included those with mean() and not those with meanFreq(). It appears from the discussion that there was no clear consensus on which was right.

8) Now things get interesting. The final requirement seeks a tidy dataset, but does not actually indicate what the tidy dataset will be used for. That makes it difficult to design the tidy dataset because part of the design process is to establish the intended use of the dataset. In other words, what is tidy data is dependent on the subsequent analysis. I opted to define an observation as the subject (i.e. human), activity (e.g. walking), and measurement (e.g. tBodyAcc-mean()-X). The primary justification I submit is the paper found at http://vita.had.co.nz/papers/tidy-data.pdf. My belief was that the existing dataset suffered from column headers as values, not variable names, so I opted to melt or translate the data such that each measurement became a row.

9) Wrote the data to a file using the required commend write.table().


Results

The final data format is
subject     activityName    variable            values
1           standing        tBodyAcc-mean()-X   0.278917629

The alternative "wide" format is also included.
subject     activityName      tBodyAcc-mean()-X      tBodyAcc-mean()-Y ...
Variables
1) Subject - The number assigned to each person participating in the study. Since 30 people participated, the subject values range from 1 to 30, with each number representing an unique individual. The field is numeric.
2) activityName - The type of activity the person participated in. The values are standing, sitting, laying, walking, walking_downstairs, walking_upstairs. Each person participate in each activity. This is a text field.
3) variable - The average of the variable being measured. Each person has measures for each activity. This is a text field and the values are
         1:           tBodyAcc-mean()-X
         2:           tBodyAcc-mean()-Y
         3:           tBodyAcc-mean()-Z
         4:            tBodyAcc-std()-X
         5:            tBodyAcc-std()-Y
         6:            tBodyAcc-std()-Z
         7:        tGravityAcc-mean()-X
         8:        tGravityAcc-mean()-Y
         9:        tGravityAcc-mean()-Z
        10:         tGravityAcc-std()-X
        11:         tGravityAcc-std()-Y
        12:         tGravityAcc-std()-Z
        13:       tBodyAccJerk-mean()-X
        14:       tBodyAccJerk-mean()-Y
        15:       tBodyAccJerk-mean()-Z
        16:        tBodyAccJerk-std()-X
        17:        tBodyAccJerk-std()-Y
        18:        tBodyAccJerk-std()-Z
        19:          tBodyGyro-mean()-X
        20:          tBodyGyro-mean()-Y
        21:          tBodyGyro-mean()-Z
        22:           tBodyGyro-std()-X
        23:           tBodyGyro-std()-Y
        24:           tBodyGyro-std()-Z
        25:      tBodyGyroJerk-mean()-X
        26:      tBodyGyroJerk-mean()-Y
        27:      tBodyGyroJerk-mean()-Z
        28:       tBodyGyroJerk-std()-X
        29:       tBodyGyroJerk-std()-Y
        30:       tBodyGyroJerk-std()-Z
        31:          tBodyAccMag-mean()
        32:           tBodyAccMag-std()
        33:       tGravityAccMag-mean()
        34:        tGravityAccMag-std()
        35:      tBodyAccJerkMag-mean()
        36:       tBodyAccJerkMag-std()
        37:         tBodyGyroMag-mean()
        38:          tBodyGyroMag-std()
        39:     tBodyGyroJerkMag-mean()
        40:      tBodyGyroJerkMag-std()
        41:           fBodyAcc-mean()-X
        42:           fBodyAcc-mean()-Y
        43:           fBodyAcc-mean()-Z
        44:            fBodyAcc-std()-X
        45:            fBodyAcc-std()-Y
        46:            fBodyAcc-std()-Z
        47:       fBodyAccJerk-mean()-X
        48:       fBodyAccJerk-mean()-Y
        49:       fBodyAccJerk-mean()-Z
        50:        fBodyAccJerk-std()-X
        51:        fBodyAccJerk-std()-Y
        52:        fBodyAccJerk-std()-Z
        53:          fBodyGyro-mean()-X
        54:          fBodyGyro-mean()-Y
        55:          fBodyGyro-mean()-Z
        56:           fBodyGyro-std()-X
        57:           fBodyGyro-std()-Y
        58:           fBodyGyro-std()-Z
        59:          fBodyAccMag-mean()
        60:           fBodyAccMag-std()
        61:  fBodyBodyAccJerkMag-mean()
        62:   fBodyBodyAccJerkMag-std()
        63:     fBodyBodyGyroMag-mean()
        64:      fBodyBodyGyroMag-std()
        65: fBodyBodyGyroJerkMag-mean()
        66:  fBodyBodyGyroJerkMag-std()
4) average - The average value of the variable being measured. The field is numeric.

There are 11,880 total obersvations (30 participants * 6 activities * 66 measurements).
