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


# Create a tidy data set from the UCI HAR dataset
tidyUCIHAR <- function() {
  udir <- getUCIHARData()

  # The activity labels
  al <- read.table(file.path(udir, "activity_labels.txt"),
                   colClasses=c("integer", "character"))

  # Get the feature labels
  feat_lab <- read.table(file.path(udir, "features.txt"),
                         colClasses=c("NULL", "character"))$V2

  # Filter feat_lab so we retain only the ones containing 
  # mean() or std()
  feat_colclasses <- sapply(feat_lab, function(lab) {
      if (grepl("std()", lab, fixed=TRUE)
          || grepl("mean()", lab, fixed=TRUE)) {
          "numeric"
      } else {
          "NULL"
      }
  })

  # Read test/train datasets
  readUHDataset <- function(kind) {
     x <- read.table(file.path(udir, kind, 
                               paste("X_", kind, ".txt", sep="")),
                     colClasses=feat_colclasses, comment.char="",
                     col.names=feat_lab)
     y <- read.table(file.path(udir, kind, 
                               paste("y_", kind, ".txt", sep="")),
                      colClasses="factor", col.names="activity")
     # Create a factor for the activity labels, use descriptive names
     # read previously
     activity <- factor(y[,], levels=al$V1, labels=al$V2)
     s <- read.table(file.path(udir, kind, 
                               paste("subject_", kind, ".txt", sep="")),
                     colClasses="factor", col.names="subject")
     cbind(activity, s, x)
  }

  test <- readUHDataset("test")
  train <- readUHDataset("train")
  rbind(test, train)
}

# Create a dataset with per-subject and per-activity means
tidysmean <- function(d) {
    n <- colnames(d)
    l <- split(d, list(d$subject, d$activity))
    l2 <- lapply(l, function(x) {
        cbind(x[1,1], x[1,2], t(colMeans(x[,3:ncol(x)])))
    })
    r <- do.call("rbind", l2)
    colnames(r) <- n
    r <- data.frame(r)
    r$activity <- factor(r$activity, labels=levels(d$activity))
    r
}

d <- tidyUCIHAR()
tm <- tidysmean(d)
write.table(tm, "tidymeans.txt", row.names=FALSE)
