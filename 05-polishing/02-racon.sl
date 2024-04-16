#!/bin/bash -e

#SBATCH --job-name racon
#SBATCH --account=ga03186
#SBATCH --mem=252G
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=12 # worked with 8 for rata
#SBATCH --partition gpu,hgx
#SBATCH --gpus-per-node A100:1
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=FAIL,END

##########
# PARAMS #
ONTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/02-purge-dups/asm3-shasta/
REF=01-huhu-shasta-purged
ONT=huhu-ont-trimmed-combined.fastq.gz
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/05-polish/racon/
ROUND=2 # 1 or 2
##########

mkdir -p $OUTDIR && cd $OUTDIR

module purge && module load {CUDA/11.4.1,Racon/1.5.0-GCC-11.3.0,minimap2/2.24-GCC-11.3.0}
ml list

if [ $ROUND == 1 ]; then
    echo ${ROUND}X Racon
    racon -t 24 ${ONTDIR}${ONT} ${REF}-ONT.sam ${REFDIR}${REF}.fa > ${REF}-racon${ROUND}.fasta
    echo ${ROUND}X completed
elif [ $ROUND == 2 ]; then
    echo ${ROUND}X Racon
    racon -t 24 ${ONTDIR}${ONT} ${REF}-racon1-ONT.sam ${REF}-racon1.fasta > ${REF}-racon${ROUND}.fasta
    echo ${ROUND}X Racon completed
fi
