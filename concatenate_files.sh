#!/bin/bash

#SBATCH -A b2011053
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 02:30:00
#SBATCH -J one_file_test_ungulate

#This Bash script concatenates several fastq files from the same sequenced individual into one (each 
#individual sample was split and run in different lanes on Illumina HiSeq and on different days). 

for dir in P*
do

#Go to directory of individual
cd ${dir}

#Collect files from different level subdirectories to same directory
mv */*.gz .
mv */*/*.gz .
mv */*/*/*.gz .

gunzip *.gz

#Check number of lines in original files
wc -l *.fastq | tail -n 1 > lineComp_${dir}

#Concatenate files
cat *.fastq >> ${dir}
rm *.fastq
mv ${dir} ${dir}.fastq

#Check number of lines in new file, for comparison
wc -l *.fastq | tail -n 1 >> lineComp_${dir}
cd ..

done

#Create file to check that script got to this point
touch Granatapple
