#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to copy idx and genomcov files into a directory to be downloaded to my computer
# run after running the samtools script, does not have to be uploaded to hpc
#######################################################################################
#######################################################################################

ssh hpc
interactive
# to use parallel without a pathname in bsub scripts
PATH=$PATH:~/scripts/parallel-20170722/bin/

# FILTER="F2308"
OUTPUTFOLDER="minimap2_outputs"

####### cd into different folders and set up output folders to hold everything before running
####### the generic copy script below
# A2B2
PLATE="A2B2"
WORKINGPATH="$HOME/ArcDyn/Plates${PLATE}/Plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
mkdir ${OUTPUTFOLDER}_Plates${PLATE}/
ls
ls ${OUTPUTFOLDER}_Plates${PLATE}/
# ls BWA*/*.out # don't know what this is for
# then jump down and run the GENERIC CODE below

# AB # different scripts because the pathnames are different
PLATE="AB"
WORKINGPATH="$HOME/ArcDyn/Plates${PLATE}/Plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
mkdir ${OUTPUTFOLDER}_Plates${PLATE}/
ls
ls ${OUTPUTFOLDER}_Plates${PLATE}/
# then jump down and run the GENERIC CODE below

# EF
PLATE="EF"
WORKINGPATH="$HOME/ArcDyn/Plates${PLATE}/Plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
mkdir ${OUTPUTFOLDER}_Plates${PLATE}/
ls
ls ${OUTPUTFOLDER}_Plates${PLATE}/
# then jump down and run the GENERIC CODE below

# GH
PLATE="GH"
WORKINGPATH="$HOME/ArcDyn/Plates${PLATE}/Plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
mkdir ${OUTPUTFOLDER}_Plates${PLATE}/
ls
ls ${OUTPUTFOLDER}_Plates${PLATE}/
# then jump down and run the GENERIC CODE below


####### GENERIC CODE to copy samtools output files to folder:  bwa_all_outputs_Plates${PLATE}/ #######
####### This folder is then downloaded to my laptop to process with R:  idxstats_tabulate_macOS_Plates*.Rmd
####### Run once for each library:  A2B2, AB, EF, GH

# choose filters and minimum mapping quality scores
FILTER1="F2308_f0x2" # filter 1
FILTER2="F2308" # filter 2
echo $FILTER1
echo $FILTER2
QUAL1=""; echo $QUAL1 # set to "" if i don't want to use this variable for, say, q1
QUAL2=48; echo $QUAL2

echo $PLATE # check that i'm going to the right folder
echo $OUTPUTFOLDER

# copy output files into bwa_all_outputs_Plates${PLATE}/
# e.g. Sample_IPO3916_C5_F2308_f0x2_q60_sorted.bam_idxstats.txt
parallel ls -l BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted.bam_idxstats.txt ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2}
parallel ls BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted.bam_idxstats.txt ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2} | wc -l # 384 = 2 X 192
parallel cp BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted.bam_idxstats.txt ${OUTPUTFOLDER}_Plates${PLATE}/ ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2}
ls ${OUTPUTFOLDER}_Plates${PLATE}/*_q*_sorted.bam_idxstats.txt | wc -l # 384 = 2 X 192
ls ${OUTPUTFOLDER}_Plates${PLATE}/
cp BWA*/${OUTPUTFOLDER}/*_sorted.bam.flagstat.txt ${OUTPUTFOLDER}_Plates${PLATE}/
ls ${OUTPUTFOLDER}_Plates${PLATE}/

# e.g. Sample_IPO3916_C5_F2308_f0x2_q1_sorted_genomecov_d.txt.gz
parallel ls -l BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted_genomecov_d.txt.gz ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2}
parallel ls -l BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted_genomecov_d.txt.gz ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2} | wc -l # 384 = 2 X 192
parallel cp BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted_genomecov_d.txt.gz ${OUTPUTFOLDER}_Plates${PLATE}/ ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2}
parallel ls ${OUTPUTFOLDER}_Plates${PLATE}/*_{1}_q{2}_sorted_genomecov_d.txt.gz ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2} | wc -l # 384 = 2 X 192
ls ${OUTPUTFOLDER}_Plates${PLATE}/

# rename, tar, and gzip for download
MAPDATE="20190115"
du -sh ${OUTPUTFOLDER}_Plates${PLATE}/ # ~4.9 GB
# set filename to something that i can understand after download
# format:  outputs_PlatesAB_F2308_f0x2_q48_minimap2_outputs_20180727.tar.gz
mv ${OUTPUTFOLDER}_Plates${PLATE} outputs_Plates${PLATE}_${FILTER1}_q${QUAL2}_${OUTPUTFOLDER}_${MAPDATE}
ls
# tar gzip for download
tar -czvf outputs_Plates${PLATE}_${FILTER1}_q${QUAL2}_${OUTPUTFOLDER}_${MAPDATE}.tar.gz outputs_Plates${PLATE}_${FILTER1}_q${QUAL2}_${OUTPUTFOLDER}_${MAPDATE}/
ls
rm -rf outputs_Plates${PLATE}_${FILTER1}_q${QUAL2}_${OUTPUTFOLDER}_${MAPDATE}/
ls


# when i'm on a fast network, i can download using scp, but otherwise, use Transmit for robustness
### 2016 run:  AB ###
# on macOS
# download bwa_all_outputs_PlatesAB/
# scp b042@hpc.uea.ac.uk:~/ArcDyn/PlatesAB/PlatesAB_combined/bwa_all_outputs_Plates${PLATE}_${FILTER}.tar.gz  ~/Dropbox/Working_docs/Roslin_Greenland/2016/bulk_samples/PlatesAB_EI_20160512/
#
# cd /Users/Negorashi2011/Dropbox/Working_docs/Roslin_Greenland/2016/bulk_samples/PlatesAB_EI_20160512/
#
# scp b042@hpc.uea.ac.uk:~/ArcDyn/platesEF/PlatesEF_combined/fastqc_completed/bwa_all_outputs_PlatesEF_F2308_COIBarcode.tar.gz  ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/PlatesEF/
#
# cd ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/PlatesEF/
