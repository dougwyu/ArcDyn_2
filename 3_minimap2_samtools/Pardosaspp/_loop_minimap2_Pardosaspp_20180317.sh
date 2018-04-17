#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to loop through a set of fastq files and run cutadapt, minimap2, samtools, bedtools
#######################################################################################
#######################################################################################

# Usage: bash _loop_minimap2_Pardosaspp_20180317.sh
# this version uses the Pardosa_spp.fas reference fasta

# Batch procedure:  bsub script and submit to mellanox-ib queue
     ######### _loop_minimap2_only_20180226.bsub ##############################################################################
     #######################################################################################
     # #!/bin/sh
     # #BSUB -q short-ib     #long-ib & mellanox-ib (168 hours = 7 days), short-ib (24 hours)
     # #BSUB -J mnmploop01
     # #BSUB -oo mnmploop01.out
     # #BSUB -eo mnmploop01.err
     # #BSUB -R "rusage[mem=125000]"  # set at 125000 for the max (n.b. short-ib, long-ib, mellanox-ib)
     # #BSUB -M 125000
     # #BSUB -x
     # #BSUB -x # exclusive access to node, should be in anything that is threaded
     # #BSUB -B        #sends email to me when job starts
     # #BSUB -N        # sends email to me when job finishes
     #
     # . /etc/profile
     # module purge
     # module load samtools # samtools 1.5
     # module load python/anaconda/4.2/2.7 # Python 2.7.12
     # module load java  # java/jdk1.8.0_51
     # module load gcc # needed to run bedtools
     # PATH=$PATH:~/scripts/cutadapt-1.11/build/scripts-2.7
     # PATH=$PATH:~/scripts/bwa_0.7.17_r1188 # made 22 Jan 2018 from github
     # PATH=$PATH:~/scripts/bfc/ # r181 # made 3 Aug 2015 from github
     # PATH=$PATH:~/scripts/vsearch-2.6.2-linux-x86_64/bin/ # downloaded 22 Jan 2018 from github
     # PATH=$PATH:~/scripts/TrimGalore-0.4.5/ # downloaded 22 Jan 2018 from github
     # PATH=$PATH:~/scripts/minimap2/  # made 22 Jan 2018 from github 2.7-r659-dirty
     # PATH=$PATH:~/scripts/bedtools2/bin # made 22 Jan 2018 from github 2.27.1
     #
     #
     # bash _loop_minimap2_Pardosaspp_20180317.sh
     #######################################################################################
     #######################################################################################

# SCRIPT OUTLINE:
     # make list of folders
     # loop through folder names for each SAMPLE
     # move trimmed fastq files from $SAMPLE name folder to a working folder
     # run minimap2, and samtools view -b, samtools sort, samtools index, and samtools flagstat
     # move the outputs to spp
     # rm working folder
     # next folder

PIPESTART=$(date)

# upload _loop_minimap2_only_20180216.sh *into* folder that contains the sample folders that i want to map
# when i have lots of sample files, i break it up by putting the sample files into BWA**/ folders and running these scripts inside each one
HOMEFOLDER=$(pwd) # this sets working directory to that folder

echo "Home folder is ${HOMEFOLDER}"

# set variables
INDEX=1
if [ ! -d pardosa_spp_outputs ] # if directory spp does not exist.  this is within the HOMEFOLDER
then
	mkdir pardosa_spp_outputs
fi

# read in folder list and make a bash array
# run inside each BWA folder
##### for Plates E and F, the folders are called Plate{E,F}*, so i need to change "Sample_*" to "Plate*"
find * -maxdepth 0 -type d -name "Sample_*" > folderlist.txt  # find all folders (-type d) starting with "Sample*"
sample_info=folderlist.txt # put folderlist.txt into variable
sample_names=($(cut -f 1 "$sample_info" | uniq)) # convert variable to array this way
# echo "${sample_names[@]}" # echo all array elements
echo "There are" ${#sample_names[@]} "folders that will be processed." # echo number of elements in the array

for sample in "${sample_names[@]}"  # ${sample_names[@]} is the full bash array
do
     cd "${HOMEFOLDER}"
     echo "Now on Sample" ${INDEX} of ${#sample_names[@]}". Moved back to starting directory $(date):"
     INDEX=$((INDEX+1))
     # pwd
     FOLDER="${sample}" # this sets the folder name to the value in the bash array (which is a list of the folders)

     echo "**** Working folder is" $FOLDER

     mkdir _${sample}_working

     echo "**** copying trimmed fastq.gz files to working folder $(date)"
     cp ${FOLDER}/${sample}_R1_val_1.fq.gz "_${sample}_working/"
     cp ${FOLDER}/${sample}_R2_val_2.fq.gz "_${sample}_working/"
     echo "**** trimmed fastq.gz files moved to working folder $(date)"
     cd _${sample}_working; # pwd

     echo "**** start of minimap2, sam to bam conversion, sorting of bam file $(date)"
     #### minimap2 ####

     # against 1712 Pardosa spp barcodes dereplicated
     minimap2 -ax sr ~/greenland_2017/reference_seqs/Pardosa_spp_derep.fas ${sample}_R1_val_1.fq.gz ${sample}_R2_val_2.fq.gz | samtools view -b | samtools sort -@27 - -o ${sample}_sorted.bam

     echo "**** end of minimap2, sam to bam conversion, sorting of bam file $(date)"

     # calculate flagstats
     samtools flagstat ${sample}_sorted.bam > ${sample}_sorted.bam.flagstat.txt # basic stats

     # echo "**** start of samtools filtering of unmapped reads $(date)"
     # filter out unmapped reads and delete original sorted.bam
     samtools view -b -F 0x4 ${sample}_sorted.bam > ${sample}_F0x4_sorted.bam
     rm -f ${sample}_sorted.bam
     samtools index ${sample}_F0x4_sorted.bam # creates ${sample}_F0x4_sorted.bam.bai file
     echo "**** end of samtools filtering of unmapped reads $(date)"

     echo "**** start of moving outputs to pardosa_spp_outputs/ $(date)"
     mv ${sample}_sorted.bam.flagstat.txt ../pardosa_spp_outputs/
     mv ${sample}_F0x4_sorted.bam.bai ../pardosa_spp_outputs/
     mv ${sample}_F0x4_sorted.bam ../pardosa_spp_outputs/
     echo "**** end of moving outputs to pardosa_spp_outputs/ $(date)"

     cd "${HOMEFOLDER}"
     rm -rf "_${sample}_working" # remove the working directory to make space

done

mv folderlist.txt pardosa_spp_outputs/

echo "Pipeline started at $PIPESTART"
NOW=$(date)
echo "Pipeline ended at   $NOW"
