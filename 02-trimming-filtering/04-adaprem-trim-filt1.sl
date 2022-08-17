#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J nano-filt-trim
#SBATCH --time=02:30:00
#SBATCH --cpus-per-task=14
#SBATCH --mem=28G
#SBATCH --partition=large
#SBATCH --output %x.%j.out 
#SBATCH --error %x.%j.err

export INDIR="/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PB5/sup-fastq/combined-sup-fastqs/ \
/nesi/nobackup/ga03186/Huhu_MinION/2022-05-30-Huhu-PB5/sup-fastq/combined-sup-fastqs/"
export file=Huhu-PB5-pass

bash 04-adaprem-trim-filt1.sh
