#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J repmod
#SBATCH --cpus-per-task=20
#SBATCH --mem=16G
#SBATCH -t 2-08:00:00
#SBATCH --out %x.%j.out
#SBATCH --err %x.%j.err

OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/annotation/repeats/
species=huhu

date
cd $OUTDIR
ml purge
ml RepeatModeler/2.0.3-Miniconda3

# -pa = parellel search - each pa uses 4 cpu
RepeatModeler -database $species -pa 20 -LTRStruct
wait
date
