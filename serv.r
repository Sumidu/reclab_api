# Server  setup script to start the api 
# This script should run inside the docker container

library(plumber)

local_path <- "/api"

pr <- plumber::plumb(paste0(local_path,"/plumber.R"))
pr$routes

pr$run(port = 8000, host="0.0.0.0")
