#!/bin/bash -e
#SBATCH -A landcare03691
#SBATCH -J minimap
#SBATCH --cpus-per-task=32
#SBATCH --mem=36G
#SBATCH --time=01:30:00
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

# Mapping processed long reads to assembly using minimap2 prior to running LRScaf
DIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/lr-scaffolding/
ASM=01-assembly-purged
ONT=2022-05-23-Huhu-20kb-q7-subset

ml purge
ml minimap2/2.24-GCC-11.3.0

cd $DIR
# LRScaf can't handle the ONT specific minimap2 flag `-ax map-ont`
minimap2 -t 24 ${ASM}.fa ${ONT}.fastq.gz > aln-2022-05-23-Huhu-20kb-q7.mm

