# code from first attempt of this chapter, things that didn't make it into the final 
# mostly because it's easier to use the edgelist data rather than the wide data
# kept in rmd format because I am lazy 

## Active Variables
```{r active_vars, echo=FALSE}

fa1 <- nsfg1529 %>% filter(sex %in% "F") %>% count(active1)
fa2 <- nsfg1529 %>% filter(sex %in% "F") %>% count(active2)
fa3 <- nsfg1529 %>% filter(sex %in% "F") %>% count(active3)
fa1 <- InsertRow(fa1, c(6,NA), RowNum = 3)
actives <- data.frame(fa1, fa2[,2], fa3[,2])
colnames(actives) <- c("active", "First Partner", "Second Partner", "Third Partner")
actives[,1] <- as.character(actives[,1 ])

actives %>% plot_ly(x=~active, y=~`First Partner`, type="bar", name="First Partner") %>%
  add_trace(x=~active, y=~`Second Partner`, type="bar", name="Second Partner") %>%
  add_trace(x=~active, y=~`Third Partner`, type="bar", name="Third Partner")

ma1 <- nsfg1529 %>% filter(sex %in% "M") %>% count(active1)



```

## Total, based on pdeg.active summary
```{r nparts, echo=FALSE}
#1. total number active rels
Fnum <- nsfg1529 %>% filter(sex %in% "F") %>% summarize(total = sum(pdeg.active))
Mnum <- nsfg1529 %>% filter(sex %in% "M") %>% summarize(total = sum(pdeg.active))
nums <- data.frame(Sex=c("F", "M"), Total=c(Fnum[[1]], Mnum[[1]]))

kable(nums) %>% kable_styling(position="center", full_width = F)

f.prop <- nsfg1529 %>% filter(sex %in% "F") %>% count(pdeg.active) %>% mutate(prop = (n/sum(n))*100)
m.prop <- nsfg1529 %>% filter(sex %in% "M") %>% count(pdeg.active) %>% mutate(prop = (n/sum(n))*100)

dist2 <- cbind(f.prop[,c(1,3)], m.prop[,3]); 
colnames(dist2) <- c("Degree", "Females", "Males")

dist2 %>% plot_ly(x=~Degree, y=~Females, type="bar", name = "Females") %>%
  add_trace(x=~Degree, y=~Males, name="Males") %>%
  layout(xaxis=list(title=""), yaxis=list(title=""))
```


## Active Rel Types
### Overall
```{r reltypes, echo=FALSE}

op1 <- nsfg1529 %>% filter(active1==1) %>% count(optype1)
op2 <- nsfg1529 %>% filter(active2==1) %>% count(optype2)
op3 <- nsfg1529 %>% filter(active3==1) %>% count(optype3) # manually adjusting this, no 3s
op3 <- c(9,2,0,13,166)
rels <- c("Cur. Spouse", "Cur. Cohab", "Former Spouse", "Former Cohab", "Other")

ops <- cbind(rels, op1[2], op2[2], op3); colnames(ops) <- c("reltype", "rel1", "rel2", "rel3") 
ops <- ops %>% mutate(all = rel1+rel2+rel3) %>% 
  plot_ly(x=~reltype, y=~all, type="bar") %>%
  layout(xaxis=list(title="Active Relationship Type"), 
         yaxis=list(title=""))
ops
```

### By Age Cat

```{r relsage, echo=FALSE}

op1 <- nsfg1529 %>% filter(active1==1) %>% group_by(agecat) %>% count(optype1) 
dt1 <- dcast(op1, optype1~agecat, value.var = "n"); dt1[is.na(dt1)] <- 0

op2 <- nsfg1529 %>% filter(active2==1) %>% group_by(agecat) %>% count(optype2) 
dt2 <- dcast(op2, optype2~agecat, value.var = "n"); dt2[is.na(dt2)] <- 0

op3 <- nsfg1529 %>% filter(active3==1) %>% group_by(agecat) %>% count(optype3) 
dt3 <- dcast(op3, optype3~agecat, value.var = "n"); dt3[is.na(dt3)] <- 0

new <- c(3,0,0,0)
dt3 <- InsertRow(dt3, NewRow = new, RowNum=3)

dt <- dt1 + dt2 + dt3; dt[,1] <- rels; colnames(dt) <- c("reltype", "adols", "mid20s", "late20s")

dt %>% plot_ly(x=~reltype, y=~adols, type="bar", name = "15-19") %>%
  add_trace(x=~reltype, y=~mid20s, name="20-24") %>%
  add_trace(x=~reltype, y=~late20s, name="25-29") %>%
  layout(xaxis=list(title="Active Relationship Types"),
         yaxis=list(title=""))
```

### Rel Age by Rel Type

```{r relsage-type, echo=FALSE}
dur1 <- nsfg1529 %>% filter(active1==1) %>% group_by(rel1) %>% summarize(dur = mean(len1)) 

dur2 <- nsfg1529 %>% filter(active2==1) %>% group_by(rel2) %>% summarize(dur = mean(len2)) 

dur3 <- nsfg1529 %>% filter(active3==1) %>% group_by(rel3) %>% summarize(dur = mean(len3)) 

durs <- cbind(dur1, dur2[,2], dur3[,2]); colnames(durs) <- c("reltype", "first", "second", "third")
durs[,1] <- c("Current Married", "Current Cohab", "Other")

durs %>% plot_ly(x=~reltype, y=~first, type="bar", name = "1st most recent") %>%
  add_trace(x=~reltype, y=~second, name="2nd most recent") %>%
  add_trace(x=~reltype, y=~third, name="3rd most recent") %>%
  layout(xaxis=list(title="Active Relationship Types"),
         yaxis=list(title=""))
```

