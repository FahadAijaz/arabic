library("XML")
library(tidyverse)
library(stringr)
path = "/home/knight/repos/texts/cts-texts-arabicLit-master/data/perseus200202/perseus0006/"
filename = "perseus200202.perseus0006.alpheios-text-ara1.xml"
aname = paste0(path, filename)
xmldataframe <- xmlToDataFrame(aname)
### for alf layla ##
path = "/home/knight/repos/texts/cts-texts-arabicLit-master/data/perseus201001/perseus0002/"
filename = "perseus201001.perseus0002.alpheios-text-ara1.xml"
aname = paste0(path, filename)
xmldataframe <- xmlToDataFrame(aname)
alf <- xmldataframe %>% as_tibble()
alf %>% select(body)


library(udpipe)
model <- udpipe_load_model("arabic-padt-ud-2.3-181115.udpipe")
text_body <- alf %>% select(body)
text <- text_body$body[[2]]
library(arabicStemR)

## extracting first 30 elemnts from the string##
text_len <- substr(text, start = 1, stop = 500)
text_len %>% str_split(" ")
first_30 <- udpipe(x=text, object=model) %>% as_tibble()
