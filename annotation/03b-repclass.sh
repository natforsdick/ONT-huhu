#!/bin/bash -e

ml purge
TMPDIR=/nesi/nobackup/ga03186/tmp-repclass/
mkdir -p $TMPDIR
export TMPDIR=$TMPDIR

ml RepeatMasker/4.1.0-gimkl-2020a SeqKit/2.4.0 bioawk/1.0 RMBlast/2.10.0-GCC-9.2.0
# classifying unknowns (-u) in iterative fashion: run with 3 threads/cores (-t) and using only the known elements (-k) from the 
# same reference genome; append newly identified elements to the existing known element library (-a) and 
# write results to an output directory (-o). No Repbase classification is used here.

cd /nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/annotation/repeats

for i in {2..5}
do
j=$(expr $i + 1)
echo iteration $i

./repclassifier -t 3 -u round-${i}-Self/round-${i}-Self.unknown \
-k round-${i}-Self/round-${i}-Self.known \
-a round-${i}-Self/round-${i}-Self.known -o round-${j}-Self
done
