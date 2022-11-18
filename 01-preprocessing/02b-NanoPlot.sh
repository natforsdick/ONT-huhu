#!/bin/bash -e

# takes 1 parameter: the input directory name

ml purge
ml Miniconda3

source /opt/nesi/CS400_centos7_bdw/Miniconda3/4.8.3/etc/profile.d/conda.sh

conda activate NanoPlot

INDIR=/nesi/nobackup/ga03186/Huhu_MinION/${1}/sup-fastq/

cd $INDIR
NanoPlot -o ${INDIR}sup-fastq/sup-QC/ -p ${INDIR} -c forestgreen --N50 --summary sequencing_summary.txt

conda deactivate
ml purge
