#!/bin/bash -e

# classifying repeatmodeler output unknowns (-u): run with 3 threads/cores (-t) and using the Tetrapoda elements (-d) from Repbase 
# and known elements (-k) from the same reference genome; append newly identified elements to the existing known 
# element library (-a) and write results to an output directory (-o)

ml purge
TMPDIR=/nesi/nobackup/ga03186/tmp-repclass/
mkdir -p $TMPDIR
export TMPDIR=$TMPDIR

ml RepeatMasker/4.1.0-gimkl-2020a SeqKit/2.4.0 bioawk/1.0 RMBlast/2.10.0-GCC-9.2.0

cd /nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/annotation/repeats

./repclassifier -t 3 -d Insecta -u huhu-families.priReti1.fa.unknown \
-k huhu-families.priReti1.fa.known -a huhu-families.priReti1.fa.known \
-o round-1_Repbase-insecta-Self
