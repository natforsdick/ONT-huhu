#!/bin/bash -e

ml purge 
ml SAMtools/1.15.1-GCC-11.3.0 BWA/0.7.17-GCC-11.3.0

INDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/05-polish/02-medaka/
REF=medaka-consensus # prefix
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/
TMPDIR=/nesi/nobackup/ga03186/tmp-omnic

mkdir $TMPDIR
export TMPDIR=$TMPDIR

cd $OUTDIR

ln -s ${INDIR}${REF}.fasta ${OUTDIR}${REF}.fa

samtools faidx $REF.fa

cut -f1,2 $REF.fa.fai > $REF.genome

bwa index $REF.fa
