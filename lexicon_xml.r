df = xmlInternalTreeParse(curr_abs)
df_root = xmlRoot(df)
df_children = xmlChildren(df_root)
r_list<-df_children[[2]] %>% xmlToList

d2s <- map (r_list$body$div1, ~ flatten(.x))

d2s%>%
  setNames(seq_along(.)) %>%
  Filter(. %>% is.null %>% `!`, .)
d2s %>% map ("div2")
df_flattened = map_dfr(df_children[[2]],  ~.x %>% 
                         xmlToList())







doc <- curr_abs %>% XML::xmlInternalTreeParse()
df1 <- lapply(terminal_xpaths, xml_to_df, file = doc, is_xml = TRUE, dig = FALSE) %>%
  dplyr::bind_cols()