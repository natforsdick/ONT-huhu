#!/bin/bash -e
#SBATCH -A ga03186
#SBATCH -J trimgalore
#SBATCH -c 4
#SBATCH --mem=1G
#SBATCH --array=1
#SBATCH --time=10:00:00 #Walltime (HH:MM:SS) 
#SBATCH --output=%x.%j.%a.out
#SBATCH --output=%x.%j.%a.err

# PARAMS
INDIR=/nesi/nobackup/ga03186/Huhu_MinION/illumina-data/
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/illumina-data/02-trimmed/
SAMPLE_LIST=($(<${INDIR}fastq.txt)) # only need R1s in sample_list file
SAMPLE=${SAMPLE_LIST[${SLURM_ARRAY_TASK_ID}]}

base=$(basename $SAMPLE _R1_001.fastq.gz)

#trim Illumina NovaSeq data with TrimGalore pipeline 
ml purge
ml TrimGalore/0.6.7-gimkl-2020a-Python-3.8.2-Perl-5.30.1

cd $INDIR
echo "Trimming ${base}"

trim_galore --paired --nextseq 28 --length 50 \
--three_prime_clip_R1 5 --three_prime_clip_R2 5 --clip_R1 20 --clip_R2 20 --2colour 20 \
--fastqc ${INDIR}${base}_R1_001.fastq.gz ${INDIR}${base}_R2_001.fastq.gz \
-o ${OUTDIR} --basename ${base}
# trims paired end reads of a sample to a minimum length of 50, does a 3' clip of 5 bp and 5' clip of 20 bp,
# performs clips with a 2-colour compatible quality phred score of 20, and clip of 20 bases

wait
echo "done trimming ${base}"

