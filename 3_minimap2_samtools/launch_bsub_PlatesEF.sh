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
scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_minimap2_samtools/loop_samtools_only_20180219.bsub b042@hpc.uea.ac.uk:~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed

scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_minimap2_samtools/_loop_samtools_only_20180219.sh b042@hpc.uea.ac.uk:~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed

ssh hpc
interactive
# to use parallel without a pathname in bsub scripts
PATH=$PATH:~/scripts/parallel-20170722/bin/

# cd ~/greenland_2017/platesA2B2/platesA2B2_combined/
# mkdir BWA{01,02,03,04,05,06,07,08,09,10}

############## by hand, copy 1/10 the sample files into each BWA folder

###### MAKE SURE THAT "SAMPLE_*" HAS BEEN CHGED TO "PLATES*" IN THE SHELL SCRIPT

# copy the minimap and samtools shell and bsub scripts into each BWA folder
SAMTOOLS_BSUB="loop_samtools_only_20180219.bsub"; echo ${SAMTOOLS_BSUB}
SAMTOOLS_SH="_loop_samtools_only_20180219.sh"; echo ${SAMTOOLS_SH}
# MINIMAP2_BSUB="loop_minimap2_only_20180226.bsub"; echo ${MINIMAP2_BSUB}
# MINIMAP2_SH="_loop_minimap2_only_20180226.sh"; echo ${MINIMAP2_SH}

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed; ls
# loop_samtools_only_20180210.bsub and _loop_samtools_only_20180210.sh should sort to bottom
# parallel cp ${MINIMAP2_BSUB} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp ${MINIMAP2_SH} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
parallel cp ${SAMTOOLS_BSUB} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
parallel cp ${SAMTOOLS_SH} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp loop_trimgalore_20180216.bsub BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp _loop_trimgalore_20180216.sh BWA{} ::: 01 02 03 04 05 06 07 08 09 10
ls

# edit the bsub files so that the correct job name will show up (i suppose i could have instead run a job array...)
cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed; ls

# parallel "sed 's/mnmploop01/mnmpEF{}/g' BWA{}/${MINIMAP2_BSUB} > BWA{}/${MINIMAP2_BSUB}_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# parallel "mv BWA{}/${MINIMAP2_BSUB}_tmp.bsub BWA{}/${MINIMAP2_BSUB}" ::: 01 02 03 04 05 06 07 08 09 10
# head -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/${MINIMAP2_BSUB} # check.  should be mnmploop10
# tail -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/${MINIMAP2_BSUB} # check.  should be mnmploop10

parallel "sed 's/samtools01/samtlsEF{}/g' BWA{}/${SAMTOOLS_BSUB} > BWA{}/${SAMTOOLS_BSUB}_tmp" ::: 01 02 03 04 05 06 07 08 09 10
parallel "mv BWA{}/${SAMTOOLS_BSUB}_tmp BWA{}/${SAMTOOLS_BSUB}" ::: 01 02 03 04 05 06 07 08 09 10
head -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/${SAMTOOLS_BSUB} # check.  should have the correct index number
tail -n 1 BWA{01,02,03,04,05,06,07,08,09,10}/${SAMTOOLS_BSUB} # check.  should have the correct samtools shell filename
ls # BWA* folders should now sort to bottom

# parallel "sed 's/trimgal01/trimgal{}/g' BWA{}/loop_trimgalore_20180216.bsub > BWA{}/loop_trimgalore_20180216_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# parallel "mv BWA{}/loop_trimgalore_20180216_tmp.bsub BWA{}/loop_trimgalore_20180216.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# head -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/loop_trimgalore_20180216.bsub # check.  should be samtools11

############# launch minimap2 scripts #############
cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA01; ls
bsub < ${MINIMAP2_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA02; ls
bsub < ${MINIMAP2_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA03; ls
bsub < ${MINIMAP2_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA04; ls
bsub < ${MINIMAP2_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA05; ls
bsub < ${MINIMAP2_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA06; ls
bsub < ${MINIMAP2_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA07; ls
bsub < ${MINIMAP2_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA08; ls
bsub < ${MINIMAP2_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA09; ls
bsub < ${MINIMAP2_BSUB}
bjobs
ls

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA10; ls
bsub < ${MINIMAP2_BSUB}
bjobs
ls

bjobs | sort -k8  # sort by 8th column:  SUBMIT_TIME

####### launch samtools scripts #######
cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA01; ls
echo "${SAMTOOLS_BSUB}"
bsub < ${SAMTOOLS_BSUB}
bjobs
ls minimap2_outputs # should start to see the new bam files

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA02; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls minimap2_outputs # should start to see the new bam files

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA03; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls minimap2_outputs # should start to see the new bam files

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA04; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls minimap2_outputs # should start to see the new bam files

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA05; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls minimap2_outputs # should start to see the new bam files

cd ~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/BWA06; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls minimap2_outputs # should start to see the new bam files

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
