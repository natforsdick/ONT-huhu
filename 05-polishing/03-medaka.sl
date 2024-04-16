#!/bin/bash -e

#SBATCH --job-name medaka
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=32
#SBATCH --mem=42G
#SBATCH --time=1-00:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=FAIL,END

##########
# PARAMS #
ONTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/05-polish/racon/
REF=01-huhu-shasta-purged-racon2.fasta
ONT=huhu-ont-trimmed-combined.fastq.gz
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/05-polish/02-medaka/
##########

mkdir -p $OUTDIR && cd $OUTDIR
ml purge && ml medaka/1.11.1-Miniconda3-22.11.1-1 CUDA/11.4.1

# we used r9.4.1 flowcells, on the MinION, with the sup model in Guppy v 6.2.1, so the closest model available is: r941_min_sup_g507
# set -b to 100 to avoid OOM errors with GPU
medaka_consensus -i ${ONTDIR}${ONT} -d ${REFDIR}${REF} -o ${OUTDIR} -t $SLURM_CPUS_PER_TASK -m r941_min_sup_g507 -b 100
