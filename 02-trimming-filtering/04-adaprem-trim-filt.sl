#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J nano-filt-trim
#SBATCH --time=07:00:00
#SBATCH --cpus-per-task=24
#SBATCH --mem=54G
#SBATCH --partition=large
#SBATCH --output %x.%j.out 
#SBATCH --error %x.%j.err

# 2021-06-16
# Script to conduct adapter trimming and quality trimming and filtering of Nanopore data

###############
# ENVIRONMENT #

module purge
module load Porechop/0.2.4-gimkl-2020a-Python-3.8.2 nanofilt/2.6.0-gimkl-2020a-Python-3.8.2
###############
samplist="2022-05-16-PB5 2022-05-23-Huhu-SRE 2022-05-30-Huhu-PB5"
file=Huhu-PB5-pass

for samp in $samplist
do
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/${samp}/sup-fastq/combined-sup-fastqs/
cd $INDIR

OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/${samp}/sup-fastq/02-trimfilt/

if [ ! -e $OUTDIR ]; then
        mkdir -p $OUTDIR
fi

# Let's get rid of adapters
# To use Nanopolish downstream, you must use --discard_middle - this removes reads with adapter within them.
#echo "Starting Porechop"
#date

#porechop -i ${INDIR}${file}.fastq.gz -o ${OUTDIR}01_${samp}_${file}_adaprem.fastq --discard_middle -t $SLURM_CPUS_PER_TASK

# Now let's trim and filter to remove poor quality ends and short reads
# l = minimum length, q = minimum average quality
echo "Starting NanoFilt"
date
cd $OUTDIR
NanoFilt -l 500 -q 9 --headcrop 50 --tailcrop 50 01_${samp}_${file}_adaprem.fastq | gzip > 02_${samp}_${file}_trimmed.fastq.gz
done

