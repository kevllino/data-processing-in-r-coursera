##we'll need some functions found in the dplyr package
library(dplyr)

##getting the needed datasets
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train<- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.csv("./data/UCI HAR Dataset/features.txt",header=F)

##merge training and test sets
subject_set <- rbind(subject_train, subject_test)
X_set <-  rbind(X_train, X_test)
y_set <-  rbind(y_train, y_test)

##change column names into more explicit ones
colnames(subject_set) <- "Subject_Train_ID"
colnames(y_set) <- "Activity_Name"

##assign the colnames from the features set to combined_set variables
##the combined_set has 561 variables (except the first 2 columns), the feature set has 769 of them
##so we need to clean it by removing lonely digits/letters in a row 
clnFeatures <- features$V1[!grepl("^([0-9]|[a-zA-Z]){1,2}$",features$V1)]
clnFeatures <- as.data.frame(clnFeatures,header= F)

##then we "reshape" the inconsistent last rows 
clnFeatures$clnFeatures <- as.character(clnFeatures$clnFeatures)##we need to convert it to a char vector first
alo1 <- paste0(clnFeatures$clnFeatures[555],clnFeatures$clnFeatures[556])
clnFeatures$clnFeatures[555] <- alo1
alo2 <- paste0(clnFeatures$clnFeatures[557],clnFeatures$clnFeatures[558])
clnFeatures$clnFeatures[557] <- alo2
alo3 <- paste0(clnFeatures$clnFeatures[560],clnFeatures$clnFeatures[561])
clnFeatures$clnFeatures[560] <- alo3
alo4 <- paste0(clnFeatures$clnFeatures[561],clnFeatures$clnFeatures[562])
clnFeatures$clnFeatures[561] <- alo4
alo5 <- paste0(clnFeatures$clnFeatures[563],clnFeatures$clnFeatures[564])
clnFeatures$clnFeatures[563] <- alo5
alo6 <- paste0(clnFeatures$clnFeatures[565],clnFeatures$clnFeatures[566])
clnFeatures$clnFeatures[565] <- alo6
alo7 <- paste0(clnFeatures$clnFeatures[567],clnFeatures$clnFeatures[568])
clnFeatures$clnFeatures[567] <- alo7

##we remove the inconsistent rows and reconvert the char to vector to a data.frame
cleaned_features <-  clnFeatures$clnFeatures[-c(556,558,560,562,564,566,568)]
cleaned_features <- as.data.frame(cleaned_features) 

##rename columns
colnames(X_set) <- as.character(cleaned_features$cleaned_features) 

##bind the 3 main data sets by column
combined_set <- cbind(y_set,subject_set, X_set)

##replace ids by activity names
activities <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")

for (i in 1:6){
        combined_set$Activity_Name[combined_set$Activity_Name == i ]<- activities[i]
}

##extract variable columns with mean and std
combined_set <- combined_set[,c(1,2,grep("[Mm]ean|std",names(combined_set)))]

##return the mean of each column per activity per subject  
summary_set <- combined_set %>% group_by(Activity_Name,Subject_Train_ID) %>% summarise_each(funs(mean))

##output the dataset at step 5
summary_set
