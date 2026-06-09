01 — phased genome assembly
================

<style>
tr:nth-child(even) {
  background-color: transparent;
}
</style>

This section describes the code used for phased genome assembly of
*Gambusia holbrooki* (eastern mosquitofish), producing two
haplotype-resolved assemblies (HAP1 and HAP2).

------------------------------------------------------------------------

## Inputs

| Descriptor | File | BioProject | BioSample | SRR ID |
|----|----|----|----|----|
| PacBio HiFi reads | `m84168_260317_052632_s4.fastq.gz` | PRJNA1450840 | SAMN57172601 | SRR38011946 |
| Hi-C forward reads | `Mosquitofish-HiC_S2_L001_R1_001.fastq.gz` | PRJNA1450840 | SAMN57172601 | SRR38065502 |
| Hi-C reverse reads | `Mosquitofish-HiC_S2_L001_R2_001.fastq.gz` | PRJNA1450840 | SAMN57172601 | SRR38065501 |

------------------------------------------------------------------------

## Software

| Tool    | Version | Source                                 |
|---------|---------|----------------------------------------|
| HiFiasm | 0.25.0  | <https://github.com/chhylp123/hifiasm> |

------------------------------------------------------------------------

## Step 1 — Genome Assembly

Haplotype-phased assembly using HiFiasm with PacBio HiFi reads and Hi-C
contact data.

``` bash
hifiasm -o mosquito.pbhic.asm1 \
        -t 128 \
        --h1 Mosquitofish-HiC_S2_L001_R1_001.fastq.gz \
        --h2 Mosquitofish-HiC_S2_L001_R2_001.fastq.gz \
        m84168_260317_052632_s4.fastq.gz \
        2> hifiasm.log
```

> **Resources:** 128 CPUs, 500 GB RAM, 1-day wall time (Deigo HPC,
> `compute` partition).

**Notes:** - HiFiasm in Hi-C mode (`--h1`/`--h2`) resolves heterozygous
loci into two separate phased assemblies rather than collapsing them
into a consensus. This is the recommended approach for diploid organisms
where both haplotypes are of interest. - The `-t 128` flag sets thread
count; HiFiasm scales well to high thread counts and the assembly step
is the most resource-intensive in the pipeline. Reducing threads will
increase wall time substantially. - Standard parameters (no custom
overlap or purge settings) were used. For *G. holbrooki*, a small-genome
livebearing fish (~750 Mb), defaults are appropriate; tuning is
generally only warranted for unusual heterozygosity levels or repeat
content. - stderr is redirected to `hifiasm.log` — this captures
progress and statistics and should be checked for warnings about
coverage or unresolved heterozygosity.

------------------------------------------------------------------------

## Step 2 — GFA to FASTA Conversion

HiFiasm outputs assemblies in GFA format. These are converted to FASTA
for downstream use.

``` bash
awk '/^S/{print ">"$2"\n"$3}' mosquito.pbhic.asm1.hic.hap1.p_ctg.gfa > mosquito.pbhic.asm1.hic.hap1.p_ctg.fa
awk '/^S/{print ">"$2"\n"$3}' mosquito.pbhic.asm1.hic.hap2.p_ctg.gfa > mosquito.pbhic.asm1.hic.hap2.p_ctg.fa
```

**Notes:** - GFA (Graphical Fragment Assembly) format encodes the
assembly graph; most downstream tools (scaffolders, annotation
pipelines) require FASTA. The `awk` one-liner extracts only the Segment
lines (`S` tag), which contain contig names and sequences. - `p_ctg`
refers to primary contigs — the fully phased, non-redundant contig set
for each haplotype. HiFiasm also produces alternate contig files
(`.a_ctg`) which are not used here. - This conversion is lossless for
the sequence content but discards graph topology, which is not needed
for the Hi-C scaffolding step that follows.

------------------------------------------------------------------------

## Outputs

| File                                    | Description                  |
|-----------------------------------------|------------------------------|
| `mosquito.pbhic.asm1.hic.hap1.p_ctg.fa` | HAP1 primary contigs (FASTA) |
| `mosquito.pbhic.asm1.hic.hap2.p_ctg.fa` | HAP2 primary contigs (FASTA) |
| `hifiasm.log`                           | Assembly log (stderr)        |

Both FASTA files are passed to **[02 — Hi-C
Scaffolding](02_HiC_scaffolding.md)**.
