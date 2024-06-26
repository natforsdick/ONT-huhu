#!/bin/bash -e
# create directory for full results
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/annotation/repeats/masking/
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/annotation/repeats/masking/05_full_out/
REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/yahs/
REF=huhu-medaka-mapped-NMC_JBAT.FINAL

mkdir -p $OUTDIR
cd $INDIR
echo summarising all

# combine full RepeatMasker result files - .cat.gz
cat 01_simple_out/${REF}.simple_mask.cat.gz \
02_eukaryota_out/${REF}.eukaryota.masked.fasta.cat.gz \
03_known_out/${REF}.known.masked.cat.gz \
04_unknown_out/${REF}.unknown.masked.fasta.cat.gz \
> 05_full_out/${REF}.full_mask.cat.gz

# combine RepeatMasker tabular files for all repeats - .out
cat 01_simple_out/${REF}.simple_mask.out \
<(cat 02_eukaryota_out/${REF}.eukaryota.masked.fasta.out | tail -n +4) \
<(cat 03_known_out/${REF}.known.masked.out | tail -n +4) \
<(cat 04_unknown_out/${REF}.unknown.masked.fasta.out | tail -n +4) \
> 05_full_out/${REF}.full_mask.out

# copy RepeatMasker tabular files for simple repeats - .out
cat 01_simple_out/${REF}.simple_mask.out > 05_full_out/${REF}.simple_mask.out

# combine RepeatMasker tabular files for complex, interspersed repeats - .out
cat 02_eukaryota_out/${REF}.eukaryota.masked.fasta.out \
<(cat 03_known_out/${REF}.known.masked.out | tail -n +4) \
<(cat 04_unknown_out/${REF}.unknown.masked.fasta.out | tail -n +4) \
> 05_full_out/${REF}.complex_mask.out

# combine RepeatMasker repeat alignments for all repeats - .align
cat 01_simple_out/${REF}.simple_mask.align \
02_eukaryota_out/${REF}.eukaryota.masked.fasta.align \
03_known_out/${REF}.known.masked.align \
04_unknown_out/${REF}.unknown.masked.fasta.align \
> 05_full_out/${REF}.full_mask.align

# resummarize repeat compositions from combined analysis of all RepeatMasker rounds
echo combining repeat masker outputs
ml purge
ml RepeatModeler/2.0.3-Miniconda3
ProcessRepeats -a -species eukaryota 05_full_out/${REF}.full_mask.cat.gz 2>&1 | tee logs/05_fullmask.log

# get stats about repeats
ml purge
ml seqk
REFDIR=/nesi/nobackup/landcare03691/data/output/07-annotation/
REF=metBart-contam-excl

echo getting stats
# calculate the length of the genome sequence in the FASTA
ml seqtk/1.4-GCC-11.3.0 Perl/5.34.1-GCC-11.3.0
seqtk comp ${REFDIR}${REF}.fa > refstats.txt
allLen=`awk '{sum+=$2;} END{print sum;}' refstats.txt`
# calculate the length of the N sequence in the FASTA
nLen=`seqtk comp ${REFDIR}${REF}.fa | datamash sum 9` 

echo tabulating outputs
# tabulate repeats per subfamily with total bp and proportion of genome masked
cat 05_full_out/${REF}.full_mask.out | tail -n +4 | awk -v OFS="\t" '{ print $6, $7, $11 }' |\
awk -F '[\t/]' -v OFS="\t" '{ if (NF == 3) print $3, "NA", $2 - $1 +1; else print $3, $4, $2 - $1 +1 }' |\
datamash -sg 1,2 sum 3 | grep -v "\?" |\
awk -v OFS="\t" -v genomeLen="${allLen}" '{ print $0, $4 / genomeLen }' > 05_full_out/${REF}.full_mask.tabulate
echo completed
