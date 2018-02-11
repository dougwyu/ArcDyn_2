#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to loop through a set of fastq files and run cutadapt, bfc, minimap2, samtools, bedtools
#######################################################################################
#######################################################################################

# Usage: bash _loop_minimap2_20180122.sh

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
	######### loop_minimap2_20180122.bsub ##############################################################################
	#######################################################################################
     ##!/bin/sh
     ##BSUB -q mellanox-ib     #debug, short (24 hours), medium (24 hours), long (168 hours = 7 days)
     ##BSUB -J mnmploop01
     ##BSUB -oo mnmploop01.out
     ##BSUB -eo mnmploop01.err
     ##BSUB -R "rusage[mem=20000]"
     ##BSUB -M 22000
     ##BSUB -B        #sends email to me when job starts
     ##BSUB -N        # sends email to me when job finishes
     ##
     ## . /etc/profile
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


     # bash _loop_minimap2_20180122.sh
     #######################################################################################
     #######################################################################################

# SCRIPT OUTLINE:
	# make list of folders
  # loop through folder name to get $FOLDER
  # get name for $SAMPLEname
  # move fastq files to a working folder
  # run trim_galore, minimap2, and samtools view -b, samtools sort, samtools index, and samtools flagstat
  # move the outputs to minimap2_outputs
	# rm working folder
  # next folder

PIPESTART=$(date)

# upload _loop_minimap2_20180122.sh *into* folder that contains the sample folders that i want to map
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
     echo "**** copying fastq.gz files to working folder"
     cp ${FOLDER}/*.fastq.gz "_${sample}_working/"
     echo "**** fastq.gz files moved to working folder"
     cd _${sample}_working; # pwd

     #### denoise using bfc ####
     # echo "**** start of bfc denoising"
     # bfc -s 3g -t26 ${sample}_R1.fastq.gz | gzip -1 > ${sample}_bfc_R1.fastq.gz  # set to 26 threads b/c mellanox-ib has 28 cores avail
     # bfc -s 3g -t26 ${sample}_R2.fastq.gz | gzip -1 > ${sample}_bfc_R2.fastq.gz
     # echo "**** end of bfc denoising"
     # rm -f ${sample}_R1.fastq.gz
     # rm -f ${sample}_R2.fastq.gz
     #### use trim galore to remove illumina adapters ####
     echo "**** start of adaptor trimming"
     trim_galore --paired ${sample}_R1.fastq.gz ${sample}_R2.fastq.gz
     # alternative more stringent version, not implemented, --length 100 = remove pair if either read ≤ 100 bp (default 20)
     # trim_galore --paired --length 100 --trim-n ${sample}_R1.fastq.gz ${sample}_R2.fastq.gz
     echo "**** end of adaptor trimming"
     # rm -f ${sample}_bfc_R1.fastq.gz
     # rm -f ${sample}_bfc_R2.fastq.gz
     # #### use vsearch to filter the data ####  # i don't think that vsearch filtering helps much, so i'm going to omit it
     # echo "**** start of vsearch filtering"
     # vsearch --gzip_decompress -fastq_filter ${sample}_bfc_R1_val_1.fq.gz -fastq_maxee 1.0 -fastqout ${sample}_bfc_trimmed_R1_filtered.fastq
     # vsearch --gzip_decompress -fastq_filter ${sample}_bfc_R2_val_2.fq.gz -fastq_maxee 1.0 -fastqout ${sample}_bfc_trimmed_R2_filtered.fastq
     # echo "**** end of vsearch filtering"

     echo "**** start of minimap2"
     #### minimap2 ####
     # minimap2 using preset for Illumina PE reads and samtools keep only proper pairs
     # minimap2 -ax sr ref.fa read1.fq read2.fq > aln.sam     # paired-end alignment
     # minimap2 -ax sr ~/greenland_2016/2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta ${sample}_R1_val_1.fq.gz ${sample}_R2_val_2.fq.gz | samtools view -b -o ${sample}.bam
     minimap2 -ax sr ~/greenland_2016/2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta ${sample}_R1_val_1.fq.gz ${sample}_R2_val_2.fq.gz | samtools view -b | samtools sort -@27 - -o ${sample}_sorted.bam
     echo "**** end of minimap2"

     samtools index ${sample}_sorted.bam # creates ${sample}_sorted.bam.bai file
     samtools flagstat ${sample}_sorted.bam > ${sample}_sorted.bam.flagstat.txt # basic stats

     # do not need this section because sorting happens above
     # echo "**** start of samtools sort"
     # samtools sort -@27 ${sample}.bam -o ${sample}_sorted.bam
     # echo "**** end of samtools sort"

     echo "**** moving outputs to minimap2_outputs/"
     mv ${sample}_sorted.bam.bai ../minimap2_outputs/
     mv ${sample}_sorted.bam.flagstat.txt ../minimap2_outputs/
     mv ${sample}_sorted.bam ../minimap2_outputs/


     #### bwa Yinqiu code ####
     # # combine the R1 and R2 data into one file
     # cat ${sample}_bfc_trimed_R1_filtered.fastq ${sample}_bfc_trimed_R2_filtered.fastq > ${sample}_bfc_trimed_filtered.fastq
     # rm -f ${sample}_bfc_trimed_R1_filtered.fastq
     # rm -f ${sample}_bfc_trimed_R2_filtered.fastq
     # # index the reference sequences
     # cp ~/greenland_2016/Earlham_soups/2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta .
     # cp ~/greenland_2016/Earlham_soups/2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref_ID.txt .
     # echo "**** start of bwa indexing of 2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta"
     # # uses bwa_0.7.17_r1188
     # bwa index -a is 2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta  # <-a is>   uses the is format, which is appropriate for short genomes, like mitochondria
     # echo "**** end of bwa indexing of 2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta"
     # align the reads and save input to a sam file
     # echo "**** start of bwa mem mapping, and sam to bam conversion of 2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta"
     # # uses bwa_0.7.17_r1188, piped to samtools without making samfile
     # bwa aln 2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta ${sample}_bfc_trimed_filtered.fastq > ${sample}_bfc_trim.sai
     # bwa samse 2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta ${sample}_bfc_trim.sai ${sample}_bfc_trimed_filtered.fastq | gzip -3 > ${sample}_bfc_trim.sam.gz

     #### samtools Yinqiu code ####
     # samtools view -bt 2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref_ID.txt -o ${sample}_bfc_trim.bam ${sample}_bfc_trim.sam.gz
     # samtools view ${sample}_bfc_trim.bam | grep 'XT:A:U' | samtools view -bS -T 2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta - > ${sample}_bfc_trim_uniqueMap.bam
     # mkdir tmp
     # samtools sort -T tmp/tmp.sorted -o ${sample}_bfc_trim_uniqueMap.sorted.bam ${sample}_bfc_trim_uniqueMap.bam
     # samtools index ${sample}_bfc_trim_uniqueMap.sorted.bam
     # samtools idxstats ${sample}_bfc_trim_uniqueMap.sorted.bam > ${sample}_bfc_trim_uniqueMap.sorted.bam_idxstats.txt
     # 	# -b: indicates that the output is BAM
     # 	# -S: indicates that the input is SAM
     # 	# -o: specifies the name of the output file
     # mv ${sample}_uniqueMap.sorted.bam_idxstats.txt ../minimap2_outputs/

     echo "**** end of mapping, sam to bam conversion, and sorting of bam file"
     # cd ../

     cd "${HOMEFOLDER}"
     rm -rf "_${sample}_working" # remove the working directory to make space

done

mv folderlist.txt minimap2_outputs/

echo "Pipeline started at $PIPESTART"
NOW=$(date)
echo "Pipeline ended at   $NOW"
