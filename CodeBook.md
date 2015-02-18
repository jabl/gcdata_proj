Codebook for Getting and Cleaning Data course project
=====================================================

All the code is in the file run_analysis.R. 

The function tidyUCIHAR() creates a tidy version of the raw data. The
return value is a data frame with 10299 rows and 68 columns. The
columns (variables) in the data frame are:

1) activity. A variable of type "factor" describing the activity being
performed for the observation (row) in question. The labels were read
from the file activity_labels.txt in the raw data set, whereas the
activities were read from the files test/y_test.txt and
train/y_train.txt in the raw data set.

2) subject. A factor variable describing which subject performed the
observation in question. Read from test/subject_test.txt and
train/subject_train.txt in the raw data set.

3:68) Numerical data describing the mean and standard deviations of
the measured data. Read from the test/X_test.txt and train/X_train.txt
files in the raw data set. Note that the meanFreq() variables in the
raw data set are not included.'

The function tidysmean() takes a data frame as created by tidyUCIHAR()
and calculates mean values on a per-subject and per-activity basis. As
there are 6 different activities and 30 subjects, the result is a data
frame with 180 rows (6*30) and 68 variables. As the first two columns
contain the activity and subject identifiers, the means are thus
calculated for the remainig 66 columns.

Finally, the run_analysis.R writes the data frame created by
tidysmean() to a file "tidymeans.txt".
