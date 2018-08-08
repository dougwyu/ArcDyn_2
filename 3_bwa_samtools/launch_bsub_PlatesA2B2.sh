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
scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/loop_bwa_only_20180417.bsub b042@hpc.uea.ac.uk:~/greenland_2017/platesA2B2/platesA2B2_combined/
scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/_loop_bwa_only_20180417.sh b042@hpc.uea.ac.uk:~/greenland_2017/platesA2B2/platesA2B2_combined/

scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/loop_samtools_only_20180417.bsub b042@hpc.uea.ac.uk:~/greenland_2017/platesA2B2/platesA2B2_combined/
scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_bwa_samtools/_loop_samtools_only_20180417.sh b042@hpc.uea.ac.uk:~/greenland_2017/platesA2B2/platesA2B2_combined/

############# launch bwa scripts #############
ssh hpc
interactive
# to use parallel without a pathname in bsub scripts
PATH=$PATH:~/scripts/parallel-20170722/bin/

# cd ~/greenland_2017/platesA2B2/platesA2B2_combined/
# mkdir BWA{01,02,03,04,05,06,07,08,09,10}

############## by hand, copy 1/10 the sample files into each BWA folder

############# copy the bwa and samtools shell and bsub scripts into each BWA folder
BWA_BSUB="loop_bwa_only_20180417.bsub"; echo ${BWA_BSUB}
BWA_SH="_loop_bwa_only_20180417.sh"; echo ${BWA_SH}
# SAMTOOLS_BSUB="loop_samtools_only_20180417.bsub"; echo ${SAMTOOLS_BSUB}
# SAMTOOLS_SH="_loop_samtools_only_20180417.sh"; echo ${SAMTOOLS_SH}

cd ~/greenland_2017/platesA2B2/platesA2B2_combined; ls
parallel cp ${BWA_BSUB} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
parallel cp ${BWA_SH} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp ${SAMTOOLS_BSUB} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp ${SAMTOOLS_SH} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp loop_trimgalore_20180216.bsub BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp _loop_trimgalore_20180216.sh BWA{} ::: 01 02 03 04 05 06 07 08 09 10
ls BWA{01,02,03,04,05,06,07,08,09,10}

# edit the bsub files so that the correct job name will show up (i suppose i could have instead run a job array...)
cd ~/greenland_2017/platesA2B2/platesA2B2_combined; ls
# parallel "sed 's/bwaloop01/bwaA2B2{}/g' BWA{}/${BWA_BSUB} > BWA{}/${BWA_BSUB}_tmp" ::: 01 02 03 04 05 06 07 08 09 10
# parallel "mv BWA{}/${BWA_BSUB}_tmp BWA{}/${BWA_BSUB}" ::: 01 02 03 04 05 06 07 08 09 10
# head -n8 BWA{01,02,03,04,05,06,07,08,09,10}/${BWA_BSUB} # check.  should be mnmploop{01,02,03,...}
#      # check if i'm using mellanox-ib or long-ib
# tail -n2 BWA{01,02,03,04,05,06,07,08,09,10}/${BWA_BSUB} # check.  should be the correct shell file

parallel "sed 's/samtools01/smtlA2B2{}/g' BWA{}/${SAMTOOLS_BSUB} > BWA{}/${SAMTOOLS_BSUB}_tmp" ::: 01 02 03 04 05 06 07 08 09 10
parallel "mv BWA{}/${SAMTOOLS_BSUB}_tmp BWA{}/${SAMTOOLS_BSUB}" ::: 01 02 03 04 05 06 07 08 09 10
head -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/${SAMTOOLS_BSUB} # check.  should have the correct index number
tail -n 1 BWA{01,02,03,04,05,06,07,08,09,10}/${SAMTOOLS_BSUB} # check.  should have the correct samtools shell filename
ls # BWA* folders should now sort to bottom

# parallel "sed 's/trimgal01/trimgal{}/g' BWA{}/loop_trimgalore_20180216.bsub > BWA{}/loop_trimgalore_20180216_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# parallel "mv BWA{}/loop_trimgalore_20180216_tmp.bsub BWA{}/loop_trimgalore_20180216.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# head -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/loop_trimgalore_20180216.bsub # check job names

####### launch the minimap2 scripts #######
# cd into each BWA folder and submit bsub job
cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA01; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA02; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA03; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA04; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA05; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA06; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA07; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA08; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA09; ls
bsub < ${BWA_BSUB}
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA10; ls
bsub < ${BWA_BSUB}
bjobs
ls

####### launch samtools scripts #######
cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA01; ls
echo "${SAMTOOLS_BSUB}"
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs # should start to see the new bam files

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA02; ls
bsub < ${SAMTOOLS_BSUB}

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA03; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA04; ls
bsub < ${SAMTOOLS_BSUB}

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA05; ls
bsub < ${SAMTOOLS_BSUB}

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA06; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA07; ls
bsub < ${SAMTOOLS_BSUB}

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA08; ls
bsub < ${SAMTOOLS_BSUB}

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA09; ls
bsub < ${SAMTOOLS_BSUB}

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA10; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls bwa_outputs # should show new bam files

####### launch trimgalore scripts #######
cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA01; ls
bsub < loop_trimgalore_20180216.bsub
bjobs

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA02; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA03; ls
bsub < loop_trimgalore_20180216.bsub
bjobs

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA04; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA05; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA06; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA07; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA08; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA09; ls
bsub < loop_trimgalore_20180216.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA10; ls
bsub < loop_trimgalore_20180216.bsub
bjobs | sort -k8

ls ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA10/Sample_PRO1322_PlateA_F3 # should show first set of trimmed files
