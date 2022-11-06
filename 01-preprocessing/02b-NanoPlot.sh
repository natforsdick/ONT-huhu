!/bin/bash -e

# takes 1 parameter: the input directory name

ml purge
ml Miniconda3

conda activate NanoPlot
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/${1}/sup-fastq/

NanoPlot -o ${1} -p ${INDIR} -c forestgreen --N50 --summary sequencing_summary.txt

conda deactivate
ml purge
