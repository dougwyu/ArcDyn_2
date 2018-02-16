#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to loop through a set of fastq files and run cutadapt, minimap2, samtools, bedtools
#######################################################################################
#######################################################################################

# Usage: bash _loop_minimap2_only_20180216.sh

# Interactive procedure:  first run these commands if running _loop_minimap2_20180122.sh interactively
     # interactive -x -R "rusage[mem=20000]" -M 22000  # alternative is:  interactive -q interactive-lm
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

# Batch procedure:  bsub script and submit to mellanox-ib queue
     ######### _loop_minimap2_only_20180216.bsub ##############################################################################
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
     # bash _loop_minimap2_only_20180216.sh
     #######################################################################################
     #######################################################################################

# SCRIPT OUTLINE:
     # make list of folders
     # loop through folder names for each SAMPLE
     # move trimmed fastq files from $SAMPLE name folder to a working folder
     # run minimap2, and samtools view -b, samtools sort, samtools index, and samtools flagstat
     # move the outputs to minimap2_outputs
     # rm working folder
     # next folder

PIPESTART=$(date)

# upload _loop_minimap2_only_20180216.sh *into* folder that contains the sample folders that i want to map
# when i have lots of sample files, i break it up by putting the sample files into BWA**/ folders and running these scripts inside each one
HOMEFOLDER=$(pwd) # this sets working directory to that folder

echo "Home folder is ${HOMEFOLDER}"

# set variables
INDEX=1
if [ ! -d minimap2_outputs ] # if directory minimap2_outputs does not exist.  this is within the HOMEFOLDER
then
	mkdir minimap2_outputs
fi

# read in folder list and make a bash array
##### for Plates E and F, the folders are called Plate{E,F}*, so i need to change "Sample_*" to "Plate*"
find * -maxdepth 0 -type d -name "Sample_*" > folderlist.txt  # find all folders (-type d) starting with "Sample*"
sample_info=folderlist.txt # put folderlist.txt into variable
sample_names=($(cut -f 1 "$sample_info" | uniq)) # convert variable to array this way
# echo "${sample_names[@]}" # echo all array elements
echo "There are" ${#sample_names[@]} "folders that will be processed." # echo number of elements in the array

for sample in "${sample_names[@]}"  # ${sample_names[@]} is the full bash array
do
     cd "${HOMEFOLDER}"
     echo "Now on Sample" ${INDEX} of ${#sample_names[@]}". Moved back to starting directory:"
     INDEX=$((INDEX+1))
     # pwd
     FOLDER="${sample}" # this sets the folder name to the value in the bash array (which is a list of the folders)

     echo "**** Working folder is" $FOLDER

     mkdir _${sample}_working

     echo "**** copying trimmed fastq.gz files to working folder"
     cp ${FOLDER}/${sample}_R1_val_1.fq.gz "_${sample}_working/"
     cp ${FOLDER}/${sample}_R2_val_2.fq.gz "_${sample}_working/"
     echo "**** trimmed fastq.gz files moved to working folder"
     cd _${sample}_working; # pwd

     echo "**** start of minimap2"
     #### minimap2 ####
     # minimap2 using preset for Illumina PE reads -x sr and output sam file -a | pipe to samtools sort and output bam file
     # minimap2 -ax sr ref.fa read1.fq read2.fq > aln.sam     # paired-end alignment

     # against 157 mitogenomes and 3 COI_spike barcodes
     minimap2 -ax sr ~/greenland_2016/2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta ${sample}_R1_val_1.fq.gz ${sample}_R2_val_2.fq.gz | samtools view -b | samtools sort -@27 - -o ${sample}_sorted.bam

     # against 410 barcodes and 3 COI_spike barcodes
     # minimap2 -ax sr ~/greenland_2017/CO1_1sequence_perBIN_040915_COIspiking.fas ${sample}_R1_val_1.fq.gz ${sample}_R2_val_2.fq.gz | samtools view -b | samtools sort -@27 - -o ${sample}_sorted.bam
     echo "**** end of minimap2"

     # index and calculate flagstats
     samtools index ${sample}_sorted.bam # creates ${sample}_sorted.bam.bai file
     samtools flagstat ${sample}_sorted.bam > ${sample}_sorted.bam.flagstat.txt # basic stats

     echo "**** moving outputs to minimap2_outputs/"
     mv ${sample}_sorted.bam.bai ../minimap2_outputs/
     mv ${sample}_sorted.bam.flagstat.txt ../minimap2_outputs/
     mv ${sample}_sorted.bam ../minimap2_outputs/

     echo "**** end of mapping, sam to bam conversion, and sorting of bam file"

     cd "${HOMEFOLDER}"
     rm -rf "_${sample}_working" # remove the working directory to make space

done

mv folderlist.txt minimap2_outputs/

echo "Pipeline started at $PIPESTART"
NOW=$(date)
echo "Pipeline ended at   $NOW"
