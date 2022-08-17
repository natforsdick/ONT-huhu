#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J nanoQC
#SBATCH --time=02:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err

# 2022-05-23
# Nat Forsdick
# Nanopore read QC with NanoQC

###########
# PARAMS
export INDIR=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-23-Huhu-SRE/sup-fastq/02-trimfilt/
export file=Huhu-PB5-pass


bash 05-processed-QC.sh
