#!/bin/bash
# A simple script

git pull

docker run -p 8000:8000 -d -v `pwd`:/api -n recapi sumidu/plumber-rec Rscript /api/serv.r
