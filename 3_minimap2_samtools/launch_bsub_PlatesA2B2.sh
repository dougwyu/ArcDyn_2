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
# to use parallel without a pathname in bsub scripts
PATH=$PATH:~/scripts/parallel-20170722/bin/

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/
mkdir BWA{01,02,03,04,05,06,07,08,09,10}

############## by hand, copy 1/10 the sample files into each BWA folder

# copy the minimap and samtools shell and bsub scripts into each BWA folder
cd ~/greenland_2017/platesA2B2/platesA2B2_combined/
parallel cp loop_minimap2_20180122.bsub BWA{} ::: 01 02 03 04 05 06 07 08 09 10
parallel cp _loop_minimap2_20180122.sh BWA{} ::: 01 02 03 04 05 06 07 08 09 10
parallel cp loop_samtools_only_20180123.bsub BWA{} ::: 01 02 03 04 05 06 07 08 09 10
parallel cp _loop_samtools_only_20180123.sh BWA{} ::: 01 02 03 04 05 06 07 08 09 10

# edit the bsub files so that the correct job name will show up (i suppose i could have instead run a job array...)
cd ~/greenland_2017/platesA2B2/platesA2B2_combined/
parallel "sed 's/mnmploop01/mnmploop{}/g' BWA{}/loop_minimap2_20180122.bsub > BWA{}/loop_minimap2_20180122_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10
parallel "mv BWA{}/loop_minimap2_20180122_tmp.bsub BWA{}/loop_minimap2_20180122.bsub" ::: 01 02 03 04 05 06 07 08 09 10

parallel "sed 's/samtools01/samtools{}/g' BWA{}/loop_samtools_only_20180123.bsub > BWA{}/loop_samtools_only_20180123_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10
parallel "mv BWA{}/loop_samtools_only_20180123_tmp.bsub BWA{}/loop_samtools_only_20180123.bsub" ::: 01 02 03 04 05 06 07 08 09 10

# launch the minimap2 scripts
# cd into each BWA folder and submit bsub job
cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA01; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA02; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA03; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA04; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA05; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA06; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA07; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA08; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA09; ls
bsub < loop_minimap2_20180122.bsub
bjobs
ls

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA10; ls
bsub < loop_minimap2_20180122.bsub
bjobs | sort -k8
ls


####### launch samtools scripts #######
cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA01
bsub < loop_samtools_only_20180123.bsub
bjobs

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA02
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA03
bsub < loop_samtools_only_20180123.bsub
bjobs

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA04
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA05
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA06
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA07
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA08
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA09
bsub < loop_samtools_only_20180123.bsub

cd ~/greenland_2017/platesA2B2/platesA2B2_combined/BWA10
bsub < loop_samtools_only_20180123.bsub
bjobs | sort -k8
