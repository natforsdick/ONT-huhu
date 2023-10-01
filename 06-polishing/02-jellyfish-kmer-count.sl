#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J jellyfish-S2
#SBATCH --time=04:00:00 # 35 min is sufficient for jellyfish steps
#SBATCH -c 36
#SBATCH --mem=30G
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err

# kmer-count.sl
# 2022-05-27, Nat Forsdick
# Counting kmers for genome size estimation.
# Can use GenomeScope web assessment to estimate genome size.
# Requires jellyfish kmer histogram report as input.
# https://genome.umd.edu/docs/JellyfishUserGuide.pdf

##########
# PARAMS
DATADIR=/nesi/nobackup/ga03186/Huhu_MinION/illumina-data/02-trimmed/
READS=EXT041-02_S2
mer=21
CPU=20
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/illumina-data/03-GenomeScope/
##########

ml purge
ml Jellyfish/2.3.0-gimkl-2020a
cd ${DATADIR}

# To generate: -C = canonical (necessary), -m = kmers, -s = hash size, -t = threads

echo 'Beginning jellyfish bloom'
date
jellyfish bc -C -m ${mer} -s 3G -t ${CPU} -o ${OUTDIR}huhu-EXT041-02-${mer}mer.bc <(zcat ${READS}_L001_val_1.fq.gz) <(zcat ${READS}_L001_val_2.fq.gz) <(zcat ${READS}_L002_val_1.fq.gz) <(zcat ${READS}_L002_val_2.fq.gz)

echo 'Beginning jellyfish count'
jellyfish count -C -m ${mer} -s 3G -t ${CPU} --bc ${OUTDIR}huhu-EXT041-02-${mer}mer.bc -o ${OUTDIR}huhu-EXT041-02-${mer}mer-counts.jf <(zcat ${READS}_L001_val_1.fq.gz) <(zcat ${READS}_L001_val_2.fq.gz) <(zcat ${READS}_L002_val_1.fq.gz) <(zcat ${READS}_L002_val_2.fq.gz)

echo 'Beginning jellyfish histo'
date
jellyfish histo -t ${CPU} ${OUTDIR}huhu-EXT041-02-${mer}mer-counts.jf > ${OUTDIR}huhu-EXT041-02-${mer}mer-histo.out

echo 'Completed kmer-count'
date
