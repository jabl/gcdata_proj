# Download and uncompress the data set if it doesn't exist already
getUCIHARData <- function() {
    fname <- "UCI_HAR_Dataset.zip"
    if (!file.exists(fname)) {
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                      destfile=fname, method="curl")
        unzip(fname)
    }
}
