#!/bin/bash -e
# Generating FASTA from manually curated hic scaffolded assembly

##########
# PARAMS #
JUICER=/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/juicer
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/
REF=01-huhu-shasta-purged.fa
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/
PREFIX=01-huhu-shasta-purged-DT-yahsNMC_JBAT

cd $OUTDIR
# -o = output prefix, followed by input review.assembly, input liftover.agp, reference
$JUICER post -o $PREFIX ${PREFIX}.review.assembly ${PREFIX}.liftover.agp ${REFDIR}${REF}
