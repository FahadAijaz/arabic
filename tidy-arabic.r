library(tidyverse)
library(cleanNLP)
library(quRan)
library(tidytext)
library(arabicStemR)  # Has a list of Arabic stopwords

quran_annotated <- readRDS("data/quran_annotated.rds")

quran_terms <- quran_annotated %>% 
  cnlp_get_token()

arabic_stopwords <- tibble(word = removeStopWords("سلام")$arabicStopwordList)


top_nouns <- quran_terms %>% 
  filter(str_detect(pos, "NN")) %>% 
  count(word, sort = TRUE) %>% 
  # Get rid of tiny diacritic-like words
  filter(nchar(word) > 1) %>%
  # Get rid of stopwords
  anti_join(arabic_stopwords, by = "word") %>% 
  top_n(10, n) %>% 
  mutate(word = fct_inorder(word))


  top_verbs <- quran_terms %>% 
  filter(str_detect(pos, "VB")) %>% 
  count(word, sort = TRUE) %>% 
  # Get rid of tiny diacritic-like words
  filter(nchar(word) > 1) %>%
  # Get rid of stopwords
  anti_join(arabic_stopwords, by = "word") %>% 
  top_n(10, n) %>% 
  mutate(word = fct_inorder(word))

type_lookup <- quran_ar_min %>% 
  select(ayah_title, surah_id, surah_title_ar, surah_title_en, ayah, revelation_type)

quran_terms <- quran_terms %>% 
  left_join(type_lookup, by = c("id" = "ayah_title"))

glimpse(quran_terms)

