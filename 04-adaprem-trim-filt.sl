#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J nano-filt-trim
#SBATCH --time=03:00:00
#SBATCH --cpus-per-task=18
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

INDIR=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/hac-fastq/combined-fastqs/
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/hac-fastq/03-trimfilt/
file=Huhu-PS5-pass

###############
if [ -e $OUTDIR ]; then
	echo $OUTDIR exists
else
	mkdir -p $OUTDIR
fi

# Let's get rid of adapters
# To use Nanopolish downstream, you must use --discard_middle - this removes reads with adapter within them.
echo "Starting Porechop"
cd $OUTDIR
porechop -i ${INDIR}${file}.fastq.gz -o 01_${file}_adaprem.fastq --discard_middle -t $SLURM_CPUS_PER_TASK

# Now let's trim and filter to remove poor quality ends and short reads
# q = minimum average quality
echo "Starting NanoFilt"
NanoFilt -l 1000 -q 9 --headcrop 150 --tailcrop 50 01_${file}_adaprem.fastq | gzip > 02_${file}_trimmed.fastq.gz

# Now re-run nanoQC steps
