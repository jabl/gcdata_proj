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
  act_lab <- factor(al$V1, labels=al$V2)

  # Get the feature labels
  feat_lab <- read.table(file.path(udir, "features.txt"),
                         colClasses=c("NULL", "character"))$V2
  # Filter feat_lab so we retain only the ones containing 
  # mean() or std()
  fms <- grepl("mean()", feat_lab[,]) | 
    grepl("std()", feat_lab[,])
  #feat_lab <- sapply(feat_lab, function(lab) {})
  
  # Read test/train datasets
  readUHDataset <- function(kind) {
     x <- read.table(file.path(udir, kind, 
                               paste("X_", kind, ".txt", sep="")),
                     colClasses="numeric", comment.char="",
                     col.names=feat_lab)
     y <- read.table(file.path(udir, kind, 
                               paste("y_", kind, ".txt", sep="")),
                      colClasses="factor", col.names="activity")
     activity <- factor(y[,], labels=act_lab)
     s <- read.table(file.path(udir, kind, 
                               paste("subject_", kind, ".txt", sep="")),
                     colClasses="factor", col.names="subject")
     cbind(activity, s, x)
  }

  test <- readUHDataset("test")
  #train <- readUHDataset("train")
  #rbind(test, train)
  test
}

l <- runAll()
