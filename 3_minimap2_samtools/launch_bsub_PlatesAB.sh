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

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA01; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA02; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA03; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA04; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA05; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA06; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA07; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA08; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA09; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA10; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA11; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls


####### launch samtools_noSORT scripts #######
cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA01
bsub < loop_samtools_only_20180123.bsub
bjobs

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA02
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA03
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA04
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA05
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA06
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA07
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA08
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA09
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA10
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA11
bsub < loop_samtools_only_20180123.bsub

bjobs


############# rename minimap2_outputs folders #############

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA01; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA02; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA03; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA04; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA05; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA06; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA07; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA08; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA09; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA10; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA11; ls
mv minimap2_outputs/ minimap2_outputs_bfc/

bjobs
