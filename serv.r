# Server 
library(plumber)

pr <- plumber::plumb("plumber.R")
pr$routes

pr$run()
