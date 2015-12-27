# GettingAndCleaningDataProject

Coursera's "Getting and Cleaning Data" course project to clean up data captured from human activity monitoring

## Objectives

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

## Description

The original dataset was downloaded from the site [UCI Human Activity Recognition Using Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

A description of the original dataset and of the final, tidy dataset that we created is in the file Codebook.md in this repository.

The script file run_analysis.R (also in this repository) was used to clean up the original dataset and generate the final tidy dataset that was then written to the text file ActivityTrackingUsingSmartphones.txt. Once the original dataset is downloaded and unzipped, it creates a directory named "UCI HAR Dataset" in the current directory. This R script assumes that the original dataset was downloaded and unzipped and that is present in the same working directory.





