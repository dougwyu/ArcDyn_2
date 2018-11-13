#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to copy idx and genomcov files into a directory to be downloaded to my computer
# run after running the samtools script, does not have to be uploaded to hpc
#######################################################################################
#######################################################################################

ssh hpc
interactive
# to use parallel without a pathname in bsub scripts
PATH=$PATH:~/scripts/parallel-20170722/bin/

# FILTER="F2308"
OUTPUTFOLDER="minimap2_outputs"
# OUTPUTFOLDER="bwa_outputs"
# OUTPUTFOLDER="pardosa_spp_outputs"

####### cd into different folders and set up output folders to hold everything before running
####### the generic copy script below
# A2B2
PLATE="A2B2"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}/plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
mkdir ${OUTPUTFOLDER}_Plates${PLATE}/
ls
ls ${OUTPUTFOLDER}_Plates${PLATE}/
ls BWA*/*.out
# then run the generic code below

# AB # different scripts because the pathnames are different
PLATE="AB"
WORKINGPATH="$HOME/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/"
cd ${WORKINGPATH}
ls
mkdir ${OUTPUTFOLDER}_Plates${PLATE}/
ls
ls ${OUTPUTFOLDER}_Plates${PLATE}/
# then run the generic code below

# EF
PLATE="EF"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed"
cd ${WORKINGPATH}
ls
mkdir ${OUTPUTFOLDER}_Plates${PLATE}/
ls
ls ${OUTPUTFOLDER}_Plates${PLATE}/
# then run the generic code below

# GH
PLATE="GH"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}/plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
mkdir ${OUTPUTFOLDER}_Plates${PLATE}/
ls
ls ${OUTPUTFOLDER}_Plates${PLATE}/

# then run the generic code below

####### generic code to copy files to bwa_all_outputs_Plates${PLATE} #######
####### this folder is then downloaded to my laptop to process with R:  idxstats_tabulate_macOS_Plates*.Rmd
####### run once for each library:  AB, A2B2, EF, GH
# choose a filter and run below, then choose any other filters and run below
FILTER1="F2308_f0x2" # filter 1
FILTER2="F2308" # filter 2
echo $FILTER1
echo $FILTER2
QUAL1=""; echo $QUAL1 # set to "" if i don't want to use this variable for, say, q1
QUAL2=48; echo $QUAL2

echo $PLATE # check that i'm going to the right folder
echo $OUTPUTFOLDER

# e.g. Sample_IPO3916_C5_F2308_f0x2_q60_sorted.bam_idxstats.txt
parallel ls -l BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted.bam_idxstats.txt ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2}
parallel ls BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted.bam_idxstats.txt ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2} | wc -l # 384 = 2 X 192
parallel cp BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted.bam_idxstats.txt ${OUTPUTFOLDER}_Plates${PLATE}/ ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2}
ls ${OUTPUTFOLDER}_Plates${PLATE}/*_q*_sorted.bam_idxstats.txt | wc -l # 384 = 2 X 192
ls ${OUTPUTFOLDER}_Plates${PLATE}/
cp BWA*/${OUTPUTFOLDER}/*_sorted.bam.flagstat.txt ${OUTPUTFOLDER}_Plates${PLATE}/
ls ${OUTPUTFOLDER}_Plates${PLATE}/

# e.g. Sample_IPO3916_C5_F2308_f0x2_q1_sorted_genomecov_d.txt.gz
parallel ls -l BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted_genomecov_d.txt.gz ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2}
parallel ls -l BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted_genomecov_d.txt.gz ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2} | wc -l # 384 = 2 X 192
parallel cp BWA*/${OUTPUTFOLDER}/*_{1}_q{2}_sorted_genomecov_d.txt.gz ${OUTPUTFOLDER}_Plates${PLATE}/ ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2}
parallel ls ${OUTPUTFOLDER}_Plates${PLATE}/*_{1}_q{2}_sorted_genomecov_d.txt.gz ::: ${FILTER1} ${FILTER2} ::: ${QUAL1} ${QUAL2} | wc -l # 384 = 2 X 192
ls ${OUTPUTFOLDER}_Plates${PLATE}/

# rename, tar and gzip for download
du -sh ${OUTPUTFOLDER}_Plates${PLATE}/ # ~4.9 GB
# set filename to something that i can understand after download
# format:  outputs_PlatesAB_F2308_f0x2_q48_minimap2_outputs_20180727.tar.gz
mv ${OUTPUTFOLDER}_Plates${PLATE} outputs_Plates${PLATE}_${FILTER1}_q${QUAL2}_${OUTPUTFOLDER}_20181111
ls
# tar gzip for download
tar -czvf outputs_Plates${PLATE}_${FILTER1}_q${QUAL2}_${OUTPUTFOLDER}_20181111.tar.gz outputs_Plates${PLATE}_${FILTER1}_q${QUAL2}_${OUTPUTFOLDER}_20181111/
ls
rm -rf outputs_Plates${PLATE}_${FILTER1}_q${QUAL2}_${OUTPUTFOLDER}_20181111/
ls


# when i'm on a fast network, i can download using scp, but otherwise, use Transmit
### 2016 run:  AB ###
# on macOS
# download bwa_all_outputs_PlatesAB/
scp b042@hpc.uea.ac.uk:~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/bwa_all_outputs_Plates${PLATE}_${FILTER}.tar.gz  ~/Dropbox/Working_docs/Roslin_Greenland/2016/bulk_samples/PlatesAB_EI_20160512/

cd /Users/Negorashi2011/Dropbox/Working_docs/Roslin_Greenland/2016/bulk_samples/PlatesAB_EI_20160512/

scp b042@hpc.uea.ac.uk:~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/bwa_all_outputs_PlatesEF_F2308_COIBarcode.tar.gz  ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/PlatesEF/

cd ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/PlatesEF/


##### CODE I wrote to cp the bwa-to-COIBarcodes bam etc. output files to a separate folder
# save the bwa to COI barcode bam outputs
# cd into the library folder (e.g. ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine for PlatesAB)

# change these two lines as appropriate
# PLATE="GH"
# WORKINGPATH="$HOME/greenland_2017/plates${PLATE}/plates${PLATE}_combined/"

cd ${WORKINGPATH}
mkdir bwa_all_outputs_COIBarcode_Plates${PLATE}/; ls # rm -rf bwa_all_outputs/
ls BWA*/bwa_outputs/*F2308_f0x2_* # these are the original minimap/samtools to whole mitogenomes, but the bam files have been overwritten by the minimap/samtools to COIBarcodes;  i had already downloaded these to my laptop, and i don't want to save them, so i delete them.  i have to re-run the bwa-to-mitogenome pipeline entirely again if want to make fresh versions of these files
ls BWA*/bwa_outputs/*F2308_f0x2_* | wc -l
# rm -f BWA*/bwa_outputs/*F2308_f0x2_* # to delete them
# rm -f BWA*/bwa_outputs/folderlist.txt # delete the folderlist.txt files too
ls BWA*/bwa_outputs/* # should now only have the bwa/samtools to COI Barcodes (which used F2308 samtools filter only)
ls BWA*/bwa_outputs/* | wc -l
nohup parallel cp BWA{}/bwa_outputs/* bwa_all_outputs_COIBarcode_Plates${PLATE} ::: 01 02 03 04 05 06 07 08 09 10 &
     # nohup ignore hangup signal, & run in background
     # this step takes around 30 mins
# now do some checking before i remove the original files.  i wonder if could run the previous command as a mv command instead
ls bwa_all_outputs_COIBarcode_Plates${PLATE}/
ls bwa_all_outputs_COIBarcode_Plates${PLATE}/ | wc -l # should be slightly lower than the number from the output of:  ls BWA*/bwa_ou tputs/* | wc -l # the reason is that BWA*/bwa_outputs/* | wc -l produces some additional lines for each BWA folder
ls ${WORKINGPATH}/BWA*/bwa_outputs/ # check which files will i delete?
ls ${WORKINGPATH}/BWA*/bwa_outputs/ | wc -l  # check which files will i delete?
# rm -rf ${WORKINGPATH}/BWA*/bwa_outputs/ # delete the files
ls
