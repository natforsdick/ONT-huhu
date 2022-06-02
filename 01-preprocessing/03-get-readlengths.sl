#!/bin/bash
#SBATCH -A ga03186
#SBATCH -J readlength
#SBATCH --time 00:30:00
#SBATCH -c 1
#SBATCH --mem=100M
#SBATCH --output readlength.%j.out
#SBATCH --error readlength.%j.err

module purge

PASSDIR=/nesi/nobackup/ga03186/Huhu_MinION/2022-05-16-PS5/hac-fastq/combined-hac-fastqs/

cd $PASSDIR
zcat Huhu-PS5-pass.fastq.gz | awk '{if(NR%4==2) print length($1)}' | sort -n | uniq -c > pass_read_length.txt

#cd $FAILDIR
#for f in *.fastq;
#do
#	awk '{if(NR%4==2) print length($1)}' ${f} | sort -n | uniq -c >> ${f}_fail_read_length.txt
#done

