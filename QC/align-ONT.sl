#!/bin/bash -e

#SBATCH --job-name=make-paf
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=12:00:00
#SBATCH --mem=36G
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=36
#SBATCH --array=1

# Takes one parameter - PRI or ALT

#########
# MODULES
module purge
module load minimap2/2.20-GCC-9.2.0 SAMtools/1.13-GCC-9.2.0
#########

#########
# PARAMS
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data//02-purge-dups/asm2/
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/03-mapping/
DATA=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/
PRE=01-huhu-asm2-purged # PREFIX
SAMPLE_LIST=($(<${DATA}samplist.txt))
FASTQ=${SAMPLE_LIST[${SLURM_ARRAY_TASK_ID}]}

#########

cd $OUTDIR

echo "Indexing"
date
if [ ! -e ${INDIR}${PRE}.mmi ];
then
minimap2 -d ${INDIR}${PRE}.mmi ${INDIR}${PRE}.fa
else
echo "index found"
fi

echo "Mapping ${SLURM_ARRAY_TASK_ID}: ${FASTQ}"
date
minimap2 -ax map-ont -t 32 ${INDIR}${PRE}.mmi ${FASTQ} | samtools sort -@ $SLURM_CPUS_PER_TASK -O BAM -o ${OUTDIR}${REF}-${SLURM_ARRAY_TASK_ID}.bam -
echo "mapped"

echo getting stats
samtools coverage ${OUTDIR}${REF}-${SLURM_ARRAY_TASK_ID}.bam -o ${OUTDIR}${REF}-${SLURM_ARRAY_TASK_ID}-ont-cov.txt
samtools stats -@ 32 ${OUTDIR}${REF}-${SLURM_ARRAY_TASK_ID}.bam > ${OUTDIR}${REF}-${SLURM_ARRAY_TASK_ID}-ont-stats.txt

echo plotting stats
plot-bamstats -p huhu-${SLURM_ARRAY_TASK_ID}-ont-stats ${OUTDIR}${REF}-${SLURM_ARRAY_TASK_ID}-ont-stats.txt
echo completed
