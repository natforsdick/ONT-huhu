#!/bin/bash -e

#SBATCH --account        ga03186
#SBATCH --job-name       ont-huuh-guppy-gpu
#SBATCH --gpus-per-node  A100:1
#SBATCH --mem            6G
#SBATCH --cpus-per-task  4
#SBATCH --time           10:00:00
#SBATCH --output         %x.%j.out
#SBATCH --error         %x.%j.err

module purge
module load ont-guppy-gpu/6.1.2

guppy_basecaller -i /nesi/project/ga03186/data/Huhu-MinION/2022-05-16-PS5/fast5 \
-s /nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/fastq \
--config /opt/nesi/CS400_centos7_bdw/ont-guppy-gpu/6.1.2/data/dna_r9.4.1_450bps_hac.cfg \
--device auto --recursive --records_per_fastq 4000 \
--detect_mid_strand_adapter
