#!/bin/bash -e
#SBATCH -A landcare03691
#SBATCH -J lrscaf
#SBATCH --cpus-per-task=6
#SBATCH --mem=8G
#SBATCH --time=00:05:00
#SBATCH --output %x.%j.out
#SBATCH --error %x.%j.err

DIR=/nesi/nobackup/landcare03691/data/output/lr-scaffolding/
ASM=02-assembly-purged.fa
ALN=aligned.mm
LRSCAF=/nesi/project/landcare03691/scripts/rata-moehau-genome-assembly/lr-scaffolding/lrscaf/target/

cd $DIR

# miniCntLen=minimum contig length for inclusion, t=input type (mm = minimap output file), identity = identity threshold for filtering invalid alignments, process = threads
# For the Minimap alignment file, the value should not be larger than 0.3 and the value could be set to 0.1.
java -Xmx8g -jar /nesi/project/landcare03691/scripts/rata-moehau-genome-assembly/lr-scaffolding/lrscaf/target/LRScaf-1.1.12.jar --contig $ASM --alignedFile $ALN -t mm --output ${DIR} --identity 0.2 --miniCntLen 500 --process 24
