#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to launch bsub files
#######################################################################################
#######################################################################################

# upload the new shell and bsub files from macOS
# run in macOS, not hpc
# scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/loop_bwa_only_20180417.bsub b042@hpc.uea.ac.uk:~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/
# scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/_loop_bwa_only_20180417.sh b042@hpc.uea.ac.uk:~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/

scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/loop_samtools_only_20180417.bsub b042@hpc.uea.ac.uk:~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/
scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/_loop_samtools_only_20180417.sh b042@hpc.uea.ac.uk:~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/

ssh hpc
interactive
# to use parallel without a pathname in bsub scripts
PATH=$PATH:~/scripts/parallel-20170722/bin/

# cd ~/greenland_2017/platesA2B2/platesA2B2_combined/
# mkdir BWA{01,02,03,04,05,06,07,08,09,10}

############## by hand, copy 1/10 the sample files into each BWA folder

###### MAKE SURE THAT "SAMPLE_*" HAS BEEN CHGED TO "PLATES*" IN THE SHELL SCRIPT

# copy the minimap and samtools shell and bsub scripts into each BWA folder
# BWA_BSUB="loop_bwa_only_20180417.bsub"; echo ${BWA_BSUB}
# BWA_SH="_loop_bwa_only_20180417.sh"; echo ${BWA_SH}
SAMTOOLS_BSUB="loop_samtools_only_20180417.bsub"; echo ${SAMTOOLS_BSUB}
SAMTOOLS_SH="_loop_samtools_only_20180417.sh"; echo ${SAMTOOLS_SH}

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed; ls
# parallel cp ${BWA_BSUB} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp ${BWA_SH} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
parallel cp ${SAMTOOLS_BSUB} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
parallel cp ${SAMTOOLS_SH} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp loop_trimgalore_20180216.bsub BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp _loop_trimgalore_20180216.sh BWA{} ::: 01 02 03 04 05 06 07 08 09 10
ls
# loop_samtools_only_20180417.bsub and _loop_samtools_only_20180417.sh should sort to bottom

# edit the bsub files so that the correct job name will show up (i suppose i could have instead run a job array...)
cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed; ls

# parallel "sed 's/bwaloop01/bwaEF{}/g' BWA{}/${BWA_BSUB} > BWA{}/${BWA_BSUB}_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# parallel "mv BWA{}/${BWA_BSUB}_tmp.bsub BWA{}/${BWA_BSUB}" ::: 01 02 03 04 05 06 07 08 09 10
# head -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/${BWA_BSUB} # check.  should be bwaEF{01,02,...}
# tail -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/${BWA_BSUB} # check.  should be _loop_bwa_only_20180417.sh

parallel "sed 's/samtools01/samtlsEF{}/g' BWA{}/${SAMTOOLS_BSUB} > BWA{}/${SAMTOOLS_BSUB}_tmp" ::: 01 02 03 04 05 06 07 08 09 10
parallel "mv BWA{}/${SAMTOOLS_BSUB}_tmp BWA{}/${SAMTOOLS_BSUB}" ::: 01 02 03 04 05 06 07 08 09 10
head -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/${SAMTOOLS_BSUB} # check.  should have the correct index number
tail -n 1 BWA{01,02,03,04,05,06,07,08,09,10}/${SAMTOOLS_BSUB} # check.  should have the correct samtools shell filename
ls # BWA* folders should now sort to bottom

# parallel "sed 's/trimgal01/trimgal{}/g' BWA{}/loop_trimgalore_20180216.bsub > BWA{}/loop_trimgalore_20180216_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# parallel "mv BWA{}/loop_trimgalore_20180216_tmp.bsub BWA{}/loop_trimgalore_20180216.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# head -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/loop_trimgalore_20180216.bsub # check.  should be samtools11

############# launch bwa scripts #############
cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA01; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA02; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA03; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA04; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA05; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA06; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA07; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA08; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA09; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA10; ls
bsub < ${BWA_BSUB}
bjobs
ls

bjobs | sort -k8  # sort by 8th column:  SUBMIT_TIME

####### launch samtools scripts #######
cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA01; ls
echo "${SAMTOOLS_BSUB}"
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs # should start to see the new bam files

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA02; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs # should start to see the new bam files

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA03; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs # should start to see the new bam files

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA04; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs # should start to see the new bam files

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA05; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs # should start to see the new bam files

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA06; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs # should start to see the new bam files

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA07; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA08; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA09; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA10; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

bjobs | sort -k8


############# rename bwa_outputs folders #############

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA01; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA02; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA03; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA04; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA05; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA06; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA07; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA08; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA09; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA10; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA11; ls
mv bwa_outputs/ bwa_outputs_bfc/

bjobs

####### launch trimgalore scripts #######
cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA01; ls
bsub < loop_trimgalore_20180216.bsub
bjobs

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA02; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA03; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA04; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA05; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA06; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA07; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA08; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA09; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA10; ls
bsub < loop_trimgalore_20180216.bsub

bjobs | sort -k8
cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA10/PlateF_G10_TCGGATATC-CTTGTA; ls
