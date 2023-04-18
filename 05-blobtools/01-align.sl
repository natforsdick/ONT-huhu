#!/bin/bash -e

#SBATCH --job-name=align
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=12:00:00
#SBATCH --mem=36G
#SBATCH --ntasks=1
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=46
#SBATCH --array=0-2

### MODULES ###
module purge
module load minimap2/2.24-GCC-11.3.0 SAMtools/1.13-GCC-9.2.0
######

### PARAMS ###
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/02-purge-dups/asm2/
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/05-blobtools/asm2-purged/ ## MAKE
DATA=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/
ASMPRE=01-huhu-asm2-purged # assembly prefix ## CHANGE
ASM=${INDIR}${ASMPRE}

SAMPLE_LIST=($(<${DATA}samplist.txt))
FASTQ=${SAMPLE_LIST[${SLURM_ARRAY_TASK_ID}]}
######

cd $OUTDIR

# 1. Index assembly if the index .mmi doesn't already exist
echo "Indexing"
if [ ! -e ${ASM}.mmi ];
then
minimap2 -d ${ASM}.mmi ${ASM}.fa
else
echo "index found"
fi

# 2. map processed ONT reads to the assembly
minimap2 -ax map-ont -t 32 ${ASM}.mmi ${FASTQ} |\
    samtools sort -@32 -O BAM -o ${ASMPRE}.bam -

echo "mapping complete"
