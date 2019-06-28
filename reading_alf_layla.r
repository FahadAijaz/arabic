### the following reads n pages of alf_layla
### converts them into tidytext 


library(xml2)
library(tidyverse)
library(udpipe)
model <- udpipe_load_model("arabic-padt-ud-2.3-181115.udpipe")

path = "/home/knight/repos/texts/cts-texts-arabicLit-master/data/perseus201001/perseus0002/"
filename = "perseus201001.perseus0002.alpheios-text-ara1.xml"
aname = paste0(path, filename)

r_list <- read_xml(aname) %>% xml2::as_list()
###by paragraph ##
text <- purrr::map(r_list$TEI$text$body$div1,
 ~ paste(unlist(.), collapse = " "))
alf <- text %>%  tibble() %>% unnest()

first_n_rows <- alf %>% top_n(20)
### trying map_dfr() ####
df_n <- first_n_rows %>% pull(.) %>% 
    map_dfr(~ udpipe(x=.x, object=model) %>% as_tibble(), .id="p_id")

write_rds(df_n, "./data/alf_layla.rds")