#!/bin/bash 

ml purge
ml BEDTools/2.30.0-GCC-11.3.0

REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/yahs/
REF=huhu-medaka-mapped-NMC_JBAT.FINAL

cd /nesi/nobackup/ga03048/kaki-hifi-asm/asm3-hic-hifiasm-p/annotation/repeats/masking/05_full_out/

# create masked genome FASTA files
# create simple repeat soft-masked genome
bedtools maskfasta -soft -fi ${REFDIR}${REF}.fa -bed ${REF}.simple_mask.gff3 \
-fo ${REF}.simple_mask.soft.fasta
# create complex repeat hard-masked genome
bedtools maskfasta -fi ${REF}.simple_mask.soft.fasta \
-bed ${REF}.complex_mask.gff3 \
-fo ${REF}.simple_mask.soft.complex_mask.hard.fasta

ml purge
