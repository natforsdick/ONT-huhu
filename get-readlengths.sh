#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J readlength
#SBATCH --time 00:03:00
#SBATCH -c 1
#SBATCH --mem=100M
#SBATCH --output readlength.%j.out
#SBATCH --error readlength.%j.err

module purge

INDIR=/nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/fail

cd $INDIR
# zcat Huhu01-A-B-all.fastq.gz | awk '{if(NR%4==2) print length($1)}' | sort -n | uniq -c > all_read_length.txt
for f in *.fastq
do
awk '{if(NR%4==2) print length($1)}' ${f} | sort -n | uniq -c >> ${f}_fail_read_length.txt
done

cat *_pass_read_length.txt | sort -k 2 -n > sorted_indiv_fail_read_length.txt
