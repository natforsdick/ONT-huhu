#!/bin/bash

###############
# ENVIRONMENT 
module purge
module load Miniconda3

source /opt/nesi/CS400_centos7_bdw/Miniconda3/22.11.1-1/etc/profile.d/conda.sh
conda activate nanoQC
###############

cd $INDIR

echo Starting QC ${file}
nanoQC 02_${file}_trimmed.fastq.gz -o 02_${file}_trimmed.fastq.QC

conda deactivate
echo "Pipeline complete"

