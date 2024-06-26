#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J repmaskb
#SBATCH --cpus-per-task=20
#SBATCH --mem=18G
#SBATCH -t 3:20:00
#SBATCH --out %x.%j.out
#SBATCH --err %x.%j.err

# round 1: annotate/mask simple repeats
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/annotation/repeats/masking/
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/yahs/
REF=huhu-medaka-mapped-NMC_JBAT.FINAL.simple_mask.masked.fasta

cd $OUTDIR

ml purge
ml RepeatMasker/4.1.0-gimkl-2020a

RepeatMasker -pa 24 -a -e ncbi -dir ${OUTDIR}02_insecta_out/ -nolow \
-species insecta ${OUTDIR}01_simple_out/${REF} 2>&1 | tee ${OUTDIR}logs/02_insecta_mask.log

# renaming outputs
rename .simple_mask .insecta_mask ${OUTDIR}02_insecta_out/*
rename .masked .masked.fasta ${OUTDIR}02_insecta_out/*
ml purge
