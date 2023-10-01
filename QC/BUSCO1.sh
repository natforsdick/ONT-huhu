#!/bin/bash -e

###################
# BUSCO - INSECTS - 2020-12-13
# Nat Forsdick
###################

# Load modules
module purge
module load BUSCO/5.2.2-gimkl-2020a
#cp -r $AUGUSTUS_CONFIG_PATH ./MyAugustusConfig

# Set up environment
#export AUGUSTUS_CONFIG_PATH=/nesi/project/ga03048/scripts/QC/MyAugustusConfig
#export BUSCO_CONFIG_FILE="/nesi/project/ga03048/scripts/config.ini"

OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/BUSCO/
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/lr-scaffolding/asm2-purged-longstitch/
samplist='01-assembly-purged.k32.w100.tigmint-ntLink.longstitch-scaffolds.fa' #'weta-hic-hifiasm.cns.fa'
INSECT_DB=/nesi/project/ga03048/insecta_odb10

for samp in $samplist
do

filename=$(basename "$samp")
filename=${filename%.*}

cd $OUTDIR

echo "Starting BUSCO for ${samp}"
# -f = force, -r = restart
	busco -i ${INDIR}${samp} -o BUSCO5_${filename} -f --offline -l ${INSECT_DB} -m geno -c 24
	echo "Finished BUSCO for ${samp}"
done

# To make BUSCO plots:
# ml BUSCO/5.2.2-gimkl-2020a R/4.1.0-gimkl-2020a
# generate_plot.py -wd ./


