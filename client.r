# Client  setup script to start the api 
# This is purely to test the API locally

library(plumber)

local_path <- "."

pr <- plumber::plumb(paste0(local_path,"/plumber.R"))
pr$routes

pr$run(port = 8000)
