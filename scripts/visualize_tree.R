library(tidyverse)
library(ggtree)
library(data.table)
library(argparse)

parser <- argparse::ArgumentParser(description="Plot character values on tree")
parser$add_argument('--variable', help='character value to plot')
parser$add_argument('--data', help='path to tsv with character values')
parser$add_argument('--tree', help='path to phylogenetic tree')
parser$add_argument('--out', help='base outpath (appended with _[variable]_tree.pdf')
args <- parser$parse_args()

Variable = args$variable
Tree = args$tree
Data = args$data

tree <- read.tree(Tree)
md <- fread(Data)
md$Species_ <- sapply(md$Species, function(x) str_replace(x, ' ', '_'))
md <- md[md$Species_ %in% tree$tip.label,]
md <- md[match(tree$tip.label, md$Species_),]
rownames(md) <- md$Species_
md <- md %>% select(Species_, everything())
md <- md %>% mutate(across(where(is.character), ~ na_if(.,"")))

p <- ggtree(tree)
p %<+% md + geom_tippoint(aes(color=Variable))
ggsave(paste0(args$out, Variable, '_tree.pdf'))
