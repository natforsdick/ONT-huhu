#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J longstitch
#SBATCH --time=02:30:00
#SBATCH --mem=18G
#SBATCH --cpus-per-task=32
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err

module purge
module load LongStitch/1.0.4-Miniconda3

cd /nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/lr-scaffolding/

# be sure that your input reads are in .fq.gz format - pipeline doesn't actually like .fastq despite the readme saying it's fine
longstitch run draft=01-huhu-asm1-purged reads=02_2022-11-all-Huhu-PB5-pass_trimmed-20kb G=1700000000 longmap=ont t=26

ml purge
