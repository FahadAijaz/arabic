
library(xml2)
library(tidyverse)
library(udpipe)

##dl <- udpipe_download_model(language = "arabic")

model <- udpipe_load_model("arabic-padt-ud-2.3-181115.udpipe")

##setwd("C:/Users/faijaz/Downloads")

path = paste0(getwd(), "/data/perseus201001/perseus0002/")
filename = "perseus201001.perseus0002.alpheios-text-ara1.xml"
aname = paste0(path, filename)

r_list <- read_xml(aname) %>% xml2::as_list()
###by paragraph ##
text <- purrr::map(r_list$TEI$text$body$div1,
                   ~ paste(unlist(.), collapse = " "))

alf <-  tibble(line = text)  %>% unnest() %>% mutate(linenumber = row_number())


first_n_rows <- alf %>% top_n(40)
### trying map_dfr() ####
df_n <- first_n_rows %>% pull(line) %>% 
  map_dfr(~ udpipe(x=.x, object=model) %>% as_tibble(), .id="p_id")


library(arabicStemR)
tokens_only <- df_n %>% select(token) %>% rename (word=token) %>% filter(word != "")
arabic_stopwords <- data_frame(word = removeStopWords("????????")$arabicStopwordList)

wo_stop <- tokens_only %>%  anti_join (arabic_stopwords, by="word") 

l_w <- wo_stop %>% pull(word) 

with_stems <- purrr::map (l_w, ~ arabicStemR::stem(.x, returnStemList=TRUE))
with_stems <- with_stems %>% discard (~ .x$text == "") 
### for one row ###
tibble(orig=names(with_stems[[1]]$stemlist), in_eng = with_stems[[1]]$text, in_arabic= with_stems[[1]]$stemlist)
### for one row <end> #######




all_original <- with_stems %>% map (~list(original=names(.x$stemlist), stem=.x[2][[1]][[1]], english = .x$text ))
words_df <- all_original %>% map_dfr (~ .x %>% as_tibble())
with_stems %>% map_dfr( ~ tibble(orig=names(.x$stemlist), in_eng = .x$text, in_arabic= .x$stemlist))


df_n
