#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J porechop
#SBATCH --time=08:00:00
#SBATCH --cpus-per-task=24
#SBATCH --mem=52G
#SBATCH --output %x.%j.out 
#SBATCH --error %x.%j.err

# 2021-06-16
# Script to conduct adapter trimming and quality trimming and filtering of Nanopore data

###############
# ENVIRONMENT #

module purge
module load Porechop/0.2.4-gimkl-2020a-Python-3.8.2
###############
samplist="2022-11-01-Huhu-PB5 2022-11-07-Huhu-PB5"
file=Huhu-PB5-pass

for samp in $samplist
do
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/${samp}/sup-fastq/combined-sup-fastqs/
cd $INDIR

OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/${samp}/sup-fastq/02-trimfilt/

if [ ! -e $OUTDIR ]; then
	mkdir -p $OUTDIR
fi

# Adapter removal
# To use Nanopolish downstream, you must use --discard_middle - this removes reads with adapter within them.
echo "Starting Porechop"
date

porechop -i ${INDIR}${file}.fastq.gz -o ${OUTDIR}01_${samp}_${file}_adaprem.fastq --discard_middle -t 18
done
