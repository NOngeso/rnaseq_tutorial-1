trimmomatic PE -phred33 data/reads/raw/male_carcass_1_1.fastq.gz \
                        data/reads/raw/male_carcass_1_2.fastq.gz \
                        data/reads/trimmed/male_carcass_1_1.p.fastq.gz \
                        data/reads/trimmed/male_carcass_1_1.u.fastq.gz \
                        data/reads/trimmed/male_carcass_1_2.p.fastq.gz \
                        data/reads/trimmed/male_carcass_1_2.u.fastq.gz \
                        ILLUMINACLIP:/Users/nace/opt/miniconda3/envs/rnaseq/share/trimmomatic/adapters/TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36