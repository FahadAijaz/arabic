
path = "/home/knight/repos/texts/cts-texts-arabicLit-master/data/perseus201001/perseus0002/"
filename = "perseus201001.perseus0002.alpheios-text-ara1.xml"
aname = paste0(path, filename)

library(xml2)
library(tidyverse)
r_list <- read_xml(aname) %>% xml2::as_list()
###by paragraph ##
text <- purrr::map(r_list$TEI$text$body$div1,
~ paste(unlist(.), collapse = " "))
alf <- text %>%  tibble() %>% unnest()

library(udpipe)
model <- udpipe_load_model("arabic-padt-ud-2.3-181115.udpipe")
first<- alf %>% top_n(1) %>% pull(.) %>% udpipe(object=model) %>% as_tibble()


first<-alf %>% top_n(1) %>% do(udpipe(.$., object=model))

## by line ##
text <- purrr::map(r_list$TEI$text$body$div1, purrr::map( .$div2, ~paste(unlist(.), collapse = " ")))
alf <- text %>%  data_frame() %>% unnest()


### splitting into first row and then second ##
first_2_rows <- alf %>% top_n(2)
first_row <- first_2_rows %>% top_n(1) %>% pull(.) %>% 
    udpipe(object=model) %>% as_tibble() %>% mutate(doc_id=1, paragraph_id=1, sentence_id=1)
second_row <- first_2_rows %>% top_n(-1) %>% pull(.) %>% 
    udpipe(object=model) %>% as_tibble() %>% mutate(doc_id=2, paragraph_id=2, sentence_id=2)
first_2_df <- bind_rows(first_row, second_row)

### what I am trying to ## 

### the following was NEVER TESTED ##############################
text %>% 
    pull(.) %>% 
    udpipe (object=model) %>% 
    as_tibble() %>% 
    mutate(doc_id=index, paragraph_id=index, sentence_id=index)
####################################################################

### trying map_dfr() ####
df_2 <- first_2_rows %>% pull(.) %>% 
    map_dfr(~ udpipe(x=.x, object=model) %>% as_tibble() %>% mutate(doc_id=row_number()), .id="p_id")