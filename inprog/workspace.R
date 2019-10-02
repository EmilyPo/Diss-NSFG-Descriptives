# necessary packages and data for working on chapters

library(here)
library(tidyverse)
library(plotly)
library(srvyr)
library(reshape2)
library(kableExtra)
library(scales)
library(DataCombine)
library(DT)

# full dataset - wide
nsfg <- readRDS("~/NSFG_DATA/Full/nsfg_complete.rds")
svy <- as_survey_design(nsfg, weights = weight, ids = ego)

# active partnerships - long 
long <- readRDS("~/NSFG_DATA/Objects/altersegos_active.rds")
svy_long <- as_survey_design(long, weights = e.weight, ids = ego)

# input objects for ergm.ego 
# for a tutorial on ergm.ego: 
# https://statnet.github.io/Workshops/ergm.ego_tutorial.html#5_the_package_ergmego

alters <- readRDS("~/NSFG_DATA/Objects/alters.rds")
egos <- readRDS("~/NSFG_DATA/Objects/egos.rds")
egos4alters <- readRDS("~/NSFG_DATA/Objects/egos4alters.rds")
