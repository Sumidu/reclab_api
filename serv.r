# Server 
library(plumber)

pr <- plumber::plumb("plumber.R")
pr$routes

pr$run(port = 8080, host="0.0.0.0")
