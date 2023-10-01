#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J nano-filt-trim
#SBATCH --time=01:30:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=2G
#SBATCH --output %x.%j.out 
#SBATCH --error %x.%j.err

# 2021-06-16
# Quality trimming and filtering of Nanopore data

###############
# ENVIRONMENT #

module purge
module load nanofilt/2.6.0-gimkl-2020a-Python-3.8.2
###############

# Trim and filter to remove poor quality ends and short reads
# l = minimum length, q = minimum average quality

#mkdir /nesi/nobackup/landcare03691/data/output/rata-MinION/Rata_2/sup-fastq/combined-sup-fastqs/02-trimfilt/
echo "Starting NanoFilt"
date
cd /nesi/nobackup/ga03186/Huhu_MinION/2022-05-23-Huhu-SRE/sup-fastq/02-trimfilt/
zcat 01_Huhu-PB5-pass_adaprem.fastq.gz | NanoFilt -l 20000 -q 7 --headcrop 20 --tailcrop 20 | gzip > /nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/lr-scaffolding/2022-05-23-Huhu-20kb-q7-subset.fq.gz

zcat /nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/lr-scaffolding/2022-05-23-Huhu-20kb-q7-subset.fq.gz | echo $((`wc -l`/4))
