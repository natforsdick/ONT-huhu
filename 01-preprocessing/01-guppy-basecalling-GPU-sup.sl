#!/bin/bash -e

#SBATCH --account        ga03186
#SBATCH --job-name       ont-huhu-guppy-gpu
#SBATCH --gpus-per-node  A100:1
#SBATCH --mem            4G
#SBATCH --cpus-per-task  4
#SBATCH --time           10:00:00 # 9.5 hrs for 19.2 Gb input
#SBATCH --output         %x.%j.out
#SBATCH --error         %x.%j.err

# 01-guppy-basecalling-GPU-sup.sl
# 2022-05-23, Nat Forsdick
# Running Guppy basecalling for Nanopore fast5 reads.

#########
# PARAMS
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/2022-11-01-Huhu-PB5/20221101_1338_MN35694_FAS87731_5a9a6899/fast5/
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/2022-11-01-Huhu-PB5/
SUPCFG=/nesi/project/ga03186/scripts/ONT-scripts/guppy-cfg/dna_r9.4.1_450bps_sup.cfg
#########

module purge
module load ont-guppy-gpu/6.1.2

guppy_basecaller -i ${INDIR} -s ${OUTDIR}sup-fastq --config ${SUPCFG} \
--device auto --recursive --records_per_fastq 4000 \
--detect_mid_strand_adapter
