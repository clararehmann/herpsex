import pandas as pd
from Bio import Phylo

def prune_tree(treepath, mdpath):
    tree = Phylo.read(treepath, 'newick')
    term = tree.get_terminals()
    spec = [c.name for c in term]

    meta = pd.read_csv(mdpath, sep='\t')
    repspec = [s.replace(' ', '_') for s in meta['Species']]

    to_prune = set(spec) - set(repspec)
    for s in to_prune:
        tree.prune(s)
    return tree

# parse down squamate phylogeny to only species represented in HerpSexDet

sextree = prune_tree('SquamPhylo/squam_shl_names.tre', 'HerpSexDet/HerpSexDet_v1-1.tsv')
Phylo.write(sextree, 'HerpSexDet_tree.newick', 'newick')

# parse down squamate phylogeny to only species in HerpSexDet with TSD data

tsdtree = prune_tree('SquamPhylo/squam_shl_names.tre', 'TSD_HerpSexDet.tsv')
Phylo.write(tsdtree, 'TSD_HerpSexDet_tree.newick', 'newick')
