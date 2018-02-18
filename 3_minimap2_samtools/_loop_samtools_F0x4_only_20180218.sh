#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# an interactive shell script to loop through a set of bam files and run samtools to remove unmapped reads
#######################################################################################
#######################################################################################

# Interactive procedure:
     # interactive -x -R "rusage[mem=35000]" -M 35000  # alternative is:  interactive -q interactive-lm
     module load samtools # samtools 1.5
     PATH=$PATH:~/scripts/parallel-20170722/bin/

# SCRIPT OUTLINE:
     # move the files that are not to be filtered into a separate folder.  The difficulty here is that "sorted.bam" shows up in a lot of filenames, so i need to hide most of the files from the find command
     # make array of the bam files to be filtered
     # run the samtools -F 0x4 filter
     # calculate index and idxstats.txt
     # remove original bam files by hand in Transmit
     # restore other files back to original folder

# cd into the correct plate/ and then run the generic code below
# AB
cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/minimap2_all_outputs_COIBarcode_PlatesAB
# A2B2
cd ~/greenland_2017/platesA2B2/platesA2B2_combined/minimap2_all_outputs_COIBarcode_PlatesA2B2
# EF
cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/minimap2_all_outputs_COIBarcode_PlatesEF
# GH
cd ~/greenland_2017/platesGH/platesGH_combined/minimap2_all_outputs_COIBarcode_PlatesGH/ # 255G starting size, 6.1G ending size
### THEN RUN THE GENERIC CODE BELOW

# move non-target files to bambai_idxstats/ folder
mkdir bambai_idxstats
ls
cp *sorted.bam.bai bambai_idxstats/
ls *sorted.bam.bai | wc -l
ls bambai_idxstats/*sorted.bam.bai | wc -l
# rm -f *sorted.bam.bai
ls

cp *sorted.bam_idxstats.txt bambai_idxstats/
ls *sorted.bam_idxstats.txt | wc -l
ls bambai_idxstats/*sorted.bam_idxstats.txt | wc -l
# rm -f *sorted.bam_idxstats.txt
ls *sorted.bam_idxstats.txt | wc -l

cp *q*_sorted.bam bambai_idxstats/  # takes a long time
ls *q*_sorted.bam | wc -l
ls bambai_idxstats/*q*_sorted.bam | wc -l
# rm -f *q*_sorted.bam
ls *q*_sorted.bam | wc -l

cp *genomecov*txt.gz bambai_idxstats/
ls *genomecov*txt.gz | wc -l
ls bambai_idxstats/*genomecov*txt.gz | wc -l
# rm -f *genomecov*txt.gz
ls *genomecov*txt.gz | wc -l

cp *flagstat.txt bambai_idxstats/
ls *flagstat.txt | wc -l
ls bambai_idxstats/*flagstat.txt | wc -l
# rm -f *flagstat.txt
ls *flagstat.txt | wc -l


ls         # check if any other files are in the directory; should only have the original sorted.bam files now
ls Sample_*_sorted.bam
ls Sample_*_sorted.bam | wc -l  # count them

# read in folder list and make a bash array
find * -maxdepth 0 -name "Sample_*_sorted.bam" > folderlist.txt  # find all folders (-type d) starting with "Sample*"
sed 's/_sorted.bam//g' folderlist.txt > folderlist_test.txt
mv folderlist_test.txt folderlist.txt
sample_info=folderlist.txt # put folderlist.txt into variable.
less folderlist.txt
sample_names=($(cut -f 1 "$sample_info" | uniq)) # convert variable to array this way
echo "${sample_names[@]}" # echo all array elementsq
echo "There are" ${#sample_names[@]} "folders that will be processed." # echo number of elements in the array

# GNU parallel version
parallel --progress samtools view -b -F 0x4 {}_sorted.bam -o {}_F0x4_sorted.bam ::: "${sample_names[@]}"
parallel --progress samtools index {}_F0x4_sorted.bam ::: "${sample_names[@]}" # creates ${sample}_F0x4_sorted.bam.bai file
# i don't want this flagstat info.  i want the one run on the original bam file unfiltered because i want the total number of reads
# this is here only to have.  note that i need to quote the ">" in order to make this run properly under GNU parallel
# parallel --progress samtools flagstat {}_F0x4_sorted.bam ">" {}_F0x4_sorted.bam.flagstat.txt ::: "${sample_names[@]}" # basic stats

#### THEN REMOVE the original Sample*_sorted.bam files by hand in Transmit, just to be safest

# finally, move everything out of the bambai_idxstats folder
cd bambai_idxstats
ls
mv * ../
cd ..; ls bambai_idxstats



#### loop version:  REPLACED BY THE GNU PARALLEL CODE
# INDEX=1 # set variable
#
# for sample in "${sample_names[@]}"  # ${sample_names[@]} is the full bash array
# do
#      echo "Start of Sample" ${INDEX} of ${#sample_names[@]}
#
#      FOLDER="${sample}" # this sets the folder name to the value in the bash array (which is a list of the folders)
#
#      echo "**** Working folder is" $FOLDER
#
#      # #### samtools filtering pipeline using -F 0x4  ####
#      #      # samtools view -F 0x4 # exclude UNMAP unmapped reads
#      #      # see https://broadinstitute.github.io/picard/explain-flags.html;  see also https://www.biostars.org/p/256448/
#      samtools view -b -F 0x4 ${sample}_sorted.bam -o ${sample}_F0x4_sorted.bam
#      samtools index ${sample}_F0x4_sorted.bam # creates ${sample}_F0x4_sorted.bam.bai file
#      samtools flagstat ${sample}_F0x4_sorted.bam > ${sample}_F0x4_sorted.bam.flagstat.txt # basic stats
#
#      echo "End of Sample" ${INDEX} of ${#sample_names[@]}
#      INDEX=$((INDEX+1))
# done
#
