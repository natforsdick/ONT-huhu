#!/bin/bash -e 
#SBATCH -A ga03186 # CHANGE!! 
#SBATCH -J fastqc # job name (shows up in the queue) 
#SBATCH -c 4
#SBATCH --mem=22G 
#SBATCH --time=04:00:00 #Walltime (HH:MM:SS) 
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err     

################### 
# FastQC 
# Nat Forsdick, 2022-06-01
################### 

# F+R fastqs of ~60G take ~2.5 hrs to run.

# This script takes one argument, $1 : the path to the input directory. 
# e.g. to execute:
# sbatch run_array_fastqc.sl /nesi/nobackup/ga03048/data/illumina/ 

#### MODULES ####
module purge
module load FastQC/0.11.9  
## MultiQC/1.9-gimkl-2020a-Python-3.8.2
#################

#### ENVIRONMENT #### 
IN_DIR=$1
fq=*.fastq.gz
CPU=6
#####################

cd ${IN_DIR}

for f in $fq
do
fastqc -t 8 ${IN_DIR}${f}
done 
