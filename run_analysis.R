
# set working directory
setwd("C:/Users/User/Documents/coursera/Cleaning_data/Assignment_4/UCI HAR Dataset")

# common variables

act_labels = read.table("./activity_labels.txt") # 6 labels
features =  read.table("./features.txt") # 561 rows

# training set
subject_train = read.table("./train/subject_train.txt") #subject number for each observation n=7352
x_train=read.table("./train/X_train.txt") # nrow = 7352 ncol=561
y_train= read.table("./train/y_train.txt") # type of activity for each measure nrow=7352 goes from 1:6


# it adds names to the columns to facilitate Step 4
colnames(subject_train) = "subject"
colnames(x_train)= features[,2]
colnames(y_train)= "activity_type"

training_set = cbind(subject_train, x_train, y_train)


# test set
subject_test = read.table("./test/subject_test.txt") #subject number for each observation n=2947
x_test=read.table("./test/X_test.txt") # nrow = 2947 ncol=561
y_test= read.table("./test/y_test.txt") # type of activity for each measure nrow=7352 goes from 1:6

# it adds names to the columns to facilitate Step 4
colnames(subject_test) = "subject"
colnames(x_test)= features[,2]
colnames(y_test)= "activity_type"

test_set = cbind(subject_test, x_test, y_test)

# Step 1. Merge data sets

final_set = rbind(training_set, test_set)

# Step 2. Extracts only the measurements on the mean and standard deviation for each measurement.

extrValuesmean = grep("-(mean|std)\\(\\)",features[,2]) # col indexes with mean or std on them

mean_final_set = final_set[,c(1, extrValuesmean+1)]; # adds 1 since column 1 it is Subject


# Step 3. Uses descriptive activity names to name the activities in the data set

mean_final_set[,ncol(mean_final_set)+1]=act_labels[final_set[,563],2]


# Step 4. Appropriately labels the data set with descriptive variable names

colnames(mean_final_set)[68]="Activity"

# Step 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.

library(plyr)

summary_data = ddply(mean_final_set,.(subject,Activity), function(x) colMeans(x[,2:67]))

write.table(summary_data, "summary_data.txt", row.name=TRUE)



