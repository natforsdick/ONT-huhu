#!/bin/bash

# 2021-06-16
# Script to conduct adapter trimming and quality trimming and filtering of Nanopore data

###############
# ENVIRONMENT #

module purge
module load Porechop/0.2.4-gimkl-2020a-Python-3.8.2 nanofilt/2.6.0-gimkl-2020a-Python-3.8.2
###############

cd $INDIR

OUTDIR=../02-trimfilt/

if [ -e $OUTDIR ]; then
        echo $OUTDIR exists
else
    	mkdir -p $OUTDIR
fi

# Let's get rid of adapters
# To use Nanopolish downstream, you must use --discard_middle - this removes reads with adapter within them.
echo "Starting Porechop"

porechop -i ${INDIR}${file}.fastq.gz -o ${OUTDIR}01_${file}_adaprem.fastq \
--discard_middle -t $SLURM_CPUS_PER_TASK

# Now let's trim and filter to remove poor quality ends and short reads
# l = minimum length, q = minimum average quality
echo "Starting NanoFilt"
NanoFilt -l 500 -q 9 --headcrop 50 --tailcrop 50 ${OUTDIR}01_${file}_adaprem.fastq |\
 gzip > ${OUTDIR}02_${file}_trimmed.fastq.gz

