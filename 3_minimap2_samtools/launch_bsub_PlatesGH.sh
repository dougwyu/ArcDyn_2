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
scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_minimap2_samtools/loop_samtools_only_20180210.bsub b042@hpc.uea.ac.uk:~/greenland_2017/platesGH/platesGH_combined/

scp ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/mapping_git/3_minimap2_samtools/_loop_samtools_only_20180210.sh b042@hpc.uea.ac.uk:~/greenland_2017/platesGH/platesGH_combined/

############# launch minimap2 scripts #############
ssh hpc
interactive
# to use parallel without a pathname in bsub scripts
PATH=$PATH:~/scripts/parallel-20170722/bin/

# cd ~/greenland_2017/platesGH/platesGH_combined/
# mkdir BWA{01,02,03,04,05,06,07,08,09,10}

# by hand, copy 1/10 the sample files into each BWA folder

# copy the minimap and samtools shell and bsub scripts into each BWA folder
cd ~/greenland_2017/platesGH/platesGH_combined/
ls
parallel cp loop_minimap2_20180211.bsub BWA{} ::: 01 02 03 04 05 06 07 08 09 10
parallel cp _loop_minimap2_20180211.sh BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp loop_samtools_only_20180210.bsub BWA{} ::: 01 02 03 04 05 06 07 08 09 10
# parallel cp _loop_samtools_only_20180210.sh BWA{} ::: 01 02 03 04 05 06 07 08 09 10

# edit the bsub files so that the correct job name will show up (i suppose i could have instead run a job array...)
cd ~/greenland_2017/platesGH/platesGH_combined/
parallel "sed 's/mnmploop01/mnmploop{}/g' BWA{}/loop_minimap2_20180211.bsub > BWA{}/loop_minimap2_20180211_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10
parallel "mv BWA{}/loop_minimap2_20180211_tmp.bsub BWA{}/loop_minimap2_20180211.bsub" ::: 01 02 03 04 05 06 07 08 09 10
head BWA{01,02,03,04,05,11}/loop_minimap2_20180211.bsub # check.  should be mnmploop10

# parallel "sed 's/samtools01/samtools{}/g' BWA{}/loop_samtools_only_20180210.bsub > BWA{}/loop_samtools_only_20180210_tmp.bsub" ::: 01 02 03 04 05 06 07 08 09 10
# parallel "mv BWA{}/loop_samtools_only_20180210_tmp.bsub BWA{}/loop_samtools_only_20180210.bsub" ::: 01 02 03 04 05 06 07 08 09 10
ls # BWA* folders should now sort to bottom
head BWA{01,02,03,04,05,11}/loop_samtools_only_20180210.bsub # check.  should be mnmploop10

####### launch samtools scripts #######
cd ~/greenland_2017/platesGH/platesGH_combined/BWA01; ls
bsub < loop_samtools_only_20180210.bsub
bjobs | sort -k8

cd ~/greenland_2017/platesGH/platesGH_combined/BWA02; ls
bsub < loop_samtools_only_20180210.bsub
bjobs | sort -k8

cd ~/greenland_2017/platesGH/platesGH_combined/BWA03; ls
bsub < loop_samtools_only_20180210.bsub

cd ~/greenland_2017/platesGH/platesGH_combined/BWA04; ls
bsub < loop_samtools_only_20180210.bsub
bjobs | sort -k8

cd ~/greenland_2017/platesGH/platesGH_combined/BWA05; ls
bsub < loop_samtools_only_20180210.bsub

cd ~/greenland_2017/platesGH/platesGH_combined/BWA06; ls
bsub < loop_samtools_only_20180210.bsub

cd ~/greenland_2017/platesGH/platesGH_combined/BWA07; ls
bsub < loop_samtools_only_20180210.bsub

cd ~/greenland_2017/platesGH/platesGH_combined/BWA08; ls
bsub < loop_samtools_only_20180210.bsub

cd ~/greenland_2017/platesGH/platesGH_combined/BWA09; ls
bsub < loop_samtools_only_20180210.bsub

cd ~/greenland_2017/platesGH/platesGH_combined/BWA10; ls
bsub < loop_samtools_only_20180210.bsub
bjobs | sort -k8


############# launch minimap2 scripts #############
# cd into each BWA folder and submit bsub job
cd ~/greenland_2017/platesGH/platesGH_combined/BWA01; ls
bsub < loop_minimap2_20180211.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA02; ls
bsub < loop_minimap2_20180211.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA03; ls
bsub < loop_minimap2_20180211.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA04; ls
bsub < loop_minimap2_20180211.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA05; ls
bsub < loop_minimap2_20180211.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA06; ls
bsub < loop_minimap2_20180211.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA07; ls
bsub < loop_minimap2_20180211.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA08; ls
bsub < loop_minimap2_20180211.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA09; ls
bsub < loop_minimap2_20180211.bsub
bjobs
ls

cd ~/greenland_2017/platesGH/platesGH_combined/BWA10; ls
bsub < loop_minimap2_20180211.bsub
bjobs | sort -k8
ls
