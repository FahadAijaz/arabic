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

### filter stopwords from the dataframe ### 
library(arabicStemR)
tokens_only <- df_n %>% select(token) %>% rename (word=token) %>% filter(word != "")
arabic_stopwords <- data_frame(word = removeStopWords("سلام")$arabicStopwordList)

wo_stop <- tokens_only %>%  anti_join (arabic_stopwords, by="word") 

l_w <- wo_stop %>% pull(word) 

with_stems <- purrr::map (l_w, ~ arabicStemR::stem(.x, returnStemList=TRUE))
with_stems <- with_stems %>% discard (~ .x$text == "") 
### for one row ###
tibble(orig=names(with_stems[[1]]$stemlist), in_eng = with_stems[[1]]$text, in_arabic= with_stems[[1]]$stemlist)
### for one row <end> #######

with_stems %>% map_dfr( ~ tibble(orig=names(.x$stemlist), in_eng = .x$text, in_arabic= .x$stemlist))





all_original <- with_stems %>% map (~list(original=names(.x$stemlist), stem=.x[2][[1]][[1]], english = .x$text ))
words_df <- all_original %>% map_dfr (~ .x %>% as_tibble())
write_rds(words_df, "./data/alf_layla_words.rds")
