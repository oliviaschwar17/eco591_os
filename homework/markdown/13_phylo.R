# lab 13: phylogenomics

library(ape)
library(readr)

# read tree
tree <- read.tree("~/bioe-591-genomics/students/liv-schwartz/lemurs.snps.min4.phy.contree")
tree

# read metadata
meta <- read_tsv("~/bioe-591-genomics/course-materials/data/phylogenetics/lemur_metadata.txt")

# map species to sample
map <- setNames(meta$species, meta$ID_long)
# overwrite tip labels
tree$tip.label <- unname(map[tree$tip.label])

# plot
plot(tree)

# root using an outgroup (replace with your sample name)
tree_rooted <- root(tree, outgroup = "murinus", resolve.root = TRUE)
# plot
plot(tree_rooted)
# add node labels
bs <- as.numeric(tree$node.label)
nodelabels(ifelse(bs >= 70, bs, ""), cex = 0.7, frame = "n")

png("~/bioe-591-genomics/students/liv-schwartz/lemur_tree.png", width = 1000, height = 800)
plot(tree_rooted)
nodelabels(tree$node.label, cex = 0.7, frame = "n")
dev.off()


## interpretation ##
#Write 2-3 sentences comparing the phylogeny you inferred above with the results of Poelstra et al. 2021.
#Does your analysis also support lumping M. mittermeieri and M. lehilahytsara?
#Is Microcebus sp. 3 still recovered as distinct?

  # the phylogeny I inferred seems to align more with the ML nDNA tree from Poelstra et al. 2021, especially as both of those trees distinguish all three samples of M. murinus.
  # this analysis does seem to support the lumping of M. mittermeieri and M. lehilahytsara, as they are closely grouped on the tree.
  # in my analysis Microcebus sp. #3 is separated out distinctly from M. mittermeieri, M. lehilahytsara, M. murinus and M. simmonsi. The group of M. sp. #3 is closest to M. macarthurii in my analysis.

  
  
  