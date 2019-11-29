library(DESeq2)
library(dplyr)
library(GenomicFeatures)
# Import & pre-process ----------------------------------------------------

# Import data from featureCounts - first for populations
countdata <- read.table("results/rnaseq_counts.txt", header=TRUE, row.names=1)

# Remove first five columns (chr, start, end, strand, length)
countdata <- countdata[,6:length(countdata)]

# Remove .bam or .sam from filenames
clean_colnames <- function(countdata) {
#   colnames(countdata) <- gsub("\\.[sb]am$", "", colnames(countdata))
  colnames(countdata) <- gsub("\\.2L\\.sorted\\.bam$", "", colnames(countdata))
  colnames(countdata) <- gsub("results\\.alignments_hisat2\\.2L\\.", "", colnames(countdata))

  return(countdata)
}

# Apply the function to clean colnames
countdata <- clean_colnames(countdata)

# Descriptive vector with sample conditions/tissues - order should follow the columns in counts data
sampleConditions = c("male_rt", "male_rt", "male_rt",
                     "female_rt", "female_rt", "female_rt",
                     "male_carcass", "male_carcass", "male_carcass",
                     "female_carcass", "female_carcass", "female_carcass")

# Analysis with DESeq2 ----------------------------------------------------

# Create a coldata frame and instantiate the DESeqDataSet. See ?DESeqDataSetFromMatrix
(coldata <- data.frame(row.names=colnames(countdata), sampleConditions))
dds <- DESeqDataSetFromMatrix(countData=countdata, colData=coldata, design=~sampleConditions)

# Run the DESeq pipeline
dds <- DESeq(dds)

# Gene lengths ------------------------------
# Obtain gene lengths from the annotation file - needed for FPKM calculation
txdb <- makeTxDbFromGFF("data/ref/AgamP4.12.annotation.gtf", format="gtf")
exons.list.per.gene <- exonsBy(txdb,by="gene")
exonic.gene.sizes <- lapply(exons.list.per.gene, function(x) {sum(width(reduce(x)))})
ex.gene.sizes <- as.data.frame(exonic.gene.sizes)
mcols(dds)$basepairs=t(ex.gene.sizes)
#  -----------------------------------------

# Save table with FPKM values
fpkm(dds) %>% write.table(file = 'results/expression_table.tab', col.names = T, row.names = T, quote = F)

# ---- Calculate differential expression between two conditions
res.male.carcass_rt <- results(dds, contrast=c("sampleConditions","male_carcass","male_rt"))
res.male.carcass_rt %>% write.table(file = 'results/DE_male_carcass_rt.tab', col.names = T, row.names = T, quote = F)
