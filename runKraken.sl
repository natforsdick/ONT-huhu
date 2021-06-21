#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J kraken
#SBATCH --time=00:06:00
#SBATCH -c 12
#SBATCH --mem=35G
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=FAIL,END
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err

# runKraken.sl
# Nat Forsdick, 2021-06-21
# Script to check Nanopore reads for contamination using Kraken2

###########
# MODULES #
###########
ml purge
ml load Kraken2/2.1.1-GCC-9.2.0
ml list 
###########

###########
# ENVIRO  #
###########
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-fastqs
targdata=/nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-fastqs/Huhu01-A-B-pass.fastq.gz
DB=/opt/nesi/db/Kraken2/standard-2018-09
###########

cd $INDIR
kraken2 --db ${DB} --threads ${SLURM_CPUS_PER_TASK} --use-names --report kreport.tab --gzip-compressed $targdata > kraken.out
