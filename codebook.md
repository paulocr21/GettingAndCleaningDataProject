---
title: "Codebook"
author: "Activity Tracking Using Smartphones"
output: html_document
---

The file "ActivityTrackingUsingSmartphones.txt" was generated from the R script run_analysis.R.
The original dataset represents data collected from the accelerometers from the Samsung Galaxy S smartphone. 

These experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

A full description is available at the site from where the original data was obtained:
_UCI Dataset Human Activity Recognition Using Smartphones_ (http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

We performed a series of steps to clean up the original data and create the final tidy dataset was written to the text file ActivityTrackingUsingSmartphones.txt:

1. We downloaded the zip file with all the data from the site above.
3. We merged the training and the test sets to create one data set.
4. We extracted only the measurements on the mean and standard deviation for each measurement.
5. We used descriptive activity names to name the activities in the data set
6. We appropriately labeled the data set with descriptive variable names.
7. From the data set in step 4, we created a second, independent tidy data set with the average of each
variable for each activity and each subject.
8. This second, independent tidy data was written to the text file ActivityTrackingUsingSmartphones.txt.

Full detailed descriptions of the steps above are also in the comments in the R script file run_analysis.R.

Using the R script above, the final dataset, that was written to the text file ActivityTrackingUsingSmartphones.txt, has the following variables:

* _Subject_ - the subject who performed the activity for each window sample. Its range is from 1 to 30.
* _Activity Class_ - the name of the activity performed by the subject
* _FeatureDomain_ - the time domain signal or frequency domain signal: Time or Freq
* _FeatureInstrument_ -	the measuring instrument: Accelerometer or Gyroscope
* _FeatureAcceleration_ - the acceleration signal: Body or Gravity
* _FeatureStats_- a summary statistics: Mean or SD (standard deviation)
* _FeatureJerk_ - a jerk signal
* _FeatureMagnitude_ -	the magnitude of the signals calculated using the Euclidean norm
* _FeatureAxis_	- the 3-axial signals in the X, Y and Z directions (X, Y, or Z)
* _count_ - count of data points used to compute average
* _average_	- the average of each variable for each activity and each subject



