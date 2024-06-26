#!/bin/bash

# converting masked outputs to GFF3 format
toGFF=/nesi/project/ga03186/kaki-genome-assembly/annotation/
cd /nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/annotation/repeats/masking/05_full_out/
REF=huhu-medaka-mapped-NMC_JBAT.FINAL

# use Daren's custom script to convert .out to .gff3 for all repeats, simple repeats only, and complex repeats only
# https://github.com/darencard/GenomeAnnotation/blob/master/rmOutToGFF3custom
${toGFF}rmOutToGFF3custom -o ${REF}.full_mask.out > ${REF}.full_mask.gff3
${toGFF}rmOutToGFF3custom -o ${REF}.simple_mask.out > ${REF}.simple_mask.gff3
${toGFF}rmOutToGFF3custom -o ${REF}.complex_mask.out > ${REF}.complex_mask.gff3
