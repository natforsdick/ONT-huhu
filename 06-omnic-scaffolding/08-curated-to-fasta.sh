#!/bin/bash -e
# Generating FASTA from manually curated hic scaffolded assembly

##########
# PARAMS #
JUICER=/nesi/project/ga03186/scripts/Hi-C_scripts/yahs/juicer
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/
REF=medaka-consensus.fa
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/yahs/
PREFIX=huhu-medaka-mapped-NMC_JBAT

cd $OUTDIR
# -o = output prefix, followed by input review.assembly, input liftover.agp, reference
$JUICER post -o $PREFIX ${PREFIX}.review.assembly ${PREFIX}.liftover.agp ${REFDIR}${REF}
