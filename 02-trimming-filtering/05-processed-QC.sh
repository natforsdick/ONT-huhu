#!/bin/bash

###############
# ENVIRONMENT 
module purge
module load Miniconda3/4.9.2

source /opt/nesi/CS400_centos7_bdw/Miniconda3/4.9.2/etc/profile.d/conda.sh
conda activate nanoQC
###############

cd $INDIR

echo Starting QC ${file}
nanoQC 02_${file}_trimmed.fastq.gz -o 02_${file}_trimmed.fastq.QC

conda deactivate
echo "Pipeline complete"

