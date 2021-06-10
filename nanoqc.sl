#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J NanoQC
#SBATCH --time 04:00:00 #
#SBATCH	-N 1
#SBATCH	-n 1
#SBATCH -c 4
#SBATCH --mem=6G
#SBATCH --partition=large
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=ALL
#SBATCH --output NanoQC.%j.out # CHANGE number for new run
#SBATCH --error NanoQC.%j.err #  CHANGE number for new run

###############
# ENVIRONMENT #
mkdir /nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-fastqs/
mkdir /nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-QC/

PASS=/nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/pass/
FAIL=/nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/fail/
###############

###############
# MODULES     #
module purge 
#module load Python/3.7.3-gimkl-2018b
module load Python/3.9.5-gimkl-2020a
###############

# Concatenating all and passed Huhu01 Fastq files, counting total reads, and running NanoQC.

echo 'Concatenating fastqs'
cat ${PASS}*.fastq | gzip > /nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-fastqs/Huhu01-A-B-pass.fastq.gz
cat ${PASS}*.fastq ${FAIL}*.fastq | gzip > /nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-fastqs/Huhu01-A-B-all.fastq.gz
echo 'Concatenated'

echo 'Counting passed reads'
zcat /nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-fastqs/Huhu01-A-B-pass.fastq.gz | echo $((`wc -l`/4))

echo 'Counting all reads'
zcat /nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-fastqs/Huhu01-A-B-all.fastq.gz | echo $((`wc -l`/4))

echo 'Beginning QC'
cd /nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-fastqs/
for f in *.fastq.gz
do
nanoQC ${f} -o /nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-QC/${f}.QC
echo 'Finished ${f} QC'
done

