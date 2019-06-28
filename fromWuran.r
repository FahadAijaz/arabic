library(jsonlite)
library(cleanNLP)
library(stringr)
library(arabicStemR)
# Arabic, all vowels
##download.file("http://api.alquran.cloud/quran/quran-simple",
##"./data/quran-simple.json")

##quran_ar_raw <- read_json("./data/quran-simple.json")

quran_str <- readLines('./data/quran-simple.txt',encoding='UTF-8')
str_sub(quran_str,end=2)
ch <- removeDiacritics(quran_str[1:9])
cnlp_init_udpipe()

##obj <- cnlp_annotate(quran_str, as_strings = TRUE)

library(udpipe)
model <- udpipe_load_model("arabic-padt-ud-2.3-181115.udpipe")
library(tidyverse)
u_first_10<- udpipe(x=ch, object=model)
first_10 <-  u_first_10 %>% as_tibble ()
first_10 %>% select(misc)
colnames(first_10)
out<- arabicStemR::stem(ch[2], returnStemList=TRUE)

library(crayon)
cat (blue(out$stemlist %+% "\n"))

