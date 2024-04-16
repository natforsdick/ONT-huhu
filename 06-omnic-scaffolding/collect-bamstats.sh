#!/bin/bash -e

# takes two parameters to run - the INDIR, and an input bam file

echo $1 $2
cd $1

ml purge && ml SAMtools

samtools depth -a -o depth.tsv $2

# then to calculate mean read depth (c = total positions, s = cumulative depth)
awk '{c++;s+=$3}END{print s/c}' depth.tsv 

# and breadth of coverage (c = total positions, total = increment +1 when depth > 0)
awk '{c++; if($3>0) total+=1}END{print (total/c)*100}' depth.tsv 

# get proportion of reads that successfully mapped to the reference
samtools flagstat $2 | awk -F "[(|%]" 'NR == 3 {print $2}'
