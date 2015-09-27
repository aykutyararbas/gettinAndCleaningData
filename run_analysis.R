## Activity recognition using  smartphones 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


## Initialize load packages
if(!require("data.table")){
  install.packages("data.table");
}
if(!require("reshape2")){
  install.packages("reshape2")
}


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

##STEP 1. Construct parameters

workFolder<-"datas"
dataSetFolder<-"UCI HAR Dataset"
dataSetPath<-paste(getwd(),workFolder,dataSetFolder,sep = "/")

#Activity labels  file
activityLabelsFile<-paste(dataSetPath,"activity_labels.txt",sep="/")
activityLabelsData<-read.table(activityLabelsFile)
names(activityLabelsData)=c("code","activityName")
#Feature names file
featureNamesFile<-paste(dataSetPath,"features.txt",sep="/")
featureNameData<-read.table(featureNamesFile)

#Extract mean and std from the columns
extract_mean_std<-grepl("mean|std", featureNameData[,2])

# Activity test files
activityTestFile<-paste(dataSetPath,"test","y_test.txt",sep="/")
#Subject test file
subjectTestFile<-paste(dataSetPath,"test","subject_test.txt",sep="/")

#Activity train file
activityTrainFile<-paste(dataSetPath,"train","y_train.txt",sep="/")
#Subjects train file
subjectTrainFile<-paste(dataSetPath,"train","subject_train.txt",sep="/")

#Features test files
featuresTestFile<-paste(dataSetPath,"test","X_test.txt",sep="/")

#Features train files
featuresTrainFile<-paste(dataSetPath,"train","X_train.txt",sep="/")

## END of Construct parameters

##STEP 2 Load data
activityTestData <-read.table(activityTestFile)
activityTrainData <-read.table(activityTrainFile)

subjectTestData<-read.table(subjectTestFile)
subjectTrainData<-read.table(subjectTrainFile)

#Load feature test data
featuresTestData<-read.table(featuresTestFile)
#Load feature train data
featuresTrainData<-read.table(featuresTrainFile)

##STEP 3 Process data
#3. Uses descriptive activity names to name the activities in the data set
names(subjectTestData)=c("subject")
names(featuresTestData) = featureNameData[,2]
names(activityTestData)=c("activity")
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
featuresTestData=featuresTestData[,extract_mean_std]


#3. Uses descriptive activity names to name the activities in the data set
names(subjectTrainData)=c("subject")
names(featuresTrainData) = featureNameData[,2]
names(activityTrainData)=c("activity")
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
featuresTrainData=featuresTrainData[,extract_mean_std]

## Bind subject, activity, and features data
testData<-cbind(subjectTestData,activityTestData,featuresTestData)
trainData<-cbind(subjectTrainData,activityTrainData,featuresTrainData)

## 1. Merges the training and the test sets to create one data set.
allData<-rbind(trainData, testData)

## 4. Appropriately labels the data set with descriptive activity names.
mergedData <- merge(allData,activityLabelsData, by.x = "activity", by.y = "code", all.y = FALSE, sort = TRUE)

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# subject
# activityName
# Average for each variable -- mean
ids   = c("subject", "activity", "activityName")
dataFields = setdiff(colnames(allData), ids)
meltedData  = melt(mergedData, id = ids, measure.vars = dataFields)

#STEP 4 - Construct tidy data and write to file
#independent tidy data set with the average of each variable 
tidyData   = dcast(meltedData, subject + activityName ~ variable, mean)

write.table(tidyData,file = '/data/rspace/gettinAndCleaningData/tidyData.txt')
