#!/bin/bash -e

#SBATCH --job-name mapping
#SBATCH --account=ga03186
#SBATCH --mem=40G
#SBATCH --time=1-00:00:00
#SBATCH --cpus-per-task=32
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=FAIL,END

##########
# PARAMS #
ONTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/05-polish/racon/
REF=01-huhu-shasta-purged
ONT=huhu-ont-trimmed-combined.fastq.gz
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/05-polish/racon/
R2=racon1 # if mapping for racon round 2, input is racon1
##########

mkdir -p $OUTDIR && cd $OUTDIR

module purge && module load minimap2/2.24-GCC-11.3.0
ml list

echo indexing
if [ ! -e ${REFDIR}${REF}.mmi ]; then
    minimap2 -d ${REFDIR}${REF}.mmi ${REFDIR}${REF}.fasta
else
    echo index found
fi

if [ $1 = "1" ]; then
    echo "mapping ready for racon round 1"
    minimap2 -ax map-ont -t $SLURM_CPUS_PER_TASK ${REFDIR}${REF}.mmi ${ONTDIR}${ONT} > ${REF}-ONT.sam
    echo completed

elif [ $1 = "2" ]; then
    echo "mapping to racon round 1 outputs"
    minimap2 -ax map-ont -t $SLURM_CPUS_PER_TASK ${REFDIR}${REF}-${R2}.mmi ${ONTDIR}${ONT} > ${REF}${R1}-ONT.sam
    echo completed
else
    echo "ERROR no racon round specified"
fi
