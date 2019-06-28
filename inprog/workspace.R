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

nsfg <- readRDS("~/NSFG_DATA/Full/nsfg_complete.rds")
svy <- as_survey_design(nsfg, weights = weight, ids = CASEID)