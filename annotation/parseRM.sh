#!/bin/bash

cd /nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/annotation/repeats/masking/05_full_out/
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/yahs/
REF=huhu-medaka-mapped-NMC_JBAT.FINAL

# calculate the length of the genome sequence in the FASTA
ml purge
ml seqtk/1.4-GCC-11.3.0 Perl/5.34.1-GCC-11.3.0

allLen=`seqtk comp ${REFDIR}${REF}.fa | datamash sum 2`;
/nesi/project/ga03186/kaki-genome-assembly/annotation/parseRM.pl -v -i ${REF}.full_mask.align -p -g ${allLen} -l 50,1 2>&1 | tee ../logs/06_parserm.log
