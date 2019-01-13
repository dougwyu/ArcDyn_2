#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to launch bsub files
#######################################################################################
#######################################################################################

# upload the new samtools bsub file from macOS
# run in macOS, not hpc
scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/loop_bwa_only_20180417.bsub b042@hpc.uea.ac.uk:~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/
scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/_loop_bwa_only_20180417.sh b042@hpc.uea.ac.uk:~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/

scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/loop_samtools_only_20180417.bsub b042@hpc.uea.ac.uk:~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/
scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/_loop_samtools_only_20180417.sh b042@hpc.uea.ac.uk:~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/


ssh hpc
interactive
# to use parallel without a pathname in bsub scripts
PATH=$PATH:~/scripts/parallel-20170722/bin/

# copy the minimap and samtools shell and bsub scripts into each BWA folder
# BWA_BSUB="loop_bwa_only_20180417.bsub"; echo ${BWA_BSUB}
# BWA_SH="_loop_bwa_only_20180417.sh"; echo ${BWA_SH}
SAMTOOLS_BSUB="loop_samtools_only_20180417.bsub"; echo ${SAMTOOLS_BSUB}
SAMTOOLS_SH="_loop_samtools_only_20180417.sh"; echo ${SAMTOOLS_SH}

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine
ls
# parallel cp ${BWA_BSUB} BWA{} ::: 01 02 03 04 05 06 07 08 09 10 11
# parallel cp ${BWA_SH} BWA{} ::: 01 02 03 04 05 06 07 08 09 10 11
parallel cp ${SAMTOOLS_BSUB} BWA{} ::: 01 02 03 04 05 06 07 08 09 10 11
parallel cp ${SAMTOOLS_SH} BWA{} ::: 01 02 03 04 05 06 07 08 09 10 11
# parallel cp loop_trimgalore_20180216.bsub BWA{} ::: 01 02 03 04 05 06 07 08 09 10 11
# parallel cp _loop_trimgalore_20180216.sh BWA{} ::: 01 02 03 04 05 06 07 08 09 10 11
ls BWA{01,02,03,04,05,06,07,08,09,10,11} # | tail -n 2

# edit the bsub files so that the correct job name will show up (i suppose i could have instead run a job array...)
cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine

# parallel "sed 's/bwaloop01/bwaAB{}/g' BWA{}/${BWA_BSUB} > BWA{}/${BWA_BSUB}_tmp" ::: 01 02 03 04 05 06 07 08 09 10 11
# parallel "mv BWA{}/${BWA_BSUB}_tmp BWA{}/${BWA_BSUB}" ::: 01 02 03 04 05 06 07 08 09 10 11
# head -n 5 BWA{01,02,03,04,05,06,07,08,09,10,11}/${BWA_BSUB} # check.  should be bwaloop11
# tail -n 5 BWA{01,02,03,04,05,06,07,08,09,10,11}/${BWA_BSUB} # check.

parallel "sed 's/samtools01/samtlsAB{}/g' BWA{}/${SAMTOOLS_BSUB} > BWA{}/${SAMTOOLS_BSUB}_tmp" ::: 01 02 03 04 05 06 07 08 09 10 11
parallel "mv BWA{}/${SAMTOOLS_BSUB}_tmp BWA{}/${SAMTOOLS_BSUB}" ::: 01 02 03 04 05 06 07 08 09 10 11
head -n 5 BWA{01,02,03,04,05,06,07,08,09,10,11}/${SAMTOOLS_BSUB} # check.  should have the correct index number
tail -n 1 BWA{01,02,03,04,05,06,07,08,09,10,11}/${SAMTOOLS_BSUB} # check.  should have the correct samtools shell filename
ls # BWA* folders should now sort to bottom

# parallel "sed 's/trimgal01/trimgal{}/g' BWA{}/loop_trimgalore_20180216.bsub > BWA{}/loop_trimgalore_20180216_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10 11
# parallel "mv BWA{}/loop_trimgalore_20180216_tmp.bsub BWA{}/loop_trimgalore_20180216.bsub" ::: 01 02 03 04 05 06 07 08 09 10 11
# head -n 5 BWA{01,02,03,04,05,06,07,08,09,10,11}/loop_trimgalore_20180216.bsub # check.  should be samtools11


####### launch bwa scripts #######
cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA01; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA02; ls
bsub < ${BWA_BSUB}
bjobs

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA03; ls
bsub < ${BWA_BSUB}

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA04; ls
bsub < ${BWA_BSUB}

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA05; ls
bsub < ${BWA_BSUB}

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA06; ls
bsub < ${BWA_BSUB}

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA07; ls
bsub < ${BWA_BSUB}

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA08; ls
bsub < ${BWA_BSUB}

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA09; ls
bsub < ${BWA_BSUB}

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA10; ls
bsub < ${BWA_BSUB}

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA11; ls
bsub < ${BWA_BSUB}

bjobs
ls ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA11/bwa_outputs # check

############# launch samtools scripts #############y
cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA01; ls
echo "${SAMTOOLS_BSUB}"
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs # should start to see the new bam files

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA02; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs # should start to see the new bam files

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA03; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs # should start to see the new bam files

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA04; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA05; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA06; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA07; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA08; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA09; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA10; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA11; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs



############# rename bwa_outputs folders #############

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA01; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA02; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA03; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA04; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA05; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA06; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA07; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA08; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA09; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA10; ls
mv bwa_outputs/ bwa_outputs_bfc/

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA11; ls
mv bwa_outputs/ bwa_outputs_bfc/

bjobs

####### launch trimgalore scripts #######
cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA01; ls
bsub < loop_trimgalore_20180216.bsub
bjobs
ls

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA02; ls
bsub < loop_trimgalore_20180216.bsub
bjobs

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA03; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA04; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA05; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA06; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA07; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA08; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA09; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA10; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA11; ls
bsub < loop_trimgalore_20180216.bsub

bjobs
ls ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/BWA11/Sample_IPO3916_C6 # check
