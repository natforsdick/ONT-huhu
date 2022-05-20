#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J NanoQC
#SBATCH --time 04:00:00 #
#SBATCH -c 4
#SBATCH --mem=6G
#SBATCH --partition=large
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=ALL
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err 

###############
# PARAMS
combined=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/combined-fastqs/
combinedQC=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/combined-nanoQC/

PASS=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/Guppy-6.1.2/pass/
FAIL=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/Guppy-6.1.2/fail/
###############

###############
# MODULES     
module purge 
module load Miniconda3/4.9.2

source /opt/nesi/CS400_centos7_bdw/Miniconda3/4.9.2/etc/profile.d/conda.sh

conda activate nanoQC 
###############

# Concatenating all and passed Huhu-PS5 fastq files, counting total reads, and running NanoQC.

echo 'Concatenating fastqs'
cat ${PASS}*.fastq | gzip > /nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/combined-fastqs/Huhu-PS5-pass.fastq.gz
cat ${PASS}*.fastq ${FAIL}*.fastq | gzip > /nesi/nobackup/ga03186/Huhu_MinION/2022-05-16/combined-fastqs/Huhu-PS5-all.fastq.gz
echo 'Concatenated'

echo 'Counting passed reads'
zcat /nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/combined-fastqs/Huhu-PS5-pass.fastq.gz | echo PASSED $((`wc -l`/4))

echo 'Counting all reads'
zcat /nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/combined-fastqs/Huhu-PS5-all.fastq.gz | echo ALL $((`wc -l`/4))

echo 'Beginning QC'
cd ${combined}
for f in *.fastq.gz
do
nanoQC ${f} -o ${combinedQC}${f}.QC
echo 'Finished ${f} QC'
done

