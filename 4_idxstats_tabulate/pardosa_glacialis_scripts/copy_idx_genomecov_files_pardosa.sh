#!/bin/bash
set -e
set -u
set -o pipefail
#######################################################################################
#######################################################################################
# a shell script to copy idx and genomcov files into a directory to be downloaded to my computer
#######################################################################################
#######################################################################################

ssh hpc
interactive
# to use parallel without a pathname in bsub scripts
PATH=$PATH:~/scripts/parallel-20170722/bin/

### CAREFUL:  i have set this up to copy files of only 1 q-score, here, 1.  if i want to copy 1 and 60, i use the GNU parallel code
# the original samtools output files are still in the BWA* folders

FILTER="F2308_f0x2"

####### cd into different folders and set up output folders to hold everything before running
####### the generic copy script below
# AB # different scripts because the pathnames are different
PLATE="AB"
WORKINGPATH="$HOME/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/"
cd ${WORKINGPATH}
ls
mkdir minimap2_all_outputs_Plates${PLATE}/; ls # rm -rf minimap2_all_outputs/
ls
ls minimap2_all_outputs_Plates${PLATE}/
# then run the generic code below

# A2B2
PLATE="A2B2"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}/plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
mkdir minimap2_all_outputs_Plates${PLATE}/
ls
ls minimap2_all_outputs_Plates${PLATE}/
# then run the generic code below

# EF
PLATE="EF"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed"
cd ${WORKINGPATH}
ls
mkdir minimap2_all_outputs_Plates${PLATE}/
ls
ls minimap2_all_outputs_Plates${PLATE}/
# then run the generic code below

# GH
PLATE="GH"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}/plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
mkdir pardosa_all_outputs_Plates${PLATE}/
ls
ls pardosa_all_outputs_Plates${PLATE}/
# then run the generic code below


####### generic code to copy files to minimap2_all_outputs_Plates${PLATE} #######
####### this folder is then downloaded to my laptop to process with R:  idxstats_tabulate_macOS_Plates*.Rmd
####### run once for each library:  AB, A2B2, EF, GH
FILTER="F2308" # this is what i used for the samtools-to-COIbarcode seqs
echo $FILTER
echo $PLATE # check that i'm going to the right folder
# e.g. Sample_IPO3916_C5_F2308_f0x2_q60_sorted.bam_idxstats.txt
parallel ls -l BWA*/pardosa_glacialis_outputs/*_${FILTER}_q{}_sorted.bam_idxstats.txt ::: 1 60
parallel ls BWA*/pardosa_glacialis_outputs/*_${FILTER}_q{}_sorted.bam_idxstats.txt ::: 1 60 | wc -l # 384 = 2 X 192
parallel cp BWA*/pardosa_glacialis_outputs/*_${FILTER}_q{}_sorted.bam_idxstats.txt pardosa_all_outputs_Plates${PLATE}/ ::: 1 60
ls pardosa_all_outputs_Plates${PLATE}/*_${FILTER}_q*_sorted.bam_idxstats.txt | wc -l # 384 = 2 X 192
ls pardosa_all_outputs_Plates${PLATE}

# e.g. Sample_IPO3916_C5_F2308_f0x2_q1_sorted_genomecov_d.txt.gz
parallel ls -l BWA*/pardosa_glacialis_outputs/*_${FILTER}_q{}_sorted_genomecov_d.txt.gz ::: 1 60
parallel ls -l BWA*/pardosa_glacialis_outputs/*_${FILTER}_q{}_sorted_genomecov_d.txt.gz ::: 1 60 | wc -l # 384 = 2 X 192
parallel cp BWA*/pardosa_glacialis_outputs/*_${FILTER}_q{}_sorted_genomecov_d.txt.gz pardosa_all_outputs_Plates${PLATE}/ ::: 1 60
parallel ls pardosa_all_outputs_Plates${PLATE}/*_${FILTER}_q{}_sorted_genomecov_d.txt.gz ::: 1 60 | wc -l # 384 = 2 X 192
ls pardosa_all_outputs_Plates${PLATE}

du -sh pardosa_all_outputs_Plates${PLATE}/ # ~1.1 GB


# when i'm on a fast network, i can download using scp, but otherwise, use Transmit
### 2016 run:  AB ###
# on macOS
# download minimap2_all_outputs_PlatesAB/
scp b042@hpc.uea.ac.uk:~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/minimap2_all_outputs_PlatesAB.tar.gz  ~/Dropbox/Working_docs/Roslin_Greenland/2016/bulk_samples/PlatesAB_EI_20160512/

cd /Users/Negorashi2011/Dropbox/Working_docs/Roslin_Greenland/2016/bulk_samples/PlatesAB_EI_20160512/

scp b042@hpc.uea.ac.uk:~/greenland_2017/platesEF_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed/minimap2_all_outputs_PlatesEF_F2308_COIBarcode.tar.gz  ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/PlatesEF/

cd ~/Dropbox/Working_docs/Roslin_Greenland/2017/bulk_samples/PlatesEF/


##### CODE I wrote to cp the minimap2-to-COIBarcodes bam etc. output files to a separate folder
# save the minimap2 to COI barcode bam outputs
# cd into the library folder (e.g. ~/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine for PlatesAB)

# change these two lines as appropriate
# PLATE="GH"
# WORKINGPATH="$HOME/greenland_2017/plates${PLATE}/plates${PLATE}_combined/"

cd ${WORKINGPATH}
mkdir minimap2_all_outputs_COIBarcode_Plates${PLATE}/; ls # rm -rf minimap2_all_outputs/
ls BWA*/pardosa_glacialis_outputs/*F2308_f0x2_* # these are the original minimap/samtools to whole mitogenomes, but the bam files have been overwritten by the minimap/samtools to COIBarcodes;  i had already downloaded these to my laptop, and i don't want to save them, so i delete them.  i have to re-run the minimap2-to-mitogenome pipeline entirely again if want to make fresh versions of these files
ls BWA*/pardosa_glacialis_outputs/*F2308_f0x2_* | wc -l
# rm -f BWA*/pardosa_glacialis_outputs/*F2308_f0x2_* # to delete them
# rm -f BWA*/pardosa_glacialis_outputs/folderlist.txt # delete the folderlist.txt files too
ls BWA*/pardosa_glacialis_outputs/* # should now only have the minimap2/samtools to COI Barcodes (which used F2308 samtools filter only)
ls BWA*/pardosa_glacialis_outputs/* | wc -l
nohup parallel cp BWA{}/pardosa_glacialis_outputs/* minimap2_all_outputs_COIBarcode_Plates${PLATE} ::: 01 02 03 04 05 06 07 08 09 10 &
     # nohup ignore hangup signal, & run in background
     # this step takes around 30 mins
# now do some checking before i remove the original files.  i wonder if could run the previous command as a mv command instead
ls minimap2_all_outputs_COIBarcode_Plates${PLATE}/
ls minimap2_all_outputs_COIBarcode_Plates${PLATE}/ | wc -l # should be slightly lower than the number from the output of:  ls BWA*/minimap2_ou tputs/* | wc -l # the reason is that BWA*/pardosa_glacialis_outputs/* | wc -l produces some additional lines for each BWA folder
ls ${WORKINGPATH}/BWA*/pardosa_glacialis_outputs/ # check which files will i delete?
ls ${WORKINGPATH}/BWA*/pardosa_glacialis_outputs/ | wc -l  # check which files will i delete?
# rm -rf ${WORKINGPATH}/BWA*/pardosa_glacialis_outputs/ # delete the files
ls

#  reducing some bam files so that i can download and view the alignments
cd ~/greenland_2017/platesGH/platesGH_combined/BWA03/minimap2_outputs
samtools view -b -F 0x4 Sample_PRO1747_PlateH_D10_sorted.bam > Sample_PRO1747_PlateH_D10_F0x4_sorted.bam
samtools view -b -F 0x4 Sample_PRO1747_PlateH_D11_sorted.bam > Sample_PRO1747_PlateH_D11_F0x4_sorted.bam

~/src/htsbox/htsbox samview -p Sample_PRO1747_PlateH_D10_F0x4_sorted.bam > Sample_PRO1747_PlateH_D10_F0x4_sorted.paf
~/src/htsbox/htsbox samview -p Sample_PRO1747_PlateH_D11_F0x4_sorted.bam > Sample_PRO1747_PlateH_D11_F0x4_sorted.paf
~/src/htsbox/htsbox samview -p Sample_PRO1747_PlateH_D10_sorted.bam > Sample_PRO1747_PlateH_D10_sorted.paf

###### filter out UNMAP unmapped reads from the COI barcode minimap2 outputs
####### cd into different folders and set up output folders to hold everything before running
####### the generic copy script below
# AB # different scripts because the pathnames are different
PLATE="AB"
WORKINGPATH="$HOME/greenland_2016/platesAB_Earlham_soups/Earlham_soups_fastq_combine/"
cd ${WORKINGPATH}/minimap2_all_outputs_COIBarcode_PlatesAB
ls
# then run the generic code below

# A2B2
PLATE="A2B2"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}/plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
# then run the generic code below

# EF
PLATE="EF"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}_Earlham_soups_20170603/Earlham_soups_20170603_fastq_combine/fastqc_completed"
cd ${WORKINGPATH}
ls
# then run the generic code below

# GH
PLATE="GH"
WORKINGPATH="$HOME/greenland_2017/plates${PLATE}/plates${PLATE}_combined/"
cd ${WORKINGPATH}
ls
# then run the generic code below
