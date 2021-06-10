#!/bin/bash -e

#SBATCH --job-name=sup_guppy
#SBATCH --time=1-12:00:00
#SBATCH --partition=gpu
#SBATCH --gres=gpu:1
#SBATCH --mem=7G
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --output=huhu_guppy_%j.out
#SBATCH --error=huhu_guppy_%j.err
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=ALL
#SBATCH --account=ga03186

###############
# MODULES     #
###############
ml purge
ml load ont-guppy-gpu/5.0.7
###############

###############
# ENVIRONMENT #
###############
data=/nesi/nobackup/ga03186/Huhu_MinION/
output=/nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup
config=/opt/nesi/CS400_centos7_bdw/ont-guppy-gpu/5.0.7/data/dna_r9.4.1_450bps_sup.cfg
###############

guppy_basecaller -i ${data} -s ${output} --config ${config} --device auto --recursive \
--records_per_fastq 4000 --min_qscore 7 --calib_detect --detect_mid_strand_adapter --resume
