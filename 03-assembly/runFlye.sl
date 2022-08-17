#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J flye
#SBATCH --time=3-00:00:00
#SBATCH -c 10
#SBATCH --mem=500G
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=FAIL,END
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err

# runFlye.sl
# Nat Forsdick, 2021-06-21
# Assembling uncorrected nanopore data with Flye.

###########
# MODULES #
###########
ml purge
ml load Flye/2.8.3-gimkl-2020a-Python-3.8.2
###########

###########
# ENVIRO  #
###########
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-fastqs/
FASTQ=Huhu01-A-B-pass
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/03-assembly/
###########

flye --nano-raw ${INDIR}${FASTQ}.fastq.gz -g 1g -o ${OUTDIR} -t 10 -i 0
