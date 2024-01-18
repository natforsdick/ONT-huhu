#!/bin/bash -e

#SBATCH --job-name nextpolish
#SBATCH --account=landcare03691
#SBATCH --cpu 20
#SBATCH --mem=80G
#SBATCH --time=24:00:00
#SBATCH --output=%x_%j.out
#SBATCH --error=%x_%j.err
#SBATCH --mail-user=forsdickn@landcareresearch.co.nz
#SBATCH --mail-type=ALL

##########
# PARAMS #
INDIR=/nesi/nobackup/landcare03691/data/output/illumina/02-trimmed/
R1=${INDIR}EXT041-06_S6-all-R1.fq.gz
R2=${INDIR}EXT041-06_S6-all-R2.fq.gz
OUTDIR=/nesi/nobackup/landcare03691/data/output/polish/NextPolish/
REFDIR=/nesi/nobackup/landcare03691/data/output/polish/medaka/
REF=consensus.fasta
round=2
threads=20
read1=EXT041-06_S6-all-R1.fq.gz
read2=EXT041-06_S6-all-R2.fq.gz
NEXTPOLISH=/nesi/project/landcare03691/NextPolish/lib/nextpolish1.py
##########

mkdir -p $OUTDIR
cd $OUTDIR

ml purge && ml {Miniconda3;SAMtools/1.13-GCC-9.2.0;BWA/0.7.17-gimkl-2017a}
source /opt/nesi/CS400_centos7_bdw/Miniconda3/4.8.3/etc/profile.d/conda.sh
conda activate NextPolish # see whether it can use paralleltask in the nextpolish workflow

for ((i=1; i<=${round};i++)); do
#step 1:
   echo index the genome file and do alignment $i;
   bwa index ${REF};
   bwa mem -t ${threads} ${REFDIR}${REF} ${read1} ${read2} | samtools view --threads 3 -F 0x4 -b - | samtools fixmate -m --threads 3 - - | samtools sort -m 2g --threads 5 - | samtools markdup --threads 5 -r - sgs.sort.bam;
   echo index bam and genome files $i;
   samtools index -@ ${threads} sgs.sort.bam;
   samtools faidx ${REF};
   echo polish genome file $i;
   python ${NEXTPOLISH} -g ${REF} -t 1 -p ${threads} -s sgs.sort.bam > genome.polishtemp.fa;
   REF=genome.polishtemp.fa;
   echo round $i complete;
#step2:
   echo index genome file and do alignment $i;
   bwa index ${REF};
   bwa mem -t ${threads} ${REF} ${read1} ${read2} | samtools view --threads 3 -F 0x4 -b - | samtools fixmate -m --threads 3  - - | samtools sort -m 2g --threads 5 - | samtools markdup --threads 5 -r - sgs.sort.bam;
   echo index bam and genome files $i;
   samtools index -@ ${threads} sgs.sort.bam;
   samtools faidx ${REF};
   echo polish genome file $i;
   python ${NEXTPOLISH} -g ${REF} -t 2 -p ${threads} -s sgs.sort.bam > genome.nextpolish.fa;
   REF=genome.nextpolish.fa;
   echo round $i complete;
done;
#Finally polished genome file: genome.nextpolish.fa

echo collecting stats
/nesi/project/landcare03691/scripts/rata-moehau-genome-assembly/asm-QC/assemblathon_stats.pl genome.polishtemp.fa > genome.polishtemp-stats.txt
/nesi/project/landcare03691/scripts/rata-moehau-genome-assembly/asm-QC/assemblathon_stats.pl genome.nextpolish.fa > genome.nextpolish-stats.txt
echo pipeline complete
