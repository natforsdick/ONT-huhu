#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J flye
#SBATCH --time=7-00:00:00
#SBATCH -c 60
#SBATCH --mem=400G
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
ml load Flye/2.9-gimkl-2020a-Python-3.8.2
###########

###########
# ENVIRO  #
###########
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/
FASTQ="../../02_2022-11-01-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq.gz ../../02_2022-11-07-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq.gz ../../02_2022-05-30-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq.gz ../../02_2022-05-23-Huhu-SRE_Huhu-PB5-pass_trimmed.fastq.gz ../../02_2022-05-16-PB5_Huhu-PB5-pass_trimmed.fastq.gz"
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/01-flye/asm2/
###########

cd ${OUTDIR}
flye --nano-raw ${FASTQ} -g 2g -o ${OUTDIR} -t 32 -i 1 --scaffold
# can add --resume when necessary, but not at outset
