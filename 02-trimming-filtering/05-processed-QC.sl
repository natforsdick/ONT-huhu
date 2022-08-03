#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J nanoQC
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=6
#SBATCH --mem=5G
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err

# 2022-05-23
# Nat Forsdick
# Nanopore read QC with NanoQC

###########
# PARAMS
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-23-Huhu-SRE/sup-fastq/02-trimfilt/
file=Huhu-PB5-pass

###############
# ENVIRONMENT 
module purge
module load Miniconda3/4.9.2

source /opt/nesi/CS400_centos7_bdw/Miniconda3/4.9.2/etc/profile.d/conda.sh
conda activate nanoQC
###############

cd $INDIR

echo "Starting QC NanoFilt a"
nanoQC 02_${file}_trimmed.fastq.gz -o 02_${file}_trimmed.fastq.QC

echo "Starting QC NanoFilt b"
nanoQC 02_${file}_trimmedb.fastq.gz -o 02_${file}_trimmedb.fastq.QC

conda deactivate
echo "Pipeline complete"

