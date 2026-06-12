library(tidyverse)

# ============================================================
# Inputs
# ============================================================

EMAPPER_FILE <- "data/GAMHOL_HAP1.emapper.annotations"
REPEAT_TABLE <- "data/gamhol_genome_hap1_final_clnd.full_mask.table"
REPEAT_TBL   <- "data/gamhol_genome_hap1_final_clnd.full_mask.tbl"
LABEL        <- "HAP1"   

# ============================================================
# Figure 1 — COG Category Distribution
# ============================================================

# COG single-letter code to full description lookup
cog_labels <- c(
  S = "Function unknown",
  T = "Signal transduction",
  K = "Transcription",
  O = "Post-translational modification",
  Z = "Cytoskeleton",
  U = "Intracellular trafficking",
  P = "Inorganic ion transport",
  A = "RNA processing and modification",
  G = "Carbohydrate metabolism",
  I = "Lipid metabolism",
  E = "Amino acid metabolism",
  W = "Extracellular structures",
  D = "Cell cycle control",
  J = "Translation",
  L = "Replication and repair",
  C = "Energy production and conversion",
  B = "Chromatin structure and dynamics",
  Q = "Secondary metabolite biosynthesis",
  V = "Defense mechanisms",
  F = "Nucleotide metabolism",
  M = "Cell wall/membrane biogenesis",
  H = "Coenzyme metabolism",
  N = "Cell motility",
  Y = "Nuclear structure",
  X = "Mobilome"
)

# Read emapper annotations, skip comment lines
emapper <- read_tsv(EMAPPER_FILE,
                    comment = "#",
                    col_names = c("query","seed_ortholog","evalue","score",
                                  "eggNOG_OGs","max_annot_lvl","COG_category",
                                  "Description","Preferred_name","GOs","EC",
                                  "KEGG_ko","KEGG_Pathway","KEGG_Module",
                                  "KEGG_Reaction","KEGG_rclass","BRITE",
                                  "KEGG_TC","CAZy","BiGG_Reaction","PFAMs"))

# Count COG categories (split multi-letter entries into individual chars)
cog <- emapper %>%
  filter(COG_category != "-", !is.na(COG_category)) %>%
  mutate(code = strsplit(COG_category, "")) %>%
  unnest(code) %>%
  filter(code %in% names(cog_labels)) %>%
  count(code, name = "count") %>%
  mutate(category = cog_labels[code],
         category = fct_reorder(category, count))

p_cog <- ggplot(cog, aes(x = count, y = category)) +
  geom_bar(stat = "identity", fill = "#2c7bb6") +
  geom_text(aes(label = format(count, big.mark = ",")),
            hjust = -0.1, size = 3, colour = "grey30") +
  scale_x_continuous(expand = expansion(mult = c(0, 0.18))) +
  labs(x = "Number of proteins",
       y = NULL,
       title = bquote(italic("Gambusia holbrooki") ~ .(LABEL) ~ "— COG Functional Categories"),
       subtitle = "EggNOG-mapper v2.1.12 | eggNOG 5.0") +
  theme_bw() +
  theme(
    plot.title   = element_text(size = 11),
    plot.subtitle = element_text(size = 9, colour = "grey40"),
    axis.text.y  = element_text(size = 9),
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank()
  )

print(p_cog)

ggsave(paste0("figures/cog_distribution_", tolower(LABEL), ".png"),
       p_cog, width = 9, height = 7, dpi = 300)

# ============================================================
# Figure 2 — Repeat Content
# ============================================================

# Class grouping — map raw table classes to display names
class_map <- c(
  "DNA"          = "DNA transposons",
  "DNA-hAT"      = "DNA transposons",
  "LINE"         = "LINEs",
  "LTR"          = "LTR elements",
  "SINE"         = "SINEs",
  "PLE"          = "Penelope",
  "RC"           = "Rolling circles",
  "Simple_repeat"= "Simple repeats",
  "Low_complexity"= "Low complexity",
  "Satellite"    = "Satellites",
  "RNA"          = "Small RNA",
  "rRNA"         = "Small RNA",
  "snRNA"        = "Small RNA",
  "scRNA"        = "Small RNA",
  "srpRNA"       = "Small RNA",
  "tRNA"         = "Small RNA",
  "Retroposon"   = "Other",
  "Unknown"      = "Unclassified",
  "ARTEFACT"     = NA_character_
)

# Get total genome length from tbl file
tbl_lines  <- readLines(REPEAT_TBL)
total_len  <- tbl_lines[grep("^total length", tbl_lines)] %>%
  str_extract("\\d+(?= bp)") %>%
  as.numeric()

total_masked_pct <- tbl_lines[grep("bases masked", tbl_lines)] %>%
  str_extract("[0-9.]+(?= %)") %>%
  as.numeric()

# --- Repeat bar chart --
rep_table <- read_tsv(REPEAT_TABLE,
                      col_names = c("class", "subfamily", "length_bp", "fraction")) %>%
  mutate(display_class = class_map[class]) %>%
  filter(!is.na(display_class)) %>%
  group_by(display_class) %>%
  summarise(length_bp = sum(length_bp), .groups = "drop") %>%
  mutate(pct = round(length_bp / total_len * 100, 2),
         display_class = fct_reorder(display_class, pct))

p_rep <- ggplot(rep_table, aes(x = pct, y = display_class)) +
  geom_bar(stat = "identity", fill = "#2c7bb6") +
  geom_text(aes(label = paste0(pct, "%")),
            hjust = -0.1, size = 3.5, colour = "grey30") +
  scale_x_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(x = "% of genome",
       y = NULL,
       title = bquote(italic("Gambusia holbrooki") ~ .(LABEL) ~ "— Repeat Content"),
       subtitle = paste0("RepeatMasker v4.2.3 | Dfam 3.9 | RepeatModeler2 de novo library",
                         "\nTotal masked: ", total_masked_pct, "%")) +
  theme_bw() +
  theme(
    plot.title    = element_text(size = 11),
    plot.subtitle = element_text(size = 9, colour = "grey40"),
    axis.text.y   = element_text(size = 10),
    panel.grid.major.y = element_blank(),
    panel.grid.minor   = element_blank()
  )

print(p_rep)

ggsave(paste0("figures/repeat_content_bar_", tolower(LABEL), ".png"),
       p_rep, width = 8, height = 6, dpi = 300)

# --- Repeat pie chart ---
rep_pie <- rep_table %>%
  mutate(
    display_class = ifelse(pct < 0.3, "Other", as.character(display_class)),
    display_class = fct_reorder(display_class, pct)
  ) %>%
  group_by(display_class) %>%
  summarise(pct = sum(pct), .groups = "drop") %>%
  mutate(
    pct_masked = round(pct / total_masked_pct * 100, 1),
    display_class = fct_reorder(display_class, pct_masked)
  )

p_pie <- ggplot(rep_pie, aes(x = "", y = pct_masked, fill = display_class)) +
  geom_bar(stat = "identity", width = 1, colour = "white", linewidth = 0.4) +
  coord_polar("y", start = 0) +
  scale_fill_manual(values = c("#4e79a7","#f28e2b","#e15759","#76b7b2",
                               "#59a14f","#edc948","#b07aa1","#ff9da7","#9c755f"),
                    name = "Repeat class") +
  labs(
    title = bquote(italic("Gambusia holbrooki") ~ .(LABEL) ~ "— Repeat Composition"),
    subtitle = paste0("% of masked sequence (total masked: ", total_masked_pct, "% of genome)")
  ) +
  theme_void() +
  theme(
    plot.title    = element_text(size = 11, hjust = 0.5),
    plot.subtitle = element_text(size = 9, colour = "grey40", hjust = 0.5),
    legend.text   = element_text(size = 9),
    legend.title  = element_text(size = 9, face = "bold")
  )

print(p_pie)

ggsave(paste0("figures/repeat_content_pie_", tolower(LABEL), ".png"),
       p_pie, width = 7, height = 6, dpi = 300)

