
library(xml2)
library(tidyverse)
library(udpipe)
library(arabicStemR)
library(xmltools)
model <- udpipe_load_model("arabic-padt-ud-2.3-181115.udpipe")

path = "/home/knight/repos/texts/Arabic/Lane/opensource/"
files<- dir(path)
curr_file <- files[3]
curr_abs <- paste0(path, curr_file)
lex <-  read_xml(curr_abs)



# r_list <- read_xml(curr_abs) %>% xml2::as_list()
# text <- purrr::map(r_list$TEI$text$body$div1,  ~.x %>% xmlToList() )


terminal <-  lex %>% ## get all xpaths
  xml_get_paths()
xpaths <- terminal %>% ## collapse xpaths to unique only
  unlist() %>%
  unique()

terminal_parent <- lex %>% ## get all xpaths to parents of parent node
  xml_get_paths(only_terminal_parent = TRUE)

terminal_xpaths <- terminal_parent[2] %>% ## collapse xpaths to unique only
  unique()

terminal_nodesets <-  terminal_xpaths[[1]] %>% 
    purrr::map( ~  xml_find_all(lex, .x))







######### the following line works ###

word <- defs %>% map_dfc (~ .x[[1]][[4]][[1]] %>% as_tibble()) %>% transmute(word=value)

test_df <- terminal_nodeset %>% xml_dig_df  %>% tibble() %>% unnest

######
xml_find_all (terminal_nodeset[[2]], terminal_xpaths) 



terminal_nodesets <-  terminal_xpaths[[1]] %>% 
    purrr::map( ~  xml_find_all(lex, .x))

df2 <- terminal_nodesets %>%
  purrr::map(xml_dig_df)
#   purrr::map(tibble) %>%
#   purrr::map( function(x) x$`<list>`) %>%
#   purrr::map(dplyr::bind_rows)




terminal_nodeset <- xml_find_all(lex, terminal_xpaths[[1]][4])


r<-terminal_nodeset %>% xml2::as_list()
roots <- r %>% map_df (~ .x[[1]][[1]] %>% as_tibble()) %>% transmute(root=value)


terminal_nodeset <- xml_find_all(lex, terminal_xpaths[[1]][2])
defs <- terminal_nodeset %>% xml2::as_list()


###ffollowing is for the entire div2 ###
defs[[1]][[1]] %>% enframe () %>% unnest %>% unnest
defs[[1]][[2]] %>% enframe () %>% unnest %>% unnest
opo<- defs %>% map (.f=function(m){
        m %>% map (~ .x %>% enframe() ) 
        } 
) %>% enframe

### this is for words only ###
terminal_nodeset <- xml_find_all(lex, terminal_xpaths[[1]][3])
words <- terminal_nodeset %>% xml2::as_list()
words_df <- words %>% 
    map_df (~ unlist(.x[["orth"]]) %>% as_tibble) 

## now for defintions alongside words ##
terminal_nodeset <- xml_find_all(lex,terminal_xpaths[[1]][2])
terminal_nodeset %>% map (function(ns) ns %>% xml_children)
