# RNA-seq tutorial / cheatsheet 
> Imperial College, 29/11/2019\
> Crisanti Lab, Nace Kranjc

## Operating system
It's going to be much easier to go through the tutorial and run your analysis if your operating system is macOS or Linux. For Windows users, it's recommended to install Linux Bash Shell. You can follow the instructions here: https://www.fosslinux.com/20686/how-to-run-ubuntu-using-the-windows-subsystem-for-linux.htm

## 1) Conda environment setup
We will first need to install conda and create an environment, which will allow us to install all the tools and packages required to run the analysis.

> Conda is an open-source, cross-platform, language-agnostic package manager and environment management system.

Miniconda is a small, bootstrap version that includes only conda, Python, the packages they depend on, and a small number of other useful packages. 

1) Go to: https://docs.conda.io/en/latest/miniconda.html. 

2) Download installer for your operating system from the list. Select Miniconda 3 (Python 3.7) version. Mac users - select the `pkg` version not `bash`.

3) Install Miniconda

4) Create a working directory (work dir) somewhere on your computer called `rnaseq_tutorial/`.

5) Open the Terminal and move to the work dir you've just created. If you need to refresh your memory of bash commands:
    - https://www.educative.io/blog/bash-shell-command-cheat-sheet 
    - https://www.unr.edu/research-computing/the-grid/using-the-grid/bash-commands
 
    Hint: use `cd`

6) By typing `conda` in the Terminal you can test if conda is successfully installed on your computer. If nothing happens, reopen the Terminal and try again.

7) Download the following file to your work dir https://raw.githubusercontent.com/nkran/rnaseq_tutorial/master/rnaseq_environment.yaml (ctrl+s)

    The file contains instructions for conda how to set up an environment and which packages need to be installed. The requirements file was pre-compiled.

    We are going to install the following packages and their dependencies:

    * Trimmomatic
    * FastQC
    * Hisat2
    * Kallisto
    * featureCounts
    * DESeq2
    * Sleuth

8) Create environment from the downloaded `rnaseq_environment.yml`:
    
    ```
    conda env create -f rnaseq_environment.yml
    ```

9) Activate environment:
    
    ```
    conda activate rnaseq
     ```

10) You should now see `(rnaseq)` instead of `(base)` in your command line. Something like this:

    ```
    (rnaseq) [~/imperial/rnaseq_tutorial] nace$
    ```

11) Test if the packages were installed successfully:

    ```
    conda list
    ```

    The output should be:

    ```
    # packages in environment at /Users/nace/opt/miniconda3/envs/rnaseq:
    #
    # Name Version Build Channel
    _r-mutex 1.0.1 anacondar_1 conda-forge
    appnope 0.1.0 py36_1000 conda-forge
    attrs 19.3.0 py_0 conda-forge
    backcall 0.1.0 py_0 conda-forge
    bash-kernel 0.7.2 pypi_0 pypi
    bioconductor-annotate 1.64.0 r36_0 bioconda
    bioconductor-annotationdbi 1.48.0 r36_0 bioconda
    bioconductor-biobase 2.46.0 r36h01d97ff_0 bioconda
    bioconductor-biocgenerics 0.32.0 r36_0 bioconda
    bioconductor-biocparallel 1.20.0 r36h6de7cb9_0 bioconda
    bioconductor-delayedarray 0.12.0 r36h01d97ff_0 bioconda
    bioconductor-deseq2 1.26.0 r36h6de7cb9_0 bioconda
    ...
    ```

12) Ok, we're now all set to begin.


## 2) Sequencing quality check
At the beginning we first need to ensure that the quality of obtained reads from the sequencing is good enough to be used in the analysis. This step is not specific to RNA-seq analysis and should be performed before starting any analysis dealing with short sequencing reads.

Quality control report can be generated with FastQC tool (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

1) Open FastQC
    
    ```
    fastqc
    ```

2) To run FastQC from the command line
    
    ```
    fastqc data/reads/raw/male_carcass_1_1.fastq.gz 
    ```
    This command will create a QC report for a single read file in the same folder as the read file. 

    To find out about other options of running FastQC you can use help command
    ```
    fastqc -h
    ```

    Out:
    ```
    fastqc [-o output dir] [--(no)extract] [-f fastq|bam|sam]
           [-c contaminant file] seqfile1 .. seqfileN
    ```

    Argument `-h` tells us about all available options and how to use them. For example, if we want to save the report into a separate folder to keep our folder with reads nice and tidy, we can specify argument `-o `. The argument `-h` works with most of the command line tools.

    ```
    fastqc -o data/reads/qc/ data/reads/raw/male_carcass_1_1.fastq.gz
    ```

    In case we want to run FastQC on multiple files with a single comand we can use the wildcard character `*` when specifying the input file. It allows all the files ending in `.fastq.gz` in folder `data/reads/raw/` to be specified and used in as input files.

    ```
    fastqc -o data/reads/qc/ data/reads/raw/*.fastq.gz
    ```

3) Reports are now in `data/reads/qc/`. More info about each category from the report can be found here: https://dnacore.missouri.edu/PDF/FastQC_Manual.pdf

4) To trimm the reads with low quality scores and filter out reads withouth pairs run Trimmomatic based on the following pattern:
    
    ```
    trimmomatic PE -phred33 <inputFile1> <inputFile2> <outputFile1P> <outputFile1U> <outputFile2P> <outputFile2U>
    ```
    In our case:
    ```
    trimmomatic PE -phred33 data/reads/raw/male_carcass_1_1.fastq.gz data/reads/raw/male_carcass_1_1.fastq.gz data/reads/raw/male_carcass_1_1P.fastq.gz data/reads/raw/male_carcass_1_1U.fastq.gz data/reads/raw/male_carcass_1_2P.fastq.gz data/reads/raw/male_carcass_1_2U.fastq.gz
    ```

    As we need to run Trimmomatic for several samples, we can write a bash script that will execute all the commands consequently. Open a text editor and save the script as `run_trimming.sh`.

    ```
    #!/bin/bash

    # male_carcass_1 
    trimmomatic PE -phred33 data/reads/raw/male_carcass_1_1.fastq.gz data/reads/raw/male_carcass_1_1.fastq.gz data/reads/raw/male_carcass_1_1P.fastq.gz data/reads/raw/male_carcass_1_1U.fastq.gz data/reads/raw/male_carcass_1_2P.fastq.gz data/reads/raw/male_carcass_1_2U.fastq.gz
    
    # male_carcass_2    
    trimmomatic PE -phred33 data/reads/raw/male_carcass_2_1.fastq.gz data/reads/raw/male_carcass_2_1.fastq.gz data/reads/raw/male_carcass_2_1P.fastq.gz data/reads/raw/male_carcass_2_1U.fastq.gz data/reads/raw/male_carcass_2_2P.fastq.gz data/reads/raw/male_carcass_2_2U.fastq.gz
    
    # male_rt_1
    trimmomatic PE -phred33 data/reads/raw/male_rt_1_1.fastq.gz data/reads/raw/male_rt_1_1.fastq.gz data/reads/raw/male_rt_1_1P.fastq.gz data/reads/raw/male_rt_1_1U.fastq.gz data/reads/raw/male_rt_1_2P.fastq.gz data/reads/raw/male_rt_1_2U.fastq.gz
    
    ```

    To run the script
    ```
    sh run_trimming.sh
    ```

## 2) Read alignment - Hisat2
Filtered and paired reads need to be aligned to a reference genome before the quantification and abundance estimation. We are going to use *Anopheles gambiae* AgamP4 reference genome. AgamP4 reference genome comes in FASTA file format, one sequence per chromosome. All resources for *An. gambiae* can be found on VectorBase (https://www.vectorbase.org/)

1) First step is building a reference genome index that is needed for Hisat2  aligner.
    ```
    hisat2-build data/ref/AgamP4.fa data/ref/AgamP4
    ```
2) Align the reads to the reference genome:
    ```
    hisat2 -x data/ref/AgamP4 -1 data/reads/1 -2 data/reads/2
    ```
3) Write a script with commands for all the samples, save it as `run_hisat2.sh` and run it! :bomb:
4)

 

# Other resources
https://github.com/crazyhottommy/RNA-seq-analysis