# Getting_and_cleaning_data_course_project

The directory  is composed of the data folder with the provided data sets, the run_analysis.R which is the scritp to read the sets merge the training and test sets and then clean and arrange the data set to get the one asked at step 5. Finally, this set is also provided under the name summary_set.txt. 

I - How the script works? 

1) First I read the data sets with the read.table function; but not all of them. I chose not to 
consider data in Inertials as being not relevant to our study. 

2) I row binded <name>.test and <name>.train. The y_sets column names become Activity_Name as refering to activity names
and subject_sets are refered as Subject_Train_ID. 
The X_sets hold all the measures about various variable described in the features sets. 

3) I cleaned the features set by removing digits and letter which were written on a single line and had no meaning as variables. Then I reshaped the last rows (more explained in the comment code). I ended up with 561 values which correspond to our column names in the X_set. 

4) I column binded the y,X and subject sets. 

5) I converted the y set cell values to meaningful names ("WALKING", "LAYING", ...) writting a small replacement loop. 

6) Then I extracted all the column with [Mm]ean/std names using regex. 
Thus, the first set was created as combined_set. 

7) Finally, I used dply functions group_by, summarize_each and pipes to return the mean of each column per activity per subject. And it's saved as summary_set. 

