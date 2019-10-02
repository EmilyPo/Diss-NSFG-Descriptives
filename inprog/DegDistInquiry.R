library(ergm.ego)
library(tidyverse)
library(reshape2)
library(srvyr)
library(plotly)


# import objects
alters <- readRDS("~/NSFG_DATA/Objects/alters.rds")
egos <- readRDS("~/NSFG_DATA/Objects/egos.rds")

# make objects SMALLER to more easily troubleshoot with 

egos2 <- egos %>% filter(sex %in% "M", age==20)
egoIds <- egos2$ego

alters2 <- alters[alters$ego %in% egoIds,]

# make ego data object
egodata <- egodata(egos=egos, alters=alters, egoIDcol = "ego")
#egodata <- egodata(egos=egos2, alters=alters2, egoIDcol = "ego")

## bits of pavel's code I think are the problem 

  egoIDcol <- egodata$egoIDcol
  
  egodata$egos[[egoIDcol]] <- factor(egodata$egos[[egoIDcol]])
  egodata$alters[[egoIDcol]] <- factor(egodata$alters[[egoIDcol]], levels=levels(egodata$egos[[egoIDcol]])) 
  egodata$egos[[egoIDcol]] <- as.integer(egodata$egos[[egoIDcol]])
  egodata$alters[[egoIDcol]] <- as.integer(egodata$alters[[egoIDcol]])
  
  degtable <- rep(0, nrow(egodata$egos))
  degtable[as.numeric(names(table(egodata$alters[egoIDcol])))] <- table(egodata$alters[egoIDcol])
  
  if(is.null(by)){
    deg.ego <- xtabs(egodata$egoWt~degtable)
    names(dimnames(deg.ego)) <- "degree"
    degrees <- as.integer(names(deg.ego))
  }else{
    deg.ego <- xtabs(egodata$egoWt~egodata$egos[[by]]+degtable)
    names(dimnames(deg.ego)) <- c(by, "degree")
    levs <- rownames(deg.ego)
    degrees <- as.integer(colnames(deg.ego))
    ncolors <- dim(deg.ego)[1]
  }

  
