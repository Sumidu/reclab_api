# Server 
library(plumber)

pr <- plumber::plumb("/api/plumber.R")
pr$routes

pr$run(port = 8000, host="0.0.0.0")
getwd()
