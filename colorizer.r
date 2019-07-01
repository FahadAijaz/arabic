library(crayon)
library(arabicStemR)

arabic_stopwords <- data_frame(token = removeStopWords("????????")$arabicStopwordList) %>% pull(token)
distinct_upos <- df_n %>% select(upos) %>% distinct() 

stopped_tokens <- df_n %>% filter (token %in% arabic_stopwords)

upos_list <- function (upos_tag){
  df_n %>% filter(upos == upos_tag) %>% select(token) %>% distinct() %>% pull(token)
  
}

## or assume that we have token, sentence and upos atleast 

verbed <- make_style(rgb(0, .7, 0), bg = FALSE)$bold 
conjucted <- bgYellow
adjectived <- bgCyan
stopped <- underline


cat(verb_list %>% verbed)
df_n %>% mutate(colrtoken = ifelse(upos == "VERB", verbed(token), 
                              ifelse(upos == "CCONJ", conjucted(token),
                              ifelse(upos == "ADJ", "\n" %+% adjectived(token) %+% "\n",
                              ifelse(token %in% arabic_stopwords, stopped(token),
                                     token))))) %>%
  select(colrtoken) %>% 
  pull(colrtoken) %>% 
  cat

df_n %>% mutate(colrlemma = ifelse(upos == "VERB", verbed(lemma), 
                              ifelse(upos == "CCONJ", conjucted(lemma),
                              ifelse(upos == "ADJ", "\n" %+% adjectived(lemma) %+% "\n",
                              token)))) %>%
  select(colrlemma) %>% 
  pull(colrlemma) %>% 
  cat



