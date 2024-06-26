#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J repmask1
#SBATCH --cpus-per-task=20
#SBATCH --mem=18G
#SBATCH -t 03:20:00
#SBATCH --out %x.%j.out
#SBATCH --err %x.%j.err

# round 1: annotate/mask simple repeats
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/annotation/repeats/masking/
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/yahs/
REF=huhu-medaka-mapped-NMC_JBAT.FINAL.fa

base=$(basename "$REF")
base=${base%.*}

mkdir -p ${OUTDIR}logs
cd $OUTDIR

ml purge
ml RepeatMasker/4.1.0-gimkl-2020a

RepeatMasker -pa 24 -a -e ncbi -dir ${OUTDIR}01_simple_out/ -noint -xsmall ${REFDIR}${REF} 2>&1 | tee ${OUTDIR}logs/01_simplemask.log

rename fa simple_mask ${OUTDIR}01_simple_out/${base}*
rename .masked .masked.fasta 01_simple_out/${base}*
ml purge
