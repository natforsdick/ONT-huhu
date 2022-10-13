#!/bin/bash -e

#SBATCH --job-name=make-paf
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=16:00:00
#SBATCH --mem=30G
#SBATCH --ntasks=1
#SBATCH --profile=task 
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=48

# Purge_dups pipeline
# Created by Sarah Bailey, UoA
# Modified by Nat Forsdick, 2021-08-24

# step 01: align HiFi sequencing data to the assembly and generate a paf file
# Takes one parameter - PRI or ALT

#########
# MODULES
module purge
module load minimap2/2.24-GCC-11.3.0
#########

#########
# PARAMS
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/01-flye/
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/02-purge-dups/
DATA=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/
PRE=huhu-asm1 # PREFIX
FASTQ="${DATA}02_2022-05-30-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq.gz"
R1=01- # Designate cutoffs round - either default (01) or modified (02) and whether Primary or Alternate assembly
R2=02-
#########

cd $OUTDIR

echo "Indexing"
date
if [ ! -e ${INDIR}${PRE}.mmi ]; 
then
minimap2 -d ${INDIR}${PRE}.mmi ${INDIR}${PRE}.fasta
else
echo "index found"
fi

echo "Mapping"
date
minimap2 -x map-ont -t 32 ${INDIR}${PRE}.mmi \
${FASTQ} | gzip -c - > ${R1}${PRE}-mapped-b.paf.gz
echo "done"
date

