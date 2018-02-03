#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to launch bsub files
#######################################################################################
#######################################################################################

############# launch minimap2 scripts #############

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA01; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA02; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA03; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA04; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA05; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA06; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA07; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA08; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA09; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA10; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

bjobs | sort -k8  # sort by 8th column:  SUBMIT_TIME

####### launch samtools_noSORT scripts #######
cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA01
bsub < loop_samtools_only_20180123.bsub
bjobs

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA02
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA03
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA04
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA05
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA06
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA07
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA08
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA09
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA10
bsub < loop_samtools_only_20180123.bsub

bjobs | sort -k8

############# rename minimap2_outputs folders #############

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA01; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA02; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA03; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA04; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA05; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA06; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA07; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA08; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA09; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA10; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA11; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

bjobs
