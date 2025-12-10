# Multi-Level Taxonomy Sankey Plot in R

### This repository provides a simple and clean tutorial to create a multi-level taxonomy Sankey plot (Kingdom → Phylum → Class → Order → Family → Genus).
## Overview
This README provides a detailed, expanded, and beginner-friendly explanation of how to generate a multi-level microbiome taxonomy Sankey plot. This plot displays the hierarchical flow of microbial abundances from broad groups such as Kingdom down to finer levels like Genus. It helps researchers visually understand how microbial community structure is distributed and how specific taxa contribute to higher-level taxonomy.
## Dataset Required
To build a Sankey plot, you need three datasets that must align by sample ID and taxa ID:

1. OTU / ASV Count Table(CSV)
   
   - Rows = Taxa IDs (OTU/ASV IDs) 
   - Columns = Sample IDs
   - Values = Read counts for each taxon in each sample
   - Ensure no missing sample names and that counts are numeric.

2. Taxonomy Table(CSV)
   
   - Must contain taxonomic ranks as columns (Kingdom, Phylum, Class, Order, Family, Genus)
   - Row names (first column) must match OTU IDs from the OTU table.
   - Missing taxonomy can be filled with terms like 'Unclassified' or 'Unknown'.

3. Sample Metadata Table(CSV)

   - Contains sample IDs and experimental conditions (e.g., group, treatment, time point).
   - Helps filter or group results later.

## Step-by-Step Tutorial 

1. Prepare Your Input Files
   
   In this step, you collect your OTU table, taxonomy table, and sample metadata, ensuring that the taxon IDs and sample names match correctly across all files.

2. Install and Load Required Packages

   In this step, you install and load all necessary R packages which include phyloseq, dplyr, tidyr, ggplot2, ggalluvial, networkD3, tibble, htmlwidgets, and RColorBrewer, so the functions needed for data processing and Sankey plotting are ready to use.

3. Load the OTU Table

   Here you import the OTU table into R, set the taxon IDs as row names, and ensure the read-count columns are clean and correctly formatted.

4. Load the Taxonomy Table

   In this step, you import the taxonomy file and make sure each taxon has complete classification information that correctly matches the OTU IDs.

5. Load the Sample Metadata

   Here you load your metadata file and verify that the SampleID column matches the sample names present in the OTU table.

6. Build the Phyloseq Object

   In this step, you combine the OTU table, taxonomy table, and metadata into a single phyloseq object so the entire dataset is organized together.

7. Convert OTU Data to Long Format

   Here you reshape your OTU table so each row represents one taxon and one sample, preparing the data for flow-based visualization.

8. Merge Taxonomy with OTU Data

   In this step, you connect each taxon–sample read count with its full taxonomy path, producing a complete dataset for the Sankey diagram.

9. Summarize Read Counts Across Taxonomy Levels

   Here you group the data by each taxonomy rank and calculate the total abundance for every Kingdom-to-Genus combination.

10. Prepare Data for the Sankey Plot

    In this step, you organize the taxonomy ranks into ordered axes and set up the final table that will drive the Sankey flows.

11. Choose Colors for the Plot

    Here you select a color palette—usually by phylum—to visually distinguish the flows in the final diagram.

12. Create the Multi-Level Sankey Plot

    In this step, you generate the Sankey visualization by drawing flows between taxonomy levels, adding labels, and styling the figure.

13. Save the Plot

    Here you export the finished Sankey plot in a suitable file format and size so the labels and flows remain clear.

## Use Cases

1.Microbiome Composition Profiling

- Helps visualize how microbial abundance flows from Kingdom to Genus.
- Useful when identifying dominant and rare taxa to understand community structure.
- Provides a clearer picture than stacked barplots or tables.

2.Treatment and Intervention Effects

- Allows comparison between groups (e.g., disease vs. healthy, treated vs. control).
- Reveals how treatment alters taxa distribution across multiple taxonomy levels.
- Supports biomarker discovery by showing shifts in specific branches.

3. Exploring Dominant and Rare Taxa

   It allows you to quickly identify which taxa contribute most to the community at each level and observe how rare or low-abundance taxa flow across the hierarchy.

4. Quality Checking Microbiome Data

   The plot reveals unexpected patterns—such as single taxa dominating multiple levels—that can help detect issues in taxonomy assignment or OTU clustering.


