
<div align="center">
  <h1>${\color{brown}PAP}$</h1>
  <h1>${{\color{red}P}arallel\ {\color{red}A}nnotation\ {\color{red}P}ipeline}$</h1>
</div>

<div align="justify">
Parallel Annotation Pipeline was developed using the Snakemake workflow management system, providing a streamlined and automated approach to annotating protein sequences, enabling researchers to rapidly and accurately characterize large-scale proteomic data sets.
Parallel Annotation Pipeline integrates seamlessly with a range of existing bioinformatics tools and databases, allowing you to easily transfer annotations from multiple sources and combine them into a single, comprehensive annotation set.
Additionally, PAP version for HPC cluster and its highly parallelized architecture make it the ideal tool for researchers with this type of computing resources looking to annotate protein sequences.
</div>

## Dependencies:

> **blastp** (https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download)

> **hmmscan** (http://hmmer.org/)

> **Perl** (https://www.perl.org/get.html) (v5.30.0)

## Installation:

### Option 1

PAP pipeline it is written in Snakemake and Perl. For greater convenience/ease of installing PAP, we use the [Apptainer/Singularity](https://apptainer.org/) container platform and build an image with the complete environment (script and dependencies) needed to run PATT.

You just need to [download](https://figshare.com/ndownloader/files/37939014) the Singularity image **PAP** and have installed "Apptainer/Singularity". If you don't have it installed, you can install it:

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

Make sure you have all **dependencies** installed.
You also need to download and have in your path **all the "bin" scripts**.

You can check [Snakemake](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html) on their site for more details of this.

## Quick usage: (Install Option 1)
  > PAP <genome.fasta> <protein.fasta>

  notes:
 
    1- You need to put "PAP" in your path, otherwise you must give the whole path so that it can be found.

    2- The input [fasta](https://en.wikipedia.org/wiki/FASTA_format) file must exist in your $HOME, otherwise you need to set the environment variable SINGULARITY_BIND
    to bind paths where your sequences are located
    ex: export SINGULARITY_BIND="../path/for/the/input/fasta"

## Quick usage: (Install Option 2)

For genome.fasta and protein.faa file name run:
  > snakemake --cores <number of threads> -s /path/of/Snakefile

If genome or protein fastas files have other names, then run:
  > snakemake --cores <core_numbers> --config PROTREF="current_protein_fasta_filename" GENOME="current_genome_fasta_filename"

### More options

  > snakemake --cores <core_numbers> --rerun-incomplete --config PROTREF="protein.faa" GENOME="genome.fasta" PREFIX="prefix_outputfilename" NEWPREFIX="prefix_newgenenames_" -s path/of/Snakefile_PATT

  **About variables that PATT optionally needs:**
  
  PROTREF= "protein.faa" # Fasta file of the reference proteins that we want to transfer or annotate in our genome. Default: "protein.faa"
  
## Output files

The output of RaPDTool produces 4 files:

### File "<prefix>.gff"

Annotation file in [GFF](https://www.ensembl.org/info/website/upload/gff.html#fields) format of the transferred proteins.

### File "<prefix>.gbk"

Annotation file in [GenBank](https://www.ncbi.nlm.nih.gov/Sitemap/samplerecord.html) format of the transferred proteins.
  
### File "<prefix>.ffn"

Fasta file of all coding sequences (CDs).
  
### File "<prefix>.faa"

<p align="justify">
Fasta file of the peptide sequences.
</p>

## Acknowledgments

Developers: **M.C. Karel Estrada; M.C Jerome Verleyen**

PAP wouldn't be the same without my fellow researchers at the UUSMB (Unidad Universitaria de Secuenciación Masiva y Bioinformática), in particular Alejandro Sanchez.

PAP uses [Snakemake](https://snakemake.readthedocs.io/en/stable/index.html) for pipeline development, [Blastp](https://blast.ncbi.nlm.nih.gov/Blast.cgi?PAGE_TYPE=BlastDocs&DOC_TYPE=Download) and [HMMER](http://hmmer.org/) to perform alignments and [SignalP](https://github.com/fteufel/signalp-6.0) for signal peptide prediction.
