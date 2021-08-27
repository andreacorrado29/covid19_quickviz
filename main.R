# main.R

# Script to visualize covid data per year + non parametric smooth per country
# contributor: Andrea Corrado
# last update: 2021-08-27

# set path
path <- "/home/ndrecord/Dropbox/r_COVID" 
setwd(path)

# execute
source('settings.R')
source('source_master.R')

# environment clean and garbage collection
rm(list = ls())
gc()
