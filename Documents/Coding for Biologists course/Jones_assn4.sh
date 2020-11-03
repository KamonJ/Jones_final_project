#!/bin/bash

###### If/then loop example:
#echo What is the correct value of x?"

#read x

#if [ $x = 5 ]; then
        #echo "equals 5"
#else echo "does not equal 5"
#fi


###### Create new file 
touch voter_file1


###### copy possible_voters.txt file to a new file
cp possible_voters.txt voter_file1


###### Remove second column from voter_file1 and remove heading, send to a new file 
cut -f 2 voter_file1 | grep -v "Age(years)" > voter_file2


###### If/then loop voter test:
#echo "Enter age to determine voter eligibility:"

#read age

#if [ "$age" -gt "17" ]; then
	#echo "Yes"
#else echo "No"
#fi


###### Write while-read loop with if/then loop inside
COUNTER=0

while read line
do
	if [[ "$line" -gt "17" ]]; then
	echo "Yes"
else echo "No"
fi
let COUNTER=COUNTER+1
done < voter_file2 > voter_file3 #send results to a new file


###### Give voter_file3 column a title
echo -e "Eligible?" | cat - voter_file3 > voter_file4 #Send updated column to a new file 


###### Combine voter_file4 column to voter_file1 column
paste voter_file1 voter_file4 > voter_file5 #Send combined files to a new file


###### Print the first 10 lines of the orginal file and new file to STDOUT. Use for-loop to print to STDOUT
for line in possible_voters.txt 
do
	echo -e "First 10 Lines of Original File:\n" 
	head -n 10 $line 
done

echo -e "\n\n" # Add spacing to keep your code output(STDOUT) neat and uncluttered

for line in voter_file5
do
	echo -e "First 10 Lines of New File:\n"
	head -n 10 $line
done

echo -e "\n" #Add spacing to keep your code output(STDOUT) neat and uncluttered


###### Print the total number of eligible voters in data set

#for line in voter_file3              #First, find the number of eligible voters using a for-loop. Once correct value is found, remove for-loop from the final code
#do
	#grep Yes $line | wc -w 
#done 

VOTER=$(grep Yes voter_file3 | wc -w) #Next, print the number of voters to STDOUT. Use an array to add eligible voter number to the echo command

echo  "There are $VOTER eligible voters!" 

###### Remove unnecessary files

for line in {1,2,3,4}
do
	rm voter_file$line
done

