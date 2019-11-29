featureCounts -t exon -g gene_id -a data/ref/AgamP4.12.annotation.gtf -p -o results/rnaseq_counts.txt \
        results/alignments_hisat2/2L/male_rt_1.2L.sorted.bam \
        results/alignments_hisat2/2L/male_rt_2.2L.sorted.bam \
        results/alignments_hisat2/2L/male_rt_3.2L.sorted.bam \
        results/alignments_hisat2/2L/female_rt_1.2L.sorted.bam \
        results/alignments_hisat2/2L/female_rt_2.2L.sorted.bam \
        results/alignments_hisat2/2L/female_rt_3.2L.sorted.bam \
        results/alignments_hisat2/2L/male_carcass_1.2L.sorted.bam \
        results/alignments_hisat2/2L/male_carcass_2.2L.sorted.bam \
        results/alignments_hisat2/2L/male_carcass_3.2L.sorted.bam \
        results/alignments_hisat2/2L/female_carcass_1.2L.sorted.bam \
        results/alignments_hisat2/2L/female_carcass_2.2L.sorted.bam \
        results/alignments_hisat2/2L/female_carcass_3.2L.sorted.bam