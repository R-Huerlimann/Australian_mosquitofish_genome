library(tidyverse)

# --- Load FAI files ---
hap1_ctg  <- read_tsv("data/mosquito.pbhic.asm1.hic.hap1.p_ctg.fa.fai",
                      col_names = c("name", "length", "offset", "linebases", "linewidth")) %>%
  arrange(desc(length)) %>%
  mutate(index = row_number(), type = "Contigs", hap = "HAP1")

hap1_scaf <- read_tsv("data/mosquito.pbhic.asm1.hic.hap1.p_ctg_yahs_scaffolds_final.fa.fai",
                      col_names = c("name", "length", "offset", "linebases", "linewidth")) %>%
  arrange(desc(length)) %>%
  mutate(index = row_number(), type = "Scaffolds", hap = "HAP1")

hap2_ctg  <- read_tsv("data/mosquito.pbhic.asm1.hic.hap2.p_ctg.fa.fai",
                      col_names = c("name", "length", "offset", "linebases", "linewidth")) %>%
  arrange(desc(length)) %>%
  mutate(index = row_number(), type = "Contigs", hap = "HAP2")

hap2_scaf <- read_tsv("data/mosquito.pbhic.asm1.hic.hap2.p_ctg_yahs_scaffolds_final.fa.fai",
                      col_names = c("name", "length", "offset", "linebases", "linewidth")) %>%
  arrange(desc(length)) %>%
  mutate(index = row_number(), type = "Scaffolds", hap = "HAP2")

# --- Combine ---
dat <- bind_rows(hap1_ctg, hap1_scaf, hap2_ctg, hap2_scaf) %>%
  mutate(length_mb = length / 1e6,
         panel = factor(paste(hap, type), levels = c("HAP1 Contigs", "HAP2 Contigs", "HAP1 Scaffolds", "HAP2 Scaffolds")))  %>%
         filter(index <= 70)


# --- Plot ---
p <- ggplot(dat, aes(x = index, y = length_mb)) +
  geom_bar(stat = "identity", width = 1, fill = "#2c7bb6") +
  geom_vline(xintercept = 24.5, colour = "red", linetype = "dashed", linewidth = 0.5) +
  facet_wrap(~ panel, scales = "free_x", ncol = 2) +
  labs(x = "Contig / Scaffold (ordered by size)",
       y = "Length (Mb)",
       title = "Gambusia holbrooki: Contig and Scaffold Size Distribution (Top 70)") +
  theme_bw() +
  theme(
    strip.background = element_rect(fill = "grey90"),
    strip.text = element_text(face = "bold"),
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank()
  )

print(p)

ggsave("figures/scaffold_size_distribution.png", p, width = 10, height = 7, dpi = 600)
ggsave("figures/scaffold_size_distribution.svg", p, width = 10, height = 7, dpi = 600)
