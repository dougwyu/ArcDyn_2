#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to copy idx and genomcov files into a directory to be downloaded to my computer
#######################################################################################
#######################################################################################

ssh hpc
interactive

### CAREFUL:  i have set this up to copy files of only 1 q-score, here, 1.  if i want to copy 1 and 60, i need to set
# QSCORE="{1,60}" # this needs to be tested.
# the original samtools output files are still in the BWA* folders

QSCORE=1
FILTER="F2308"

####### cd into different folders ########
# AB # different scripts because the pathname is different
PLATE="AB"
WORKINGPATH="$HOME/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/"
cd ${WORKINGPATH}
ls
mkdir minimap2_all_outputs_Plates${PLATE}/; ls # rm -rf minimap2_all_outputs/

# A2B2
PLATE="A2B2"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}/plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
mkdir minimap2_all_outputs_Plates${PLATE}/
ls minimap2_all_outputs_Plates${PLATE}/

# EF
PLATE="EF"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed"
cd ${WORKINGPATH}
ls
mkdir minimap2_all_outputs_Plates${PLATE}/
ls minimap2_all_outputs_Plates${PLATE}/

# GH
PLATE="GH"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}/plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
mkdir minimap2_all_outputs_Plates${PLATE}/
ls minimap2_all_outputs_Plates${PLATE}/


####### copy files to minimap2_all_outputs_Plates${PLATE} #######
# e.g. Sample_IPO3916_C5_F2308_f0x2_q60_sorted.bam_idxstats.txt
ls BWA*/minimap2_outputs/*_${FILTER}_q${QSCORE}_sorted.bam_idxstats.txt
ls BWA*/minimap2_outputs/*_${FILTER}_q${QSCORE}_sorted.bam_idxstats.txt | wc -l # 192
cp BWA*/minimap2_outputs/*_${FILTER}_q${QSCORE}_sorted.bam_idxstats.txt minimap2_all_outputs_Plates${PLATE}/
ls minimap2_all_outputs_Plates${PLATE}/*_${FILTER}_q${QSCORE}_sorted.bam_idxstats.txt | wc -l # 192
ls minimap2_all_outputs_Plates${PLATE}

# e.g. Sample_IPO3916_C5_F2308_f0x2_q1_sorted_genomecov_d.txt.gz
ls BWA*/minimap2_outputs/*_${FILTER}_q${QSCORE}_sorted_genomecov_d.txt.gz | wc -l # 192
cp BWA*/minimap2_outputs/*_${FILTER}_q${QSCORE}_sorted_genomecov_d.txt.gz minimap2_all_outputs_Plates${PLATE}/
ls minimap2_all_outputs_Plates${PLATE}/*_${FILTER}_q${QSCORE}_sorted_genomecov_d.txt.gz | wc -l # 192
ls minimap2_all_outputs_Plates${PLATE}

du -sh minimap2_all_outputs_Plates${PLATE}/ # ~1.1 GB
tar -czvf minimap2_all_outputs_Plates${PLATE}.tar.gz minimap2_all_outputs_Plates${PLATE}/
ls
# rm -rf minimap2_all_outputs_Plates${PLATE}/
ls


# when i'm on a fast network, i can download using scp, but otherwise, use Transmit
### 2016 run:  AB ###
# on macOS
# download minimap2_all_outputs_PlatesAB/
scp b042@hpc.uea.ac.uk:~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/minimap2_all_outputs_PlatesAB.tar.gz  ~/Dropbox/Working_docs/Roslin_Greenland/2016/bulk_samples/PlatesAB_EI_20160512/

cd /Users/Negorashi2011/Dropbox/Working_docs/Roslin_Greenland/2016/bulk_samples/PlatesAB_EI_20160512/
