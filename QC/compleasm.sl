#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J compleasm # job name (shows up in the queue)
#SBATCH -c 24
#SBATCH --mem=24GB #
#SBATCH --time=00:45:00 #Walltime (HH:MM:SS)
#SBATCH --output %x.%j.out #
#SBATCH --error %x.%j.err #

# compleasm - 2023-06-15
# Genome assembly QC - BUSCO alternative

# PARAMS
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/omnic-r2/yahs/
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/BUSCO/
DB=/nesi/project/ga03048/insecta_odb10
ASM=huhu-shasta-purged-DT-yahsNMC_JBAT-mapped_scaffolds_final.fa

asm=$(basename $ASM .fa)

cd $INDIR
module purge
module load compleasm/0.2.2-gimkl-2022a

compleasm.py run -a ${INDIR}${ASM} -o ${OUTDIR}compleasm-${asm} -t $SLURM_CPUS_PER_TASK  -l insecta_odb10 -L $DB
