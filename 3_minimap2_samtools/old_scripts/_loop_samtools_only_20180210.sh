#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to loop through a set of bam files and run samtools, bedtools
#######################################################################################
#######################################################################################

# Usage: bash _loop_samtools_only_20180210.sh

# Interactive procedure:  first run these commands if running _loop_samtools_only_20180123.sh interactively
     # interactive -x -R "rusage[mem=35000]" -M 35000  # alternative is:  interactive -q interactive-lm
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
	######### _loop_samtools_only_20180210.bsub ##############################################################################
	#######################################################################################
     #!/bin/sh
     #BSUB -q short-eth     # short-eth (24 hours), long-eth (168 hours = 7 days)
     #BSUB -J samtools01
     #BSUB -oo samtools01.out
     #BSUB -eo samtools01.err
     #BSUB -R "rusage[mem=35000]"
     #BSUB -M 35000
     #BSUB -x        # for an exclusive machine
     #BSUB -B        #sends email to me when job starts
     #BSUB -N        # sends email to me when job finishes

     # . /etc/profile
     # module purge
     # module load samtools # samtools 1.5
     # module load python/anaconda/4.2/2.7 # Python 2.7.12
     # module load java  # java/jdk1.8.0_51
     # module load gcc # needed to run bedtools
     # PATH=$PATH:~/scripts/minimap2/  # made 22 Jan 2018 from github 2.7-r659-dirty
     # PATH=$PATH:~/scripts/bedtools2/bin # made 22 Jan 2018 from github 2.27.1
     #
     # bash _loop_samtools_only_20180210.sh
     #######################################################################################
     #######################################################################################

# SCRIPT OUTLINE:
	# make list of folders
  # loop through folder name to get $FOLDER
  # get name for $SAMPLEname
  # move fastq files to a working folder
  # run the samtools and bedtools commands
  # move the result to minimap2_outputs
	# rm working folder
  # next folder

PIPESTART=$(date)

# upload _loop_samtools_only_20180210.sh to BWA## folder that contains the bam files that i want to filter
# I don't place the shell script in the minimap2_outputs because it's harder to manage the files
HOMEFOLDER=$(pwd) # this sets working directory to that folder.

echo "Home folder is ${HOMEFOLDER}"
cd "${HOMEFOLDER}"/minimap2_outputs/ || exit  # cd into minimap2_outputs folder

# read in folder list and make a bash array
# find * -maxdepth 0 -type d -name "Sample_*" > folderlist.txt  # find all folders (-type d) starting with "Sample*"
sample_info=folderlist.txt # put folderlist.txt into variable. folderlist.txt should already be in the minimap2_outputs folder
sample_names=($(cut -f 1 "$sample_info" | uniq)) # convert variable to array this way
# echo "${sample_names[@]}" # echo all array elements
echo "There are" ${#sample_names[@]} "folders that will be processed." # echo number of elements in the array

INDEX=1 # set variable

for sample in "${sample_names[@]}"  # ${sample_names[@]} is the full bash array
do
     echo "Start of Sample" ${INDEX} of ${#sample_names[@]}

     FOLDER="${sample}" # this sets the folder name to the value in the bash array (which is a list of the folders)

     echo "**** Working folder is" $FOLDER

     #### minimap2 ####
     # minimap2 using preset for Illumina PE reads and samtools keep only proper pairs
     # minimap2 -ax sr ref.fa read1.fq read2.fq > aln.sam     # paired-end alignment
     # minimap2 -ax sr ~/greenland_2016/2016MayJuneDec_and_8mix2015_greenland_13mtgenes_ref.fasta ${sample}_R1_val_1.fq.gz ${sample}_R2_val_2.fq.gz | samtools view -b -o ${sample}.bam

     #### samtools initial processing of bam file from minimap2:  sort and index
          # original version, but now doing sort in the minimap2 step, previous script
          # samtools sort @24 # 24 threads for sorting
     # samtools sort -@24 ${sample}.bam -o ${sample}_sorted.bam # sort
     # rm -f ${sample}.bam  # don't need the original bam file

     # these commands moved to _loop_minimap2_20180122.sh because they only need to be done once per sorted.bam file
     # samtools index ${sample}_sorted.bam # creates ${sample}_sorted.bam.bai file
     # samtools flagstat ${sample}_sorted.bam > ${sample}_sorted.bam.flagstat.txt # basic stats
     # samtools view ${sample}_sorted.bam | head # to view the sorted bam file

     #### samtools filtering pipeline using -F 2308 -q 1 ####
          # samtools view -F 2308 # exclude UNMAP,SECONDARY,SUPPLEMENTARY # exclude unmapped, secondary, and supplementary alignments
          # see https://broadinstitute.github.io/picard/explain-flags.html;  see also https://www.biostars.org/p/256448/
          # samtools view -q 1 # to remove multiply mapped reads = q 0
     # samtools view -b -F 2308 -q 1 ${sample}_sorted.bam -o ${sample}_F2308_q1_sorted.bam
     # samtools index ${sample}_F2308_q1_sorted.bam # creates ${sample}_F2308_q1_sorted.bam.bai file
     # samtools idxstats ${sample}_F2308_q1_sorted.bam > ${sample}_F2308_q1_sorted.bam_idxstats.txt # calculate idxstats
     # bedtools genomecov -d -ibam ${sample}_F2308_q1_sorted.bam | gzip > ${sample}_F2308_q1_sorted_genomecov_d.txt.gz # calc genome cov stats

     #### samtools filtering pipeline using -F 2308 -q 60 ####
          # samtools view -F 2308 # exclude UNMAP,SECONDARY,SUPPLEMENTARY # exclude unmapped, secondary, and supplementary alignments
          # see https://broadinstitute.github.io/picard/explain-flags.html;  see also https://www.biostars.org/p/256448/
          # samtools view -q 1 # to remove multiply mapped reads = q 0
     # samtools view -b -F 2308 -q 60 ${sample}_sorted.bam -o ${sample}_F2308_q60_sorted.bam
     # samtools index ${sample}_F2308_q60_sorted.bam # creates ${sample}_F2308_q60_sorted.bam.bai file
     # samtools idxstats ${sample}_F2308_q60_sorted.bam > ${sample}_F2308_q60_sorted.bam_idxstats.txt # calculate idxstats
     # bedtools genomecov -d -ibam ${sample}_F2308_q60_sorted.bam | gzip > ${sample}_F2308_q60_sorted_genomecov_d.txt.gz # calc genome cov stats

     # #### samtools filtering pipeline using -F 3332 -f 0x2 -q 1 ####
     #      # samtools view -f 0x2 # keep PROPER_PAIR   .. each segment properly aligned according to the aligner
     #      # samtools view -F 3332 # exclude DUP,UNMAP,SECONDARY,SUPPLEMENTARY # exclude PCR duplicates, unmapped, secondary, and supplementary alignments
     #      # see https://broadinstitute.github.io/picard/explain-flags.html;  see also https://www.biostars.org/p/256448/
     #      # samtools view -q 1 # to remove multiply mapped reads = q 0
     # samtools view -b -F 3332 -f 0x2 -q 1 ${sample}_sorted.bam -o ${sample}_F3332_f0x2_q1_sorted.bam
     # samtools index ${sample}_F3332_f0x2_q1_sorted.bam # creates ${sample}_F3332_f0x2_q1_sorted.bam.bai file
     # samtools idxstats ${sample}_F3332_f0x2_q1_sorted.bam > ${sample}_F3332_f0x2_q1_sorted.bam_idxstats.txt # calculate idxstats
     # bedtools genomecov -d -ibam ${sample}_F3332_f0x2_q1_sorted.bam | gzip > ${sample}_F3332_f0x2_q1_sorted_genomecov_d.txt.gz # calc genome cov stats
     #
     # #### samtools filtering pipeline using -F 3332 -f 0x2 -q 60, more stringent ####
     #      # samtools view -f 0x2 # keep PROPER_PAIR   .. each segment properly aligned according to the aligner
     #      # samtools view -F 3332 # exclude DUP,UNMAP,SECONDARY,SUPPLEMENTARY # exclude PCR duplicates, unmapped, secondary, and supplementary alignments
     #      # see https://broadinstitute.github.io/picard/explain-flags.html;  see also https://www.biostars.org/p/256448/
     #      # samtools view -q 60 # to remove multiply mapped reads = q 0, and keep only high quality mappings
     # samtools view -b -F 3332 -f 0x2 -q 60 ${sample}_sorted.bam -o ${sample}_F3332_f0x2_q60_sorted.bam
     # samtools index ${sample}_F3332_f0x2_q60_sorted.bam # creates ${sample}_F3332_f0x2_q60_sorted.bam.bai file
     # samtools idxstats ${sample}_F3332_f0x2_q60_sorted.bam > ${sample}_F3332_f0x2_q60_sorted.bam_idxstats.txt # calculate idxstats
     # bedtools genomecov -d -ibam ${sample}_F3332_f0x2_q60_sorted.bam | gzip > ${sample}_F3332_f0x2_q60_sorted_genomecov_d.txt.gz # calc genome cov stats

     # #### samtools filtering pipeline using -F 3332 -f 0x2 -q 30, middle stringency ####
     #      # samtools view -f 0x2 # keep PROPER_PAIR   .. each segment properly aligned according to the aligner
     #      # samtools view -F 3332 # exclude DUP,UNMAP,SECONDARY,SUPPLEMENTARY # exclude PCR duplicates, unmapped, secondary, and supplementary alignments
     #      # see https://broadinstitute.github.io/picard/explain-flags.html;  see also https://www.biostars.org/p/256448/
     #      # samtools view -q 60 # to remove multiply mapped reads = q 0, and keep only high quality mappings
     samtools view -b -F 3332 -f 0x2 -q 60 ${sample}_sorted.bam -o ${sample}_F3332_f0x2_q60_sorted.bam
     samtools index ${sample}_F3332_f0x2_q60_sorted.bam # creates ${sample}_F3332_f0x2_q60_sorted.bam.bai file
     samtools idxstats ${sample}_F3332_f0x2_q60_sorted.bam > ${sample}_F3332_f0x2_q60_sorted.bam_idxstats.txt # calculate idxstats
     bedtools genomecov -d -ibam ${sample}_F3332_f0x2_q60_sorted.bam | gzip > ${sample}_F3332_f0x2_q60_sorted_genomecov_d.txt.gz # calc genome cov stats

     echo "End of Sample" ${INDEX} of ${#sample_names[@]}
     INDEX=$((INDEX+1))

done

echo "Pipeline started at $PIPESTART"
NOW=$(date)
echo "Pipeline ended at $NOW"
