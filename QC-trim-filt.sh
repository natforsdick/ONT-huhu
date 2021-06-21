#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J nano-filt-trim
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=36
#SBATCH --mem=35G
#SBATCH --partition=large
#SBATCH --output %x.%j.out 
#SBATCH --error %x.%j.err

###############
# Created by N Forsdick
# 2021-06-16
# Script to conduct adapter trimming and quality trimming and filtering of Nanopore data

###############
# ENVIRONMENT #

module purge
module load Porechop/0.2.4-gimkl-2020a-Python-3.8.2 nanofilt/2.6.0-gimkl-2020a-Python-3.8.2
###############

INDIR=/nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-fastqs/

file=Huhu01-A-B-pass

###############
# Let's get rid of adapters
# To use Nanopolish downstream, you must use --discard_middle - this removes reads with adapter within them.
#echo "Starting Porechop"
cd $INDIR
#porechop -i ${file}.fastq.gz -o 01_${file}_chopped.fastq --discard_middle -t 36

# Now let's trim and filter to remove poor quality ends and short reads
echo "Starting NanoFilt"
NanoFilt -l 500 -q 8 --headcrop 150 --tailcrop 50 01_${file}_chopped.fastq | gzip > 02_${file}_trimmed.fastq.gz

# Now let's run QC
###############
## IF RUNNING THIS IN THE FUTURE:
# Split the below to a separate run - 2 hrs, 5 GB, 4CPU
# ENVIRONMENT #
module purge 
module load Miniconda3/4.9.2

source /opt/nesi/CS400_centos7_bdw/Miniconda3/4.9.2/etc/profile.d/conda.sh
conda activate nanoQC 
###############

echo "Starting QC"
nanoQC 02_${file}_trimmed.fastq.gz -o 02_${file}_trimmed.fastq.QC

conda deactivate
echo "Pipeline complete"
