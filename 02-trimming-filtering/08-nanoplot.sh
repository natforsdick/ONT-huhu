#!/bin/bash -e

# Assessing sequence data with NanoPlot - need to install: <https://github.com/wdecoster/NanoPlot>
# Takes 1 param: data directory
# This steps takes less couple of minutes with no resource required.
# -p = output prefix, -o = output directory, -c = colour scheme, --summary = sequencing summary txt file produced by guppy

INDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/

# To make conda work in your shell env:
source /opt/nesi/CS400_centos7_bdw/Miniconda3/4.8.3/etc/profile.d/conda.sh

conda activate NanoPlot
cd $INDIR

for fastq in *Huhu-PB5-pass_trimmed.fastq.gz
do
filename=$(basename "$fastq")
filename=${filename%.fastq.gz}
echo running $filename
NanoPlot -t2 --fastq $fastq -o /nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/trimmed-QC/ -p nanoplot-${filename} -c forestgreen --N50
done

conda deactivate
