
[![DOI](https://zenodo.org/badge/600898231.svg)](https://zenodo.org/badge/latestdoi/600898231)

<div align="center">
    <h1>${\color{brown}PAP:\ {\color{red}P}arallel\ {\color{red}A}nnotation\ {\color{red}P}ipeline}$</h1>
</div>

![dag](https://user-images.githubusercontent.com/43998702/218347952-633b9b35-2e9d-45b5-ad55-10a8ebe3794d.svg)

<div align="justify">
Parallel Annotation Pipeline was developed using the Snakemake workflow management system, providing a streamlined and automated approach to annotating protein sequences, enabling researchers to rapidly and accurately characterize large-scale proteomic data sets.
PAP integrates seamlessly with a range of existing bioinformatics tools and databases, allowing you to easily transfer annotations from multiple sources and combine them into a single, comprehensive annotation set.
Additionally, PAP version for HPC cluster and its highly parallelized architecture make it the ideal tool for researchers with this type of computing resources looking to annotate protein sequences.
</div>

## Dependencies:

> **blastp** (https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download)

> **diamond** (https://github.com/bbuchfink/diamond)

> **hmmscan** (http://hmmer.org/)

> **Perl** (https://www.perl.org/get.html) (v5.30.0)

[Databases](https://figshare.com/ndownloader/articles/22085267/versions/1)

## Installation:

### Option 1

PAP pipeline it is written in Snakemake and Perl. For greater convenience/ease of installing PAP, we use the [Apptainer/Singularity](https://apptainer.org/) container platform and build an image with the complete environment (script and dependencies) needed to run PAP.

You just need to [download](https://figshare.com/ndownloader/files/PAPSIF) the Singularity image **PAP** and have installed "Apptainer/Singularity". If you don't have it installed, you can install it:

**with Conda** 
>  conda install -c conda-forge singularity 

Alternatively, x86_64 RPMs are available on GitHub immediately after each Apptainer release and they can be installed directly from there:

**with RPMs**
>  sudo yum install -y https://github.com/apptainer/apptainer/releases/download/v1.1.3/apptainer-1.1.3-1.x86_64.rpm

**with DEB**
>  wget https://github.com/apptainer/apptainer/releases/download/v1.1.3/apptainer_1.1.3_amd64.deb

>  sudo apt-get install -y ./apptainer_1.1.3_amd64.deb

For more details of the Apptainer installation process, go [here](https://apptainer.org/docs/admin/main/installation.html).

### Option 2

Make sure you have all **dependencies** and **databases** properly installed. You also need to download and have **all the 'bin' scripts** in your path.

You can check [Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) on their site for more details of this.

## Quick usage: (Install Option 1)
  > PAP <protein.fasta>

  notes:
 
    1- You need to put "PAP" in your path, otherwise you must give the whole path so that it can be found.

    2- The input [fasta](https://en.wikipedia.org/wiki/FASTA_format) file must exist in your $HOME, otherwise you need to set the environment variable SINGULARITY_BIND
    to bind paths where your sequences are located
    ex: export SINGULARITY_BIND="../path/for/the/input/fasta"

## Quick usage: (Install Option 2)

For "protein.faa" file name run:
  > snakemake --cores <thread_numbers> -s /path/of/Snakefile

If protein fasta files have other names, then run:
  > snakemake --cores <thread_numbers> --config PROTREF="current_protein_fasta_filename" -s /path/of/Snakefile

  PROTREF= "protein.faa" # Fasta file of the reference proteins that we want to transfer or annotate in our genome. Default: "protein.faa"
  
## Output files

A file in tsv format with the annotation of the proteins.

### File "annotation_table.tbl"

![pap_output](https://user-images.githubusercontent.com/43998702/218347713-02934c45-2fcb-4413-9cd5-5a8c4728c13e.png)

## Citation
Estrada K, Verleyen J. PAP:Parallel Annotation Pipeline. 2021. doi:10.5281/zenodo.7958138

## Authors
**M.C. Karel Estrada; M.C Jerome Verleyen**

karel.estrada@ibt.unam.mx
Twitter: @kjestradag

## Acknowledgments

PAP wouldn't be the same without advice and suggestions from Alejandro Sánchez.

PAP uses [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html) for pipeline development, [Blastp](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download) and [HMMER](http://hmmer.org/) to perform alignments and [SignalP](https://github.com/fteufel/signalp-6.0) for signal peptide prediction. Additionally, PAP takes information from other databases such as [GO](http://geneontology.org/) and [KEGG](https://www.genome.jp/kegg/pathway.html) and incorporates it into the final annotation report.
