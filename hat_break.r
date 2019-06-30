library(stringr)
library(arabicStemR)

adv.reverse.transliterate <- function (s){
    broken <- s %>% str_split("\\^")
    broken[[1]] %>% map( ~ .x %>% reverse.transliterate()) %>% paste0(collapse = " ")
}