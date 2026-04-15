# Lab 9: Kinship

# load libraries and packages
install.packages("related", repos="http://R-Forge.R-project.org")
install.packages("adegenet")
install.packages("vcfR")
install.packages("pegas")
install.packages("mosaic")
install.packages("reshape2")

library(related)
library(adegenet)
library(vcfR)
library(pegas)
library(tidyr)
library(reshape2)
library(ggplot2)

library(utils) # read table
library(mosaic) # favstats
library(dplyr) # data manipulation
library(reshape2) # melt

# load data
vcf <- read.vcfR(file = "bioe-591-genomics/course-materials/data/kinship/Addax_MaxMissing10.recode.vcf", verbose = TRUE)
# new object
genind_obj <- vcfR2genind(vcf)

# calc expected and observed heterozygosity
af_summary <- adegenet::summary(genind_obj) # specify which package's summary function is used
af_summary # view object
h_o <- af_summary$Hobs
h_e <- af_summary$Hexp

# data frame that compares estimates across loci (rows)
head(h_o)
head(h_e)
het_df <- data.frame(locus = names(h_o), h_o = h_o, h_e = h_e)
head(het_df)

# inbreeding coefficient
Fis_per_locus <- 1 - (h_o / h_e)
Fis_per_locus
mean(Fis_per_locus, na.rm = TRUE)

# are loci in HWE?
loci_obj <- genind2loci(genind_obj)
hwe_results <- pegas::hw.test(loci_obj, B = 100)
head(hwe_results)

# isolate significant deviations
hwe_sig <- hwe_results[hwe_results[, "Pr.exact"] < 0.05, ]

# manual data conversion
gt_filtered <- vcfR::extract.gt(vcf, element = "GT")

## tedious operations
# sample ids
sample_ids <- colnames(gt_filtered)

gt_to_alleles <- function(gt_vector) {
  # split "0/1" or "0|1" into two integer alleles, returning a 2-column matrix (samples x 2 alleles)
  allele1 <- integer(length(gt_vector))
  allele2 <- integer(length(gt_vector))
  
  for (i in seq_along(gt_vector)) {
    g <- gt_vector[i]
    if (is.na(g) || g %in% c("./.", ".", "./", "/.")) {
      allele1[i] <- 0
      allele2[i] <- 0
    } else {
      parts <- as.integer(strsplit(g, "[/|]")[[1]])
      allele1[i] <- parts[1] + 1L    # shift: 0->1 (ref), 1->2 (alt)
      allele2[i] <- parts[2] + 1L
    }
  }
  cbind(allele1, allele2)
}

allele_list <- vector("list", nrow(gt_filtered))

for (v in seq_len(nrow(gt_filtered))) {
  allele_list[[v]] <- gt_to_alleles(gt_filtered[v, ])
}

# combine: each element is (n_samples x 2); bind column-wise
allele_matrix <- do.call(cbind, allele_list)

# add individual IDs as the first column
coancestry_input <- data.frame(IndID = sample_ids, allele_matrix,
                               stringsAsFactors = FALSE)

# column names: IndID, L1_a, L1_b, L2_a, L2_b, ...
locus_names <- paste0(rep(paste0("L", seq_len(nrow(gt_filtered))),
                          each = 2),
                      rep(c("_a", "_b"), nrow(gt_filtered)))
colnames(coancestry_input) <- c("IndID", locus_names)

# running related::coancestry()
kin_results <- related::coancestry(
  genotype.data = coancestry_input,
  wang          = 1,      # 1 = compute; 0 = skip # relatedness estimate
  dyadml        = 1,		# dyadic likelihood estimator
  quellergt     = 1			# relatedness estimate
)
# summarize for relatedness
head(kin_results$relatedness)
relate <- kin_results$relatedness

### ANALYSIS
# compare kinship estimates between ngsRelate and related::coancestry()
# load data
ngs <- read.table("bioe-591-genomics/students/liv-schwartz/09_Addax_MaxMissing10.ngsrelate.out", header = TRUE)
ngs_filter <- subset(ngs, select = c(1:5, 15:35))

  ngs_melt <- melt(ngs, id = "")

relate_filter <- subset(relate_filter, select = c("pair.no","wang", "ritland", "dyadml", "quellergt"))
relate_long <- melt(relate_filter, id = "pair.no")

# summary statistics (e.g., mean, median, quantiles)
favstats(ngs$rab)
favstats(relate$dyadml)
favstats(relate$wang)
favstats(relate$ritland)
favstats(relate$quellergt)

# scatter plot (need matching pairwise comparisons in order (may or may not be automatic)
# pair of histograms of estimate values
ggplot(data = ngs_filter, aes(rab)) +
  geom_histogram() +
  labs(title = "Relatedness Estimate - ngsrelate",
       x = "Relatedness (rab)",
       y = "Count") +
  theme_bw()

ggplot(data = relate_long, aes(value, fill = variable)) +
  geom_histogram()+
  facet_wrap(~variable)+
  labs(title = "Relatedness Estimates - related::coancestry()",
       x = "Relatedness Value",
       y = "Count")

ggplot(data = relate_long, aes(y = value, x = variable, fill = variable)) +
  geom_boxplot() +
  labs(title = "Relatedness Estimates - related::coancestry()",
       x = "Relatedness Estimate",
       y = "Value",
       fill = "Estimate")
