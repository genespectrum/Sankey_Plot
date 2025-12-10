# Install packages
install.packages(c("phyloseq","dplyr","tidyr","ggplot2","ggalluvial",
                   "networkD3","tibble","htmlwidgets","RColorBrewer"))
BiocManager::install("phyloseq")

library(phyloseq)
library(dplyr)
library(tidyr)
library(ggalluvial)
library(networkD3)
library(ggplot2)
library(tibble)
library(htmlwidgets)
library(RColorBrewer)

set.seed(123)

# ----------------------------------------------------
# STEP 1: Load OTU table 
# ----------------------------------------------------
otu <- file.choose()
otu <- read.csv(otu)
row.names(otu) <- otu$X
otu <- otu[,-1]
otu <- otu_table(as.matrix(otu), taxa_are_rows = TRUE)

# ----------------------------------------------------
#STEP 2: Load taxonomy table
# ----------------------------------------------------
tax <- file.choose()
tax <- read.csv(tax)
row.names(tax) <- tax$X
tax <- tax[,-1]
tax <- tax_table(as.matrix(tax))

# ----------------------------------------------------
# STEP 3: Load sample metadata
# ----------------------------------------------------
sampledata <- file.choose()
sampledata <- read.csv(sampledata)
row.names(sampledata) <- sampledata$SampleID
sampledata <- sample_data(sampledata)

# ----------------------------------------------------
# STEP 4: BUILD PHYLOSEQ OBJECT
# ----------------------------------------------------
ps <- phyloseq(otu, tax, sampledata)
ps

# ----------------------------------------------------
# STEP 5: PREPARE DATA FOR MULTI-LEVEL SANKEY
# ----------------------------------------------------
otu_df <- as.data.frame(otu_table(ps)) %>%
  rownames_to_column("taxa") %>%
  pivot_longer(-taxa, names_to = "SampleID", values_to = "Count")

tax_df <- as.data.frame(tax_table(ps)) %>%
  rownames_to_column("taxa")

otu_long <- left_join(otu_df, tax_df, by = "taxa")

# Summarize all taxonomy levels
flow_df <- otu_long %>%
  group_by(Kingdom, Phylum, Class, Order, Family, Genus) %>%
  summarise(Count = sum(Count), .groups = "drop") %>%
  arrange(desc(Count))

print(flow_df)

# ----------------------------------------------------
# STEP 6: MULTI-LEVEL FANCY SANKEY (GGALLUVIAL)
# ----------------------------------------------------
ggdf <- flow_df %>%
  rename(
    axis1 = Kingdom,
    axis2 = Phylum,
    axis3 = Class,
    axis4 = Order,
    axis5 = Family,
    axis6 = Genus,
    value = Count
  )

# Fancy color palette
fancy_colors <- colorRampPalette(brewer.pal(12, "Set3"))(length(unique(ggdf$axis2)))

p <- ggplot(ggdf,
            aes(axis1 = axis1, axis2 = axis2, axis3 = axis3,
                axis4 = axis4, axis5 = axis5, axis6 = axis6,
                y = value)) +
  geom_alluvium(aes(fill = axis2),
                width = 0.2,
                alpha = 0.85,
                knot.pos = 0.4,
                curve_type = "quintic") +
  geom_stratum(width = 0.04, fill = "grey93", color = "black") +
  geom_text(stat = "stratum",
            aes(label = after_stat(stratum), x = after_stat(x) + 0.03),   # move text right
            hjust = 0,
            size = 3.2, color = "black") +
  scale_x_discrete(expand = c(0.07, 0.07),) +
  scale_fill_manual(values = fancy_colors) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid = element_blank(),
    axis.title.x = element_blank(),
    axis.title.y = element_text(size = 12, face = "bold"),
    plot.title = element_text(size = 17, face = "bold"),
    legend.position = "none"
  ) +
  labs(
    title = "Multi-Level Sankey Plot: Kingdom → Phylum → Class → Order → Family → Genus",
    y = "Total Read Count"
  )

print(p)

#ggsave("sankey_multi_taxonomy.png", p, width = 14, height = 7, dpi = 300)

