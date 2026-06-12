# Genome assembly and annotation of the Eastern Mosquitofish (*Gambusia holbrooki*) sourced from Townsville, Australia.
This repository contains the complete collection of scripts and explanatory notes for the genome assembly of an Australian isolate of the Eastern mosquitofish (Gambusia holbrooki).

(The layout of this repository has been inspired by [Jia Zhang (bakeronit) acropora_digitifera_wgs](https://github.com/bakeronit/acropora_digitifera_wgs))

Upon publication, the citation will appear here.

This repository will also be archived on Zenodo upon completion.

### Resources ###
The genome and annotation can be found on ncbi under PRJNA1450840.

Additional resources can be found on [zenodo](link).

These include the outputs of egapx (gtf, cds, aa), and eggnog mapper (annotation), and repeat masker outputs (gtf, repeat famlies).


### Table of Contents

[Sampling Information](00_sampling.md)

[Genome Assembly](01_genome_assembly.md)

[Scaffolding](02_HiC_scaffolding.md)

[Assembly and Scaffolding QC](03_assembly_and_scaffolding_QC.md)

[Repeat Annotation](02_repeat_annotation.md)

[Sctructural and Functional Annotation](02_structural_and_functional_annotation.md)

[Annotation Quality Control](02_scaffolding.md)

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


## Contact

**Roger Huerlimann**

[Marine Climate Change Unit](https://www.oist.jp/research/research-units/macc)

[Okinawa Institute of Science and Technology](www.oist.jp)

📧 [roger.huerlimann@oist.jp](mailto:roger.huerlimann@oist.jp) | [roger.huerlimann@gmail.com](mailto:roger.huerlimann@gmail.com)




> This repository was compiled with the assistance of [Claude](https://claude.ai) (Anthropic), which helped convert a collection of SLURM scripts, analysis notes, and results into structured documentation.