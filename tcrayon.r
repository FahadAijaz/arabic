library(crayon)

cat (blue ("hello ", "world\n"))

error <- red $ bold

cat (error ("this is it\n"))