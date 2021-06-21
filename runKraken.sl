ml purge
ml load Kraken2/2.1.1-GCC-9.2.0

targdata=/nesi/nobackup/ga03186/Huhu_MinION/2021-05-28_Batch1/Guppy5_sup/combined-fastqs/Huhu01-A-B-pass.fastq.gz

kraken2 --db $minikraken --threads 12 --use-names --report kreport.tab --fastq-input $targdata > kraken.out
