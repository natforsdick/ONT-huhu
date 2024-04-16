#!/bin/bash -e

# Assessing sequence data with NanoPlot - need to install: <https://github.com/wdecoster/NanoPlot>
# Takes 1 param: data directory
# This steps takes less couple of minutes with no resource required.
# -p = output prefix, -o = output directory, -c = colour scheme, --summary = sequencing summary txt file produced by guppy

INDIR=/nesi/nobackup/ga03186/Huhu_MinION/2022-11-07-Huhu-PB5/sup-fastq/02-trimfilt/

# To make conda work in your shell env:
source /opt/nesi/CS400_centos7_bdw/Miniconda3/4.8.3/etc/profile.d/conda.sh

conda activate NanoPlot
cd $INDIR
NanoPlot -t2 --fastq 02_2022-11-07-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq.gz -o /nesi/nobackup/ga03186/Huhu_MinION/2022-11-07-Huhu-PB5/sup-fastq/02-trimfilt/02_2022-11-07-Huhu-PB5_Huhu-PB5-pass_trimmed.fastq.QC/ -p 02_2022-11-07-Huhu-PB5_Huhu-PB5-pass_trimmed-nanoplot -c forestgreen --N50
conda deactivate
