#!/bin/bash

ml purge

REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/yahs/
REF=huhu-medaka-mapped-NMC_JBAT.FINAL

cd /nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/annotation/repeats/masking/
# calculate the length of the genome sequence in the FASTA
ml seqtk/1.4-GCC-11.3.0

# calculate the length of the genome sequence in the FASTA
allLen=`seqtk comp ${REFDIR}${REF}.fa | datamash sum 2`;
# calculate the length of the N sequence in the FASTA
nLen=`seqtk comp ${REFDIR}${REF}.fa | datamash sum 9`;
# tabulate repeats per subfamily with total bp and proportion of genome masked
cat 05_full_out/${REF}.full_mask.out | tail -n +4 | awk -v OFS="\t" '{ print $6, $7, $11 }' |\
awk -F '[\t/]' -v OFS="\t" '{ if (NF == 3) print $3, "NA", $2 - $1 +1; else print $3, $4, $2 - $1 +1 }' |\
datamash -sg 1,2 sum 3 | grep -v "\?" |\
awk -v OFS="\t" -v genomeLen="${allLen}" '{ print $0, $3 / genomeLen*100 }' > 05_full_out/${REF}.full_mask.tabulate
