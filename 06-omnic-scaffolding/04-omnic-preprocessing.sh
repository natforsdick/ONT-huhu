#!/bin/bash -e

ml purge 
ml SAMtools/1.15.1-GCC-11.3.0 BWA/0.7.17-GCC-11.3.0

INDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/omnic-r2/
REF=01-huhu-shasta-purged-DT-yahsNMC_JBAT.FINAL # prefix
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/omnic-r2/
TMPDIR=/nesi/nobackup/ga03186/tmp-omnic

mkdir $TMPDIR
export TMPDIR

cd $OUTDIR

#ln -s ${INDIR}${REF}.fa ${OUTDIR}${REF}.fa

samtools faidx $REF.fa

cut -f1,2 $REF.fa.fai > $REF.genome

bwa index $REF.fa
