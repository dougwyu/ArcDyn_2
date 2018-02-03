#!/bin/bash
set -e
set -u
set -o pipefail
cd /gpfs/home/b042/greenland_2017/platesGH || exit
source activate dypython
PATH=$PATH:/gpfs/home/b042/.local/bin/ # to add path and be able to refer to b2 directly

# b2 create-bucket greenland-2017-PlatesGH allPublic
# tar -cvf PKG-ENQ-2379-Data_Transfer-PSEQ-1572-truncated_R2.tar PKG-ENQ-2379-Data_Transfer-PSEQ-1572-truncated_R2/  # no need to gzip
# tar -cvf PKG-ENQ-2379-Data_Transfer-PSEQ-1586-trimmed.tar PKG-ENQ-2379-Data_Transfer-PSEQ-1586-trimmed/  # no need to gzip as all fastq files are already gzipped
# b2 upload-file --threads 10 greenland-2017-PlatesGH PKG-ENQ-2379-Data_Transfer-PSEQ-1572-truncated_R2.tar PKG-ENQ-2379-Data_Transfer-PSEQ-1572-truncated_R2.tar
# b2 upload-file --threads 10 greenland-2017-PlatesGH PKG-ENQ-2379-Data_Transfer-PSEQ-1586-trimmed.tar PKG-ENQ-2379-Data_Transfer-PSEQ-1586-trimmed.tar

tar -cvf PKG-ENQ-2379-Data_Transfer-PSEQ-1586.tar PKG-ENQ-2379-Data_Transfer-PSEQ-1586/  # no need to gzip as all fastq files are already gzipped
b2 upload-file --threads 10 greenland-2017-PlatesGH PKG-ENQ-2379-Data_Transfer-PSEQ-1586.tar PKG-ENQ-2379-Data_Transfer-PSEQ-1586.tar

tar -cvf PKG-ENQ-2379-Data_Transfer-PSEQ-1603.tar PKG-ENQ-2379-Data_Transfer-PSEQ-1603/  # no need to gzip as all fastq files are already gzipped
b2 upload-file --threads 10 greenland-2017-PlatesGH PKG-ENQ-2379-Data_Transfer-PSEQ-1603.tar PKG-ENQ-2379-Data_Transfer-PSEQ-1603.tar
########################
