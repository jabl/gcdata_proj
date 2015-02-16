# Download and uncompress the data set if it doesn't exist already
getUCIHARData <- function() {
    fname <- "UCI_HAR_Dataset.zip"
    if (!file.exists(fname)) {
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                      destfile=fname, method="curl")
        unzip(fname)
    }
    # Return root directory of uncompressed data
    "UCI HAR Dataset"
}

# Run everything
runAll <- function() {
  udir <- getUCIHARData()

  # Create a factor with the activity labels
  al <- read.table(file.path(udir, "activity_labels.txt"),
                   colClasses=c("integer", "character"))
  act_lab <- factor(al$V1, al$V2)

  # Get the feature labels
  feat_lab <- read.table(file.path(udir, "features.txt"),
                         colClasses=c("NULL", "character"))$V2

  xtest <- read.table(file.path(udir, "test", "X_test.txt"),
                      colClasses="numeric", comment.char="",
                      col.names=feat_lab)
  ytest <- read.table(file.path(udir, "test", "y_test.txt"),
                      colClasses="factor")
  stest <- read.table(file.path(udir, "test", "subject_test.txt"),
                      colClasses="factor")
}

runAll()