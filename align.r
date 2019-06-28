
library(word.alignment)
ats = align.test ('http://www.um.ac.ir/~sarmad/word.a/euro.bg',
                      'http://www.um.ac.ir/~sarmad/word.a/euro.en',  
                      'http://www.um.ac.ir/~sarmad/word.a/euro.bg',
                      'http://www.um.ac.ir/~sarmad/word.a/euro.en',
                       n.train = 100,n.test = 5, encode.sorc = 'UTF-8')     