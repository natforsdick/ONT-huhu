#!/bin/bash -e

module purge
module load SAMtools/1.13-GCC-9.2.0

OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/05-blobtools/asm2-purged/

cd $OUTDIR

samtools merge 01-huhu-asm2-purged-all.bam 01-huhu-asm2-purged-0.bam 01-huhu-asm2-purged-1.bam 01-huhu-asm2-purged-2.bam 

ml purge
