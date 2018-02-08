#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to copy idx and genomcov files into a directory to be downloaded to my computer
#######################################################################################
#######################################################################################

QSCORE=1
PLATE="GH"

cd /gpfs/home/b042/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine
mkdir minimap2_all_outputs_PlatesAB/ # rm -rf minimap2_all_outputs/
# rm -rf minimap2_all_outputs/

cd greenland_2017/plates${PLATE}_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed
mkdir minimap2_all_outputs_Plates${PLATE}/

cd ~/greenland_2017/plates${PLATE}/plates${PLATE}_combined/
mkdir minimap2_all_outputs_Plates${PLATE}/
ls

# e.g. Sample_IPO3916_C5_F2308_f0x2_q60_sorted.bam_idxstats.txt
ls BWA*/minimap2_outputs/*_F2308_f0x2_q${QSCORE}_sorted.bam_idxstats.txt | wc -l # 192
cp BWA*/minimap2_outputs/*_F2308_f0x2_q${QSCORE}_sorted.bam_idxstats.txt minimap2_all_outputs_Plates${PLATE}/
ls minimap2_all_outputs_Plates${PLATE}/*_F2308_f0x2_q${QSCORE}_sorted.bam_idxstats.txt | wc -l # 192
ls minimap2_all_outputs_Plates${PLATE}

# e.g. Sample_IPO3916_C5_F2308_f0x2_q1_sorted_genomecov_d.txt.gz
ls BWA*/minimap2_outputs/*_F2308_f0x2_q${QSCORE}_sorted.bam_idxstats.txt | wc -l # 192
cp BWA*/minimap2_outputs/*_F2308_f0x2_q${QSCORE}_sorted_genomecov_d.txt.gz minimap2_all_outputs_Plates${PLATE}/
ls minimap2_all_outputs_Plates${PLATE}/*_F2308_f0x2_q${QSCORE}_sorted_genomecov_d.txt.gz | wc -l # 192
ls minimap2_all_outputs_Plates${PLATE}

du -sh minimap2_all_outputs_Plates${PLATE}/ # 1.1 GB
tar -czvf minimap2_all_outputs_Plates${PLATE}.tar.gz minimap2_all_outputs_Plates${PLATE}/

scp b042@hpc.uea.ac.uk:~/greenland_2017/platesA2B2/plates${PLATE}_combined/minimap2_all_outputs_Plates${PLATE}.tar.gz ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/Plates${PLATE}

cd ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/PlatesA2B2
# download minimap2_all_outputs_PlatesAB/
