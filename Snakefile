"""
Author: Karel Estrada
Affiliation: UUSMB
Aim: A Snakemake workflow for Annotation Pipeline.
Date: may 2017
Run: snakemake --cores <core_numbers> --rerun-incomplete --config PROTREF="protein.faa" -s /path/to/Snakefile_annot
Latest modification: Wed May  3 10:51:33 CDT 2017
"""


SP= "../../DB/uniprot_sprot.fasta"
PF= "../../DB/Pfam-A.hmm"

if "PROTREF" not in config.keys():
    PROTREF = "Inside"
else:
    PROTREF = config["PROTREF"]
if PROTREF== "Inside":
    PROTREF = "protein.faa"

rule all:
    input:
        "annotation_table.tbl"

rule blastp:
    input:
        {PROTREF}
    output:
        "blastp_sprot.outfmt6"
    threads:
        workflow.cores * 1 - 2
    message:
        "Blastp vs SwissProt.."
    shell:
#        "blastp -query {input} -db {SP} -num_threads {threads} -max_target_seqs 1 -evalue 1e-3 -outfmt 6 > {output}"
        "diamond blastp --threads {threads} --max-target-seqs 1 --evalue 0.001 -d {SP} -q {input} -o {output}"

rule pfam:
    input:
        {PROTREF}
    output:
        "PFAM.out"
    threads:
        2
    message:
        "Hmmscan using PFAM.."
    shell:
        "hmmscan --cpu {threads} -E 0.001 --domE 0.001 --domtblout PFAM.out {PF} {input} > pfam.log"

rule signalp:
    input:
        {PROTREF}
    output:
        "signalp.out"
    message:
        "Signalp.."
    shell:
        "signalp -u 0.14 -f short -n {output} {input} > signalp.STDOUT"

rule merge_GO_and_KEGG_annotation:
    input:
        rules.blastp.output,
        rules.pfam.output,
        rules.signalp.output
    output:
        "GO_and_keggs_annot_final.txt"
    message:
        "Merging GO and KEGG term.."
    shell:
        "GO_and_keggs_annot_final.l {input[0]} > {output}"

rule annot_table:
    input:
        rules.blastp.output,
        rules.pfam.output,
        rules.signalp.output,
        rules.merge_GO_and_KEGG_annotation.output
    output:
        "annotation_table.tbl"
    message:
        "Generating the annotation table.."
    shell:
        """
        create_annotation_table.l {input[0]} {input[1]} {input[2]} {input[3]} > {output}
        rm -f GO_and_keggs_annot_final.txt PFAM.out pfam.log signalp.out signalp.STDOUT blastp_sprot.outfmt6
        """
