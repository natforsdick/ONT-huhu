#!/bin/bash -e
#SBATCH -A landcare03691
#SBATCH -J shasta
#SBATCH --time=12:00:00
#SBATCH -c 60
#SBATCH --mem=400G
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=ALL
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err

# runShasta.sl
# Assembling nanopore data with shasta

###########
# PARAMS  #
###########
SHASTA=/nesi/nobackup/ga03048/modules/shasta/shasta-Linux-0.10.0
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/01-shasta
CONFIG=/nesi/project/ga03186/scripts/ONT-scripts/03-assembly/shasta.config
###########

$SHASTA --input ${INDIR}02_2022-05-16-PB5_Huhu-PB5-pass_trimmed.fastq ${INDIR}02_2022-05-23-Huhu-SRE_Huhu-PB5-pass_trimmed.fastq ${INDIR}02_2022-05-30-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq ${INDIR}02_2022-11-01-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq ${INDIR}02_2022-11-07-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq --assemblyDirectory ${OUTDIR} --config $CONFIG --command assemble --threads 48
