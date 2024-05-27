REFDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/omnic-scaffolding/shasta-purged-polished-omnic/yahs/
REF=huhu-medaka-mapped-NMC_JBAT.FINAL.fa
species=huhu
OUTDIR=/nesi/nobackup/ga03186/Huhu_MinION/combined-trimmed-data/annotation/repeats

date

cd $OUTDIR
ml purge
ml RepeatModeler/2.0.3-Miniconda3
BuildDatabase -name $species $REFDIR$REF

date
ml purge
