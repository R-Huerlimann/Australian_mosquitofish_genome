library(tidyverse)

# --- Load KAT histogram ---
kat <- read_table("data/pbhifi_k21",
                  comment = "#",
                  col_names = c("frequency", "count")) %>%
  filter(frequency >= 10,
         frequency <= 300) %>%
  mutate(count_m = count / 1e6)

# --- Annotations ---



het_peak <- kat %>% filter(frequency >= 50, frequency <= 80) %>% arrange(desc(count_m)) %>% slice(1) %>% pull(frequency)
hom_peak <- kat %>% filter(frequency >= 100, frequency <= 160) %>% arrange(desc(count_m)) %>% slice(1) %>% pull(frequency)

# --- Plot ---
p <- ggplot(kat, aes(x = frequency, y = count_m)) +
  geom_line(colour = "#2c7bb6", linewidth = 0.8) +
  geom_point(colour = "#2c7bb6", size = 0.8) +
  geom_vline(xintercept = het_peak, linetype = "dashed",
             colour = "grey50", linewidth = 0.5) +
  geom_vline(xintercept = hom_peak, linetype = "dashed",
             colour = "grey50", linewidth = 0.5) +
  annotate("text", x = het_peak + 4, y = max(kat$count_m) * 0.25,
           label = paste0("Heterozygous\npeak (", het_peak, "x)"),
           hjust = 0, size = 3.5, colour = "grey30") +
  annotate("text", x = hom_peak + 4, y = max(kat$count_m) * 0.95,
           label = paste0("Homozygous\npeak (", hom_peak, "x)"),
           hjust = 0, size = 3.5, colour = "grey30") +
  labs(x = "21-mer frequency",
       y = "# distinct 21-mers (millions)",
       title = expression(italic("Gambusia holbrooki") ~ "— 21-mer spectra (PacBio HiFi)"),
       subtitle = "Estimated genome size: 589.97 Mb | Heterozygosity: 0.70%") +
  theme_bw() +
  theme(
    plot.title = element_text(size = 12),
    plot.subtitle = element_text(size = 10, colour = "grey40")
  )

print(p)

ggsave("figures/kat_kmer_spectra.png", p, width = 8, height = 5, dpi = 300)
