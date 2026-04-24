# lab 12: genome scans with pcadapt

#packages
library(pcadapt)
library(vcfR)
library(adegenet)
library(ggplot2)
library(dplyr)
library(readr)
library(patchwork)
library(viridis)

# data
meta <- read_csv("~/bioe-591-genomics/course-materials/data/selection/metadata.csv")
x <- read.pcadapt("~/bioe-591-genomics/course-materials/data/selection/salvelinus.vcf", type = "vcf")

# perform PCA and ID outliers relative to the first K principal components
pca <- pcadapt(x, K = 20)
plot(pca, option = "screeplot")

pca_4 <- pcadapt(x, K = 4)

# ID outliers using pvalues vector of padj object, bonferroni correction
alpha <- 0.05
padj <- p.adjust(pca_4$pvalues, method = "bonferroni")
outlier_idx <- which(padj < alpha)
neutral_idx <- which(padj >= alpha)

cat("Outlier loci:", length(outlier_idx), "\n")
cat("Neutral loci:", length(neutral_idx), "\n")

# manhattan plot
plot(pca_4)

# explore relationship of outliers to inferred patterns of variation across populations and proxies for climate such as latitude
vcf <- read.vcfR("~/bioe-591-genomics/course-materials/data/selection/salvelinus.vcf", verbose = FALSE)
vcf_neutral <- vcf[neutral_idx, ]
vcf_outlier <- vcf[outlier_idx, ]

# outlier SNPs to genind
dna_neutral <- vcfR2DNAbin(vcf_neutral, unphased_as_NA = FALSE, consensus = TRUE, extract.haps = FALSE)
gi_neutral <- DNAbin2genind(dna_neutral)
dna_outlier <- vcfR2DNAbin(vcf_outlier, unphased_as_NA = FALSE, consensus = TRUE, extract.haps = FALSE)
gi_outlier <- DNAbin2genind(dna_outlier)

# scale genotypes
gi_neutral_scaled <- scaleGen(gi_neutral, NA.method = "mean", scale = FALSE)
pca_neutral <- prcomp(gi_neutral_scaled, center = FALSE, scale. = FALSE)
gi_outlier_scaled <- scaleGen(gi_outlier, NA.method = "mean", scale = FALSE)
pca_outlier <- prcomp(gi_outlier_scaled, center = FALSE, scale. = FALSE)

# transform PCA objects into dataframes for plotting
# lists -> dataframes
neutral_df <- data.frame(pca_neutral$x[, 1:2]) %>%
  mutate(sample = rownames(.))
outlier_df <- data.frame(pca_outlier$x[, 1:2]) %>%
  mutate(sample = rownames(.))

# join metadata
neutral_df <- left_join(neutral_df, meta, by = c("sample" = "Sample.ID"))
outlier_df <- left_join(outlier_df, meta, by = c("sample" = "Sample.ID"))

# shared axis limits
xlims <- range(c(outlier_df$PC1, neutral_df$PC1), na.rm = TRUE)
ylims <- range(c(outlier_df$PC2, neutral_df$PC2), na.rm = TRUE)

# percent variance explained
neutral_var <- 100 * summary(pca_neutral)$importance[2, ]
outlier_var <- 100 * summary(pca_outlier)$importance[2, ]

# compare PCA plots between 2 subsets of data with ggplot and patchwork
lat1 <- ggplot(neutral_df, aes(x = PC1, y = PC2, color=Site.Latitude)) +
  geom_point(size = 2, alpha = 0.8) +
  scale_color_viridis() +
  coord_cartesian(xlim = xlims, ylim = ylims) +
  theme_classic() +
  theme(legend.position = "bottom") +
  labs(
    title = "PCA: neutral loci",
    x = paste0("PC1 (", round(neutral_var[1], 1), "%)"),
    y = paste0("PC2 (", round(neutral_var[2], 1), "%)")
  ) 

lat2 <- ggplot(outlier_df, aes(x = PC1, y = PC2, color=Site.Latitude)) +
  geom_point(size = 2, alpha = 0.8) +
  scale_color_viridis() +
  coord_cartesian(xlim = xlims, ylim = ylims) +
  theme_classic() +
  theme(legend.position = "bottom") +
  labs(
    title = "PCA: outlier loci only",
    x = paste0("PC1 (", round(outlier_var[1], 1), "%)"),
    y = paste0("PC2 (", round(outlier_var[2], 1), "%)")
  )

lat1 + lat2

# comments
#there are fewer outlier loci, which feels correct considering we want more loci in the majority of the data.
#i find it interesting that the outlier loci seem to cluster together, whereas the neutral loci have a larger cluster that spans the length of PC2, with a couple smaller clusters.
#high latitude points seem to cluster around 0 on PC2 and the lower latitude points are within the smaller clusters. 

## homework:
#Add commented text or a Markdown chunk below the PCA plot comparison, interpreting differences between results from neutral loci and outlier loci.
#Plot both PC1 and PC2 for both datasets against latitude. Describe results.

#Plot PC1 and PC2 for both datasets against longitude. Add text to describe results.
long1 <- ggplot(neutral_df, aes(x = PC1, y = PC2, color=Site.Longitude)) +
  geom_point(size = 2, alpha = 0.8) +
  scale_color_viridis() +
  coord_cartesian(xlim = xlims, ylim = ylims) +
  theme_classic() +
  theme(legend.position = "bottom") +
  labs(
    title = "PCA: neutral loci",
    x = paste0("PC1 (", round(neutral_var[1], 1), "%)"),
    y = paste0("PC2 (", round(neutral_var[2], 1), "%)")
)
long2 <- ggplot(outlier_df, aes(x = PC1, y = PC2, color=Site.Longitude)) +
  geom_point(size = 2, alpha = 0.8) +
  scale_color_viridis() +
  coord_cartesian(xlim = xlims, ylim = ylims) +
  theme_classic() +
  theme(legend.position = "bottom") +
  labs(
    title = "PCA: outlier loci",
    x = paste0("PC1 (", round(neutral_var[1], 1), "%)"),
    y = paste0("PC2 (", round(neutral_var[2], 1), "%)")
  )

long1 + long2
# comments:
# similar to latitude, outlier loci for longitude seem to cluster into three groups.
# in the neutral loci, the same pattern of clusters exists, but in the largest cluster, the lowest longitude points center around 0 on PC2 and the highest longitude points around 5 on PC2.
