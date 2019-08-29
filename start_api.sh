#!/bin/bash
# A simple script

git pull

docker run -p 80:80 -d -v `pwd`:/api --name recapi sumidu/plumber-rec Rscript /api/serv.r

