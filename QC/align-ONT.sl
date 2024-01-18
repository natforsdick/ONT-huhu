#!/bin/bash -e

#SBATCH --job-name=minimap-ONT
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=23:00:00 # timed out during stats after 20hrs
#SBATCH --mem=54G # max 52 GB for huhu
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=32

# align-ONT.sl
# Align ONT reads to a reference using minimap2
# Nat Forsdick, 2021-10-28

#########
# MODULES
module purge
module load minimap2/2.20-GCC-9.2.0 
#########

#########
# PARAMS
#########
DIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/asm-QC/yahs-r2/
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/omnic-r2/yahs/
REF=huhu-shasta-purged-DT-yahsNMC_JBAT-mapped_scaffolds_final
ONTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/
ONT="${ONTDIR}02_2022-05-16-PB5_Huhu-PB5-pass_trimmed.fastq.gz ${ONTDIR}02_2022-05-30-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq.gz ${ONTDIR}02_2022-11-07-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq.gz ${ONTDIR}02_2022-11-01-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq.gz ${ONTDIR}02_2022-05-23-Huhu-SRE_Huhu-PB5-pass_trimmed.fastq.gz"
#########

cd $DIR

echo Indexing ${REF}

# To index reference genome the first time you run this - can then just call the index ref.mmi following this
minimap2 -t $SLURM_CPUS_PER_TASK -d ${REF}.mmi ${REFDIR}${REF}.fa

echo Aligning ONT against ${REF}
# To map HiFi reads to assembly
minimap2 -ax map-ont -t $SLURM_CPUS_PER_TASK ${REF}.mmi ${ONT} > ${REF}-ont.sam

echo Converting to bam
ml SAMtools/1.13-GCC-9.2.0
samtools view -bS -@ $SLURM_CPUS_PER_TASK ${REF}-ont.sam | samtools sort -@ $SLURM_CPUS_PER_TASK -o ${REF}-ont.bam

echo indexing BAM
samtools index -c ${REF}-ont.bam

echo getting stats
samtools coverage ${REF}-ont.bam -o ${REF}-ont-cov.txt
samtools stats -@ $SLURM_CPUS_PER_TASK ${REF}-ont.bam > ${REF}-ont-stats.txt

echo plotting stats
plot-bamstats -p ${REF}-ont-stats ${REF}-ont-stats.txt
echo completed
