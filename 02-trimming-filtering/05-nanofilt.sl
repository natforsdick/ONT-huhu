#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J nano-filt-trim
#SBATCH --time=02:00:00 #04:30:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=1G
#SBATCH --partition=large
#SBATCH --output %x.%j.out 
#SBATCH --error %x.%j.err

# 2021-06-16
# Script to conduct quality trimming and filtering of Nanopore data

###############
# ENVIRONMENT #

module purge
module load Porechop/0.2.4-gimkl-2020a-Python-3.8.2 nanofilt/2.6.0-gimkl-2020a-Python-3.8.2
###############
samplist="2022-05-23-Huhu-SRE" 
#for ALL: "2022-05-16-PB5 2022-05-23-Huhu-SRE 2022-05-30-Huhu-PB5"
file=Huhu-PB5-pass

for samp in $samplist
do

OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/${samp}/sup-fastq/02-trimfilt/

# Trim and filter to remove poor quality ends and short reads
# l = minimum length, q = minimum average quality
echo "Starting NanoFilt"
date
cd $OUTDIR
NanoFilt -l 500 -q 9 --headcrop 50 --tailcrop 50 01_Huhu-PB5-pass_adaprem.fastq |\
# for ALL: 01_${samp}_${file}_adaprem.fastq | 
gzip > 02_${samp}_${file}_trimmed.fastq.gz
done

