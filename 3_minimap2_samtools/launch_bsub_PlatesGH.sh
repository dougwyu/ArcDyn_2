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
scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_minimap2_samtools/loop_samtools_only_20180219.bsub b042@hpc.uea.ac.uk:~/greenland_2017/platesGH/platesGH_combined/

scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_minimap2_samtools/_loop_samtools_only_20180219.sh b042@hpc.uea.ac.uk:~/greenland_2017/platesGH/platesGH_combined/

############# launch minimap2 scripts #############
ssh hpc
interactive
# to use parallel without a pathname in bsub scripts
PATH=$PATH:~/scripts/parallel-20170722/bin/

# cd ~/greenland_2017/platesGH/platesGH_combined/
# mkdir BWA{01,02,03,04,05,06,07,08,09,10}

# by hand, copy 1/10 the sample files into each BWA folder

# copy the minimap and samtools shell and bsub scripts into each BWA folder
SAMTOOLS_BSUB="loop_samtools_only_20180219.bsub"; echo ${SAMTOOLS_BSUB}
SAMTOOLS_SH="_loop_samtools_only_20180219.sh"; echo ${SAMTOOLS_SH}
# MINIMAP2_BSUB=""; echo ${MINIMAP2_BSUB}
# MINIMAP2_SH=""; echo ${MINIMAP2_SH}
cd ~/greenland_2017/platesGH/platesGH_combined/
ls
# parallel cp ${MINIMAP2_BSUB} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp ${MINIMAP2_SH} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
parallel cp ${SAMTOOLS_BSUB} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
parallel cp ${SAMTOOLS_SH} BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp loop_trimgalore_20180216.bsub BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp _loop_trimgalore_20180216.sh BWA{} ::: 01 02 03 04 05 06 07 08 09 10
ls BWA{01,02,03,04,05,06,07,08,09,10} #| tail -n 2

# edit the bsub files so that the correct job name will show up (i suppose i could have instead run a job array...)
cd ~/greenland_2017/platesGH/platesGH_combined/
# parallel "sed 's/mnmploop01/mnmploop{}/g' BWA{}/loop_minimap2_only_20180218.bsub > BWA{}/loop_minimap2_only_20180218_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# parallel "mv BWA{}/loop_minimap2_only_20180218_tmp.bsub BWA{}/loop_minimap2_only_20180218.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# head -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/loop_minimap2_only_20180218.bsub # check.  should be mnmploop10
# tail -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/loop_minimap2_only_20180218.bsub # check.  should be mnmploop10

parallel "sed 's/samtools01/samtlsGH{}/g' BWA{}/${SAMTOOLS_BSUB} > BWA{}/${SAMTOOLS_BSUB}_tmp" ::: 01 02 03 04 05 06 07 08 09 10
parallel "mv BWA{}/${SAMTOOLS_BSUB}_tmp BWA{}/${SAMTOOLS_BSUB}" ::: 01 02 03 04 05 06 07 08 09 10
head -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/${SAMTOOLS_BSUB} # check.  should have the correct index number
tail -n 1 BWA{01,02,03,04,05,06,07,08,09,10}/${SAMTOOLS_BSUB} # check.  should have the correct samtools shell filename
ls # BWA* folders should now sort to bottom

# parallel "sed 's/trimgal01/trimgal{}/g' BWA{}/loop_trimgalore_20180216.bsub > BWA{}/loop_trimgalore_20180216_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# parallel "mv BWA{}/loop_trimgalore_20180216_tmp.bsub BWA{}/loop_trimgalore_20180216.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# head -n 5 BWA{01,02,03,04,05,06,07,08,09,10}/loop_trimgalore_20180216.bsub # check job names

####### launch samtools scripts #######
cd ~/greenland_2017/platesGH/platesGH_combined/BWA01; ls
echo "${SAMTOOLS_BSUB}"
bsub < ${SAMTOOLS_BSUB}
bjobs
ls minimap2_outputs # should start to see the new bam files

cd ~/greenland_2017/platesGH/platesGH_combined/BWA02; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls minimap2_outputs # should start to see the new bam files

cd ~/greenland_2017/platesGH/platesGH_combined/BWA03; ls
bsub < ${SAMTOOLS_BSUB}
bjobs
ls minimap2_outputs # should start to see the new bam files

cd ~/greenland_2017/platesGH/platesGH_combined/BWA04; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

cd ~/greenland_2017/platesGH/platesGH_combined/BWA05; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

cd ~/greenland_2017/platesGH/platesGH_combined/BWA06; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

cd ~/greenland_2017/platesGH/platesGH_combined/BWA07; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

cd ~/greenland_2017/platesGH/platesGH_combined/BWA08; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

cd ~/greenland_2017/platesGH/platesGH_combined/BWA09; ls
bsub < ${SAMTOOLS_BSUB}
bjobs

cd ~/greenland_2017/platesGH/platesGH_combined/BWA10; ls
bsub < ${SAMTOOLS_BSUB}
bjobs


############# launch minimap2 scripts #############
# cd into each BWA folder and submit bsub job
cd ~/greenland_2017/platesGH/platesGH_combined/BWA01; ls
bsub < loop_minimap2_only_20180218.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA02; ls
bsub < loop_minimap2_only_20180218.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA03; ls
bsub < loop_minimap2_only_20180218.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA04; ls
bsub < loop_minimap2_only_20180218.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA05; ls
bsub < loop_minimap2_only_20180218.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA06; ls
bsub < loop_minimap2_only_20180218.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA07; ls
bsub < loop_minimap2_only_20180218.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA08; ls
bsub < loop_minimap2_only_20180218.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA09; ls
bsub < loop_minimap2_only_20180218.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA10; ls
bsub < loop_minimap2_only_20180218.bsub
bjobs | sort -k8
ls


####### launch samtools Pardosa_glacialis scripts #######
# skipping BWA01 and BWA03 because minimap2 didn't finish
cd ~/greenland_2017/platesGH/platesGH_combined/BWA02; ls
bsub < loop_samtools_only_20180217_Pardosa_glacialis.bsub
bjobs | sort -k8

cd ~/greenland_2017/platesGH/platesGH_combined/BWA04; ls
bsub < loop_samtools_only_20180217_Pardosa_glacialis.bsub
bjobs | sort -k8

cd ~/greenland_2017/platesGH/platesGH_combined/BWA05; ls
bsub < loop_samtools_only_20180217_Pardosa_glacialis.bsub

cd ~/greenland_2017/platesGH/platesGH_combined/BWA06; ls
bsub < loop_samtools_only_20180217_Pardosa_glacialis.bsub

cd ~/greenland_2017/platesGH/platesGH_combined/BWA07; ls
bsub < loop_samtools_only_20180217_Pardosa_glacialis.bsub

cd ~/greenland_2017/platesGH/platesGH_combined/BWA08; ls
bsub < loop_samtools_only_20180217_Pardosa_glacialis.bsub

cd ~/greenland_2017/platesGH/platesGH_combined/BWA09; ls
bsub < loop_samtools_only_20180217_Pardosa_glacialis.bsub

cd ~/greenland_2017/platesGH/platesGH_combined/BWA10; ls
bsub < loop_samtools_only_20180217_Pardosa_glacialis.bsub
bjobs | sort -k8
