library(feather)
library(tidyverse)

path = "./data/lexicon/"
files = list.files(path)

y0_df <- read_feather(paste0(path, files[8])) %>% as_tibble()

y1_df <- read_feather(paste0(path, files[9])) %>% as_tibble()