#!/bin/bash -e
#SBATCH --account=ga03186
#SBATCH --job-name=fastp 
#SBATCH --cpus-per-task=12 
#SBATCH --mem=3G # 3 GB full data set
#SBATCH --time=00:20:00  #1hr 30 for full data
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --output %x.%j.out # CHANGE number for new run
#SBATCH --error %x.%j.err #  CHANGE number for new run

##########
# PARAMS
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/
ASSEMBLY=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/02-purge-dups/asm3-shasta/01-huhu-shasta-purged.fa
APREFIX=huhu-omnic-MiSeq
HIC_DIR=/nesi/nobackup/ga03186/Huhu_MinION/2023-09-25-OmniC-QC/
HIC_RAW1=${HIC_DIR}2023-OmniC-MiSeq-QC/Huhu-HiC-QC_S1_L001_R
READ1=${HIC_RAW1}1_001.fastq.gz
READ2=${HIC_RAW1}2_001.fastq.gz
HIC_RAW2=${HIC_DIR}2023-OmniC-MiSeq-QC/Huhu-HiC-QC_S1_L001_R
READ3=${HIC_RAW2}1_001.fastq.gz
READ4=${HIC_RAW2}2_001.fastq.gz
############

ml purge && module load fastp/0.23.2-GCC-11.3.0

### Clean HiC Reads with fastp.###
echo processing $READ1
fastp \
-i ${READ1} \
-o ${HIC_DIR}${APREFIX}_clean1_R1.fastq.gz \
-I ${READ2} \
-O ${HIC_DIR}${APREFIX}_clean1_R2.fastq.gz \
--trim_front1 15 \
--trim_front2 15 \
--qualified_quality_phred 20 \
--length_required 50 \
--thread 12

#echo processing $READ3
#fastp \
#-i ${READ3} \
#-o ${HIC_DIR}/${APREFIX}_clean2_R1.fastq.gz \
#-I ${READ4} \
#-O ${HIC_DIR}/${APREFIX}_clean2_R2.fastq.gz \
#--trim_front1 15 \
#--trim_front2 15 \
#--qualified_quality_phred 20 \
#--length_required 50 \
#--thread 12
