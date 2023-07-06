library(data.table)
library(tidyverse)

md <- fread('HerpSexDet/HerpSexDet_v1-1.tsv')
md$Species_ <- sapply(md$Species, function(x) str_replace(x, ' ', '_'))
md <- md %>% mutate(across(where(is.character), ~ na_if(.,"")))
tsd <- md %>% drop_na(TSD_type)

write_delim(tsd, 'TSD_HerpSexDet.tsv', delim='\t')
