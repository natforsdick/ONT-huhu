#!/bin/bash -e

#SBATCH --job-name medaka
#SBATCH --account=landcare03691
#SBATCH --cpus-per-task=4
#SBATCH --mem=80G
#SBATCH --time=12:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=FAIL,END

##########
# PARAMS #
ONTDIR=/nesi/nobackup/landcare03691/data/output/rata-MinION/
REFDIR=/nesi/nobackup/landcare03691/data/output/polish/racon/
REF=01-asm4-shasta-purged-racon2.fasta
ONT=rata-all-trimmed.fastq
OUTDIR=/nesi/nobackup/landcare03691/data/output/polish/racon/
##########

mkdir -p $OUTDIR && cd $OUTDIR
ml purge && ml medaka/1.11.1-Miniconda3-22.11.1-1

# we used r9.4.1 flowcells, on the MinION, with the sup model in Guppy v 6.2.1, so the closest model available is: r941_min_sup_g507
medaka_consensus -i ${ONTDIR}${ONT} -d ${REFDIR}${REF} -o ${OUTDIR} -t $SLURM_CPUS_PER_TASK -m r941_min_sup_g507
