#!/bin/bash
set -e
set -u
set -o pipefail
##################################################################################################
##################################################################################################
# a shell script to loop through a set of fastq files and give a fastqc result for each fastq file
##################################################################################################
##################################################################################################

# Usage: bash _loop_fastqc_20180202.sh

# Interactive procedure:  run these commands before running _loop_fastqc_20180202.sh interactively
# interactive
module load java/jdk1.8.0_51
# upload _loop_fastqc_20180202.sh into enclosing folder (e.g. greenland_2016/platesAB_Earlham_soups/)

# Batch procedure:  bsub script and submit to long-lm queue
	#######################################################################################
	#######################################################################################
	#!/bin/sh
	#BSUB -q long     #debug, short (24 hours), medium (24 hours), long (168 hours = 7 days)
	#BSUB -J fastqc
	#BSUB -oo fastqc.out
	#BSUB -eo fastqc.err
	#BSUB -R "rusage[mem=12000]"
	#BSUB -M 12000
	#BSUB -B        #sends email to me when job starts
	#BSUB -N        # sends email to me when job finishes
	#
	# . /etc/profile
	# module purge
	# module load java/jdk1.8.0_51
	# bash _loop_fastqc_20180202.sh
	#######################################################################################
	#######################################################################################

# PLAN:
	# make list of folders
  # loop through folder name to get $FOLDER

# PATHS
PATH=$PATH:~/scripts/parallel-20170722/bin/ # GNU Parallel
PATH=$PATH:~/scripts/FastQC/

# set variables
PIPESTART=$(date)
HOMEFOLDER=$(pwd)
echo "Home folder is ${HOMEFOLDER}"
INDEX=1


# read in folder list and make a bash array
find * -maxdepth 1 -type d -name "Sample_*" > QCfolderlist.txt  # find all folders starting with "Sample*"
     # less QCfolderlist.txt
     # tail QCfolderlist.txt
     # wc -l QCfolderlist.txt
sample_info=QCfolderlist.txt # put QCfolderlist.txt into variable
sample_names=($(cut -f 1 "$sample_info" | sort | uniq)) # convert variable to array this way
# echo ${sample_names[@]} # echo all array elements
echo "There are" ${#sample_names[@]} "folders that will be processed." # echo number of elements in the array

# this is the parallel version, successfully tested on 20180203 in platesGH/platesGH_combined/
cd "${HOMEFOLDER}" || exit
# parallel --progress "echo Now on species {1} of ${#sample_names[@]}; fastqc {1}/*.fq.gz" ::: "${sample_names[@]}"
# originally fastq.gz, but now that i have left behind only the trimmed versions, the filenames end in fq.gz

parallel --progress "echo Now on species {1} of ${#sample_names[@]}; fastqc {1}/*.fq.gz" ::: "${sample_names[@]}"
# for lane 11 of PlatesA2B2, i run on the original downloaded files

# this is the loop version, tested and working
# for sample in "${sample_names[@]}"  # ${sample_names[@]} is the full bash array
# do
# 	cd "${HOMEFOLDER}" || exit
# 	echo "Now on species" ${INDEX} of ${#sample_names[@]}". Moved back to starting directory:"
# 	INDEX=$((INDEX+1))
# 	FOLDER="${sample}" # this sets the folder name to the value in the bash array (which is a list of the folders)
# 	echo "**** Working folder is" ${FOLDER}
#
# 	cd ${FOLDER}
#
# 	fastqc *.fastq.gz
# done