# Lab 10: Population Structure
library(tidyverse)
library(ggpubr)
library(adegenet)
library(vcfR)
library(ggrepel)

## DEMO (K = 2)
# read sample names and extract
fam <- read_table("~/bioe-591-genomics/students/liv-schwartz/species.int.fam", 
                  col_names = FALSE,
                  show_col_types = FALSE
)
samples <- fam$X2   # individual IDs are usually column 2

# choose your K value (will be 2 for this demo)
K <- 2

# read Q matrix
q <- read_table("~/bioe-591-genomics/students/liv-schwartz/species.int.2.Q",
                col_names = FALSE,
                show_col_types = FALSE
)

# name the ancestry columns
colnames(q) <- paste0("Cluster", 1:K)

# combine with sample names
q_df <- q %>%
  mutate(sample = samples) %>%
  relocate(sample)

# convert to long format for ggplot
q_long <- q_df %>%
  pivot_longer(
    cols = starts_with("Cluster"),
    names_to = "cluster",
    values_to = "ancestry"
  ) %>%
  mutate(sample = factor(sample, levels = samples))

# plot
plot_k2 <- ggplot(q_long, aes(x = sample, y = ancestry, fill = cluster)) +
  geom_col(width = 1, color="white") +
  theme_bw() +
  labs(x = "Individual", y = "Ancestry proportion") +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
plot_k2

# use regex functions extract cross-validation values from the log file
cv_df <- tibble(file = "~/bioe-591-genomics/students/liv-schwartz/admixture-3853610.out") %>%
  mutate(
    text = map_chr(file, read_file),
    cv_line = str_extract(text, "CV error \\(K=\\d+\\):\\s*[-0-9.eE]+"),
    K  = str_match(cv_line, "CV error \\(K=(\\d+)\\)")[,2] |> as.integer(),
    CV = str_match(cv_line, ":\\s*([-0-9.eE]+)")[,2] |> as.numeric()
  ) %>%
  select(file, K, CV) %>%
  arrange(K)
cv_df

#### OTHER K VALUES
# choose K value
K <- 3

# read Q matrix
q <- read_table("~/bioe-591-genomics/students/liv-schwartz/species.int.3.Q",
                col_names = FALSE,
                show_col_types = FALSE
)

# name the ancestry columns
colnames(q) <- paste0("Cluster", 1:K)

# combine with sample names
q_df <- q %>%
  mutate(sample = samples) %>%
  relocate(sample)

# convert to long format for ggplot
q_long <- q_df %>%
  pivot_longer(
    cols = starts_with("Cluster"),
    names_to = "cluster",
    values_to = "ancestry"
  ) %>%
  mutate(sample = factor(sample, levels = samples))

# plot
plot_k3 <- ggplot(q_long, aes(x = sample, y = ancestry, fill = cluster)) +
  geom_col(width = 1, color="white") +
  theme_bw() +
  labs(x = "Individual", y = "Ancestry proportion") +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
plot_k3

# choose K value
K <- 4

# read Q matrix
q <- read_table("~/bioe-591-genomics/students/liv-schwartz/species.int.4.Q",
                col_names = FALSE,
                show_col_types = FALSE
)

# name the ancestry columns
colnames(q) <- paste0("Cluster", 1:K)

# combine with sample names
q_df <- q %>%
  mutate(sample = samples) %>%
  relocate(sample)

# convert to long format for ggplot
q_long <- q_df %>%
  pivot_longer(
    cols = starts_with("Cluster"),
    names_to = "cluster",
    values_to = "ancestry"
  ) %>%
  mutate(sample = factor(sample, levels = samples))

# plot
plot_k4 <- ggplot(q_long, aes(x = sample, y = ancestry, fill = cluster)) +
  geom_col(width = 1, color="white") +
  theme_bw() +
  labs(x = "Individual", y = "Ancestry proportion") +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
plot_k4

# choose K value
K <- 5

# read Q matrix
q <- read_table("~/bioe-591-genomics/students/liv-schwartz/species.int.5.Q",
                col_names = FALSE,
                show_col_types = FALSE
)

# name the ancestry columns
colnames(q) <- paste0("Cluster", 1:K)

# combine with sample names
q_df <- q %>%
  mutate(sample = samples) %>%
  relocate(sample)

# convert to long format for ggplot
q_long <- q_df %>%
  pivot_longer(
    cols = starts_with("Cluster"),
    names_to = "cluster",
    values_to = "ancestry"
  ) %>%
  mutate(sample = factor(sample, levels = samples))

# plot
plot_k5 <- ggplot(q_long, aes(x = sample, y = ancestry, fill = cluster)) +
  geom_col(width = 1, color="white") +
  theme_bw() +
  labs(x = "Individual", y = "Ancestry proportion") +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )
plot_k5

kplots_234 <- ggarrange(plot_k2, plot_k3, plot_k4,
                        labels = c("K=2", "K=3", "K=4"),
                        vjust = -1,
                        ncol = 1, nrow = 3)+
  theme(plot.margin = margin(t = 30,
                             r = 30,
                             b = 30,
                             l = 30))
kplots_234

annotate_figure(kplots_234, top = text_grob("Structure Plots K=2,3,4 for Mudpuppy Population", 
                                            color = "black", face = "bold", size = 14))

kplots_2345 <- ggarrange(plot_k2, plot_k3, plot_k4, plot_k5,
                         labels = c("K=2", "K=3", "K=4", "K=5"),
                         vjust = -2, hjust = 1,
                         ncol = 1, nrow = 4)+
  theme(plot.margin = margin(t = 40,
                             r = 30,
                             b = 40,
                             l = 30))
kplots_2345

###########
# part 2: PCA + DAPC

# load data and reformat them as geninds
vcf <- read.vcfR(file = "~/bioe-591-genomics/course-materials/data/structure_data/mudpuppies.vcf", verbose = TRUE)

dna <- vcfR2DNAbin(vcf, unphased_as_NA = F, consensus = T, extract.haps = F)
species_genind <- DNAbin2genind(dna)
species_genind

# make PCA behave (make alternate homozygotes equivalent) and run PCA
species_genind_scaled <- scaleGen(species_genind,NA.method="mean",scale=F)
species_pca <- prcomp(species_genind_scaled, center=F,scale=F)

# how much variation in data is captured on single axis?
screeplot(species_pca)

# extract a couple PCs and add sample names
pc <- data.frame(species_pca$x[,1:3])
pc$sample <- rownames(pc)

# plot! improve later
ggplot(data=pc,aes(x=PC1,y=PC2))+
  #geom_text(aes(label=sample)) +
  geom_text_repel(aes(label = sample)) +
  geom_point(color = "blue")+
  theme_bw()

# pre DAPC = need a priori group assignment (K-means clustering)
grp <- find.clusters(species_genind, n.pca = 50, n.clust = 3)
grp

# visualize clusters
pc$cluster <- grp$grp
ggplot(pc, aes(x = PC1, y = PC2, color = cluster)) +
  geom_point(size = 2) +
  geom_text(aes(label = sample), vjust = -0.5, size = 3) 

# DAPC - determines which PCs contribute to assignments
dapc1 <- dapc(species_genind, pop = grp$grp, n.pca = 50, n.da = 2)
dapc1 # note posterior probabilities of ancestry assignments

# extract posterior into tibble
q <- as.data.frame(dapc1$posterior)
q$sample <- rownames(q)
q_long <- q |>
  pivot_longer(
    cols = -sample,
    names_to = "cluster",
    values_to = "ancestry"
  )
q_long

# plot like ADMIXTURE
ggplot(q_long, aes(x = sample, y = ancestry, fill = cluster)) +
  geom_col(width = 1, color = "white") +
  theme_bw() +
  labs(x = "Individual", y = "Assignment probability") +
  theme(
    panel.grid = element_blank(),
    axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)
  )

# compare results across different values of K
# identify clusters
grp_auto <- find.clusters(
  species_genind,
  n.pca = 50,
  choose.n.clust = FALSE, 
  max.n.clust = 10,
  stat = "BIC"
)

# print BIC values
grp_auto$Kstat

# plot! where's da elbow (2 or 3??)
plot(
  1:length(grp_auto$Kstat),
  grp_auto$Kstat,
  type = "b",
  xlab = "K",
  ylab = "BIC"
)


