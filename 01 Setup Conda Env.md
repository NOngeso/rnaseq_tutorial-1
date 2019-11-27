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