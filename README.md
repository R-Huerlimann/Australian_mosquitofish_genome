# Genome assembly and annotation of the Eastern Mosquitofish (*Gambusia holbrooki*) sourced from Townsville, Australia.
This repository contains the complete collection of scripts and explanatory notes for the genome assembly of an Australian isolate of the Eastern mosquitofish (Gambusia holbrooki).

It is currently in draft form, and will be finalised before publication. Please send any comments to the contact below.

(The layout of this repository has been inspired by [Jia Zhang (bakeronit) acropora_digitifera_wgs](https://github.com/bakeronit/acropora_digitifera_wgs))

Upon publication, the citation will appear here.

This repository has been archived on Zenodo upon completion under [![DOI](https://zenodo.org/badge/1258848678.svg)](https://doi.org/10.5281/zenodo.20659008).

## Table of Contents

[00 - Sampling Information](00_sampling.md)

[01 - Genome Assembly](01_genome_assembly.md)

[02 - Scaffolding](02_HiC_scaffolding.md)

[03 - Assembly and Scaffolding QC](03_assembly_and_scaffolding_QC.md)

[04 - Repeat Annotation](04_repeat_annotation.md)

[05 - Sctructural and Functional Annotation](05_structural_and_functional_annotation.md)

[06 - Annotation Quality Control](06_annotation_quality_control.md)

### How to use this repository
All of the sections above are provided as processed markdown files. Clicking the link should display a web readable page with text. The code used to generate these pages is provided in the corresponding .Rmd file.

If you would like to run the code in these files yourself you will need to adapt the code given in this repo and integrate it into your own HPC environment.

## Computational Environment

All analyses were performed on the Deigo HPC cluster at OIST (SLURM job scheduler).

| Software | Version |
|:---:|:---:|
| Singularity | 4.1.4 |
| Mamba | 2.5.0 |
| Nextflow | 25.10.4 |
| SLURM | 24.11.0 |


## Resources ##
The genome and annotation can be found on ncbi under PRJNA1450840 (upon publication).

Additional resources can be found on [zenodo (10.5281/zenodo.20725785)](https://doi.org/10.5281/zenodo.20725785) (see below).

These include the outputs of egapx (gtf, cds, aa), and eggnog mapper (annotation), and repeat masker outputs (gtf, repeat famlies).

### Genome assembly and gene models (HAP1 / HAP2)

| File | Description |
|---|---|
| `Gamhol_genome_HAP1_24chr_contigs_mtg.fa` | Chromosome-scale genome assembly for HAP1, including 24 chromosomes, unplaced contigs, and mitogenome |
| `Gamhol_genome_HAP2_24chr_contigs.fa` | Chromosome-scale genome assembly for HAP2 assembly, including unplaced contigs |
| `Gamhol_genome_HAP1_complete.genomic.gff` / `Gamhol_genome_HAP2_complete.genomic.gff` | Gene models, GFF3 format (EGAPx output) |
| `Gamhol_genome_HAP1_complete.proteins.faa` / `Gamhol_genome_HAP2_complete.proteins.faa` | Predicted protein sequences (EGAPx output) |
| `Gamhol_genome_HAP1_complete.cds.fna` / `Gamhol_genome_HAP2_complete.cds.fna` | Coding sequences (EGAPx output) |
| `Gamhol_genome_HAP1_complete.transcripts.fna` / `Gamhol_genome_HAP2_complete.transcripts.fna` | Transcript sequences (EGAPx output) |

### Functional annotation

| File | Description |
|---|---|
| `Gamhol_genome_HAP1.emapper.annotations` / `Gamhol_genome_HAP2.emapper.annotations` | eggNOG-mapper functional annotation output |

### Repeat annotation (HAP1)

| File | Description |
|---|---|
| `Gamhol_genome_repeat-families.fa` | De novo repeat consensus library (RepeatModeler2 output, species-prefixed) |
| `Gamhol_genome_repeat-families.round-2_Self.known` | Classified repeat families after iterative classification |
| `Gamhol_genome_repeat-families.round-2_Self.unknown` | Unclassified repeat families after iterative classification |
| `Gamhol_genome_HAP1_repeats_full_mask.gff3` | Combined repeat annotation, GFF3 format |
| `Gamhol_genome_HAP1_repeats_full_mask.out` | Combined repeat annotation, RepeatMasker `.out` format |
| `Gamhol_genome_HAP1_repeats_full_mask.tbl` | Repeat content summary statistics |
| `Gamhol_genome_HAP1_repeats_full_mask.cat.gz` | Combined RepeatMasker alignment catalogue |

### Mitogenome

| File | Description |
|---|---|
| `Gamhol_mitogenome.fasta` | Assembled mitochondrial genome (MitoHiFi) |
| `Gamhol_mitogenome.gff` | Mitogenome annotation (MITOS2) |


## Contact

**Roger Huerlimann**

[Marine Climate Change Unit](https://www.oist.jp/research/research-units/macc)

[Okinawa Institute of Science and Technology](www.oist.jp)

📧 [roger.huerlimann@oist.jp](mailto:roger.huerlimann@oist.jp) | [roger.huerlimann@gmail.com](mailto:roger.huerlimann@gmail.com)




> This repository was compiled with the assistance of [Claude](https://claude.ai) (Anthropic), which helped convert a collection of SLURM scripts, analysis notes, and results into structured documentation.