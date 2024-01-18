#!/bin/bash -e

#SBATCH --job-name=minimap-HiSeq
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=10:00:00 # used 
#SBATCH --mem=28G 
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=32

# align-HiSeq.sl
# Align HiSeq reads to a reference using minimap
# Nat Forsdick, 2021-10-28
 
#########
# MODULES
module purge
module load minimap2/2.20-GCC-9.2.0 SAMtools/1.13-GCC-9.2.0
#########

#########
# PARAMS
#########
DIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/asm-QC/yahs-r2/
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/omnic-r2/yahs/
REF=huhu-shasta-purged-DT-yahsNMC_JBAT-mapped_scaffolds_final
HISEQDIR=/nesi/nobackup/ga03186/Huhu_MinION/illumina-data/02-trimmed/
INPUT=S2_
HISEQ=EXT041-02_${INPUT}
R1=trimmed_R1.fq.gz
R2=trimmed_R2.fq.gz
#########

cd $DIR

echo Aligning ${HISEQ} against ${REF}

# To index reference genome the first time you run this - can then just call the index ref.mmi following this
#minimap2 -t $SLURM_CPUS_PER_TASK -d ${REF}.mmi ${REFDIR}${REF}.fa

# To map HiSeq reads to assembly
echo Aligning illumina data starting ${HISEQ}${INPUT}${R1}
minimap2 -ax sr -t $SLURM_CPUS_PER_TASK ${REF}.mmi ${HISEQDIR}${HISEQ}${R1} ${HISEQDIR}${HISEQ}${R2} > ${REF}-${INPUT}ill.sam 
samtools view -bS -@ $SLURM_CPUS_PER_TASK ${REF}-${INPUT}ill.sam | samtools sort -@ $SLURM_CPUS_PER_TASK -o ${REF}-${INPUT}ill.bam

echo indexing BAM
samtools index -c ${REF}-${INPUT}ill.bam

echo Getting stats
samtools coverage ${REF}-${INPUT}ill.bam -o ${REF}-${INPUT}ill-cov.txt
samtools stats -@ $SLURM_CPUS_PER_TASK ${REF}-${INPUT}ill.bam > ${REF}-${INPUT}ill-stats.txt

echo Plotting stats
plot-bamstats -p ${REF}-${INPUT}ill-stats ${REF}-${INPUT}ill-stats.txt 
