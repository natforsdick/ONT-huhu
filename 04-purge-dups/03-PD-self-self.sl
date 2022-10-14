#!/bin/bash -e

#SBATCH --job-name=self-self
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
#SBATCH --time=01:00:00
#SBATCH --mem=32G
#SBATCH --ntasks=1
#SBATCH --profile=task 
#SBATCH --account=ga03186
#SBATCH --cpus-per-task=16

# Purge_dups pipeline
# Created by Sarah Bailey, UoA
# Modified by Nat Forsdick, 2021-08-24

# step 03: do a self-self alignment

#########
# MODULES
module purge
module load minimap2/2.24-GCC-11.3.0 
#########

#########
# PARAMS
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/02-purge-dups/
PRE=huhu-asm1 # PREFIX
R1=01- # Designate cutoffs round - either default (01) or modified (02) and whether Primary or Alternate assembly
R2=02-
#########

cd $OUTDIR
# -x asm5: intra-specific asm-to-asm alignment
if [ "$1" == "PRI" ]; then 
  minimap2 -x asm5 -t $SLURM_CPUS_PER_TASK -DP ${R1}${PRE}${PRI}.split ${R1}${PRE}${PRI}.split | gzip -c - > ${R1}${PRE}${PRI}.split.self.paf.gz
elif [ "$1" == "ALT" ]; then
  minimap2 -x asm5 -t $SLURM_CPUS_PER_TASK -DP ${R1}${PRE}${ALT}.split ${R1}${PRE}${ALT}.split | gzip -c - > ${R1}${PRE}${ALT}.split.self.paf.gz
else
  minimap2 -x asm5 -t $SLURM_CPUS_PER_TASK -DP ${R1}${PRE}.split ${R1}${PRE}.split | gzip -c - > ${R1}${PRE}.split.self.paf.gz
fi 
