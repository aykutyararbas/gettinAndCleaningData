## Activity recognition using  smartphones 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
workFolder<-"datas"
dataSetFolder<-"UCI HAR Dataset"
dataSetPath<-paste(getwd(),workFolder,dataSetFolder,sep = "/")


downloadData <- function() {
  ## Check if datas folder exists 
  if(!file.exists(workFolder)){
     dir.create(workFolder);
  }
  
  ## Check if we already downlaoded file 
  if(!file.exists(paste(workFolder,dataSetFolder,sep = "/"))) {
    fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    tempZipFile<-paste(workFolder,"/dataSet.zip",sep = "")
    
    download.file(fileUrl, destfile =tempZipFile )
    
    unzip(zipfile = tempZipFile,overwrite = TRUE, exdir = workFolder )
    
    ##Clean temp zip file
    file.remove(tempZipFile)
  } else {
    print("UCI HAR Dataset is available at ...")
    print(dataSetPath)
  }
}

# Activity files
activityTestFile<-paste(dataSetPath,"test","y_test.txt",sep="/")
activityTrainFile<-paste(dataSetPath,"train","y_train.txt",sep="/")

#Features files
featuresTestFile<-paste(dataSetPath,"test","X_test.txt",sep="/")
featuresTrainFile<-paste(dataSetPath,"train","X_train.txt",sep="/")

featureNamesFile<-paste(dataSetPath,"features.txt",sep="/")

##Function to merge two given files
mergeFiles<-function(filea,fileb){
  fa<-read.table(filea, header = FALSE)
  fb<-read.table(fileb, header = FALSE)
  fAb<-rbind(fa,fb)
  fAb
}


## Load test and train Y files ( activity files )
mergeActivityFiles<-function(){
  yTr<-mergeFiles(activityTestFile,activityTrainFile)
  yTr
}

## Laod test and train X files ( features files )
mergeFeatureFiles<-function(){
  xTr<-mergeFiles(featuresTestFile,featuresTrainFile)
  xTr
}

getFeatureNamesFile<-function(){
  fn<-read.table(featureNamesFile, header = FALSE)
  fn
}


extractMeanAndStandard<-function(){
  ## Get feature names 
  features<-mergeFeatureFiles()
  ## Get activity files 
  

  activityFiles<-mergeActivityFiles()
  
  
  #Get names for std dev and mean
  featureNames<-getFeatureNamesFile()
  featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]  

  ##TODO 
    
}