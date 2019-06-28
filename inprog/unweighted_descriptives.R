# unweighted descriptives & plots 
# not incluidng these in book, but didn't want to delete the work in case I need it at some point 

# sex
sex <- nsfg %>% count(sex)

p <- sex %>% 
  plot_ly(x= ~sex, y= ~n, type='bar', name="raw", color = I("indianred3")) %>%
  layout(yaxis = list(title="", barmode='group'), 
         xaxis = list(title=""),
         title = "Counts - Raw Data")


#age
ageF <- nsfg %>% filter(sex %in% "F") %>% count(age)
ageM <- nsfg %>% filter(sex %in% "M") %>% count(age)
age <- cbind(ageF, ageM[,2])
colnames(age)[2:3] <- c("Females", "Males") 

p_age <- age %>% 
  plot_ly(x= ~age, y= ~Females, type='bar', name="Females") %>%
  add_trace(x=~age, y=~Males, name="Males") %>%
  layout(yaxis = list(title="", barmode='group'), 
         xaxis = list(title=""),
         title = "Counts - Raw Data")

# race by sex 
raceF <- nsfg %>% filter(sex %in% "F") %>% count(race)
raceM <- nsfg %>% filter(sex %in% "M") %>% count(race)

race <- cbind(raceF, raceM[,2])
colnames(race)[2:3] <- c("Females", "Males") 

race %>% 
  plot_ly(x= ~race, y= ~Females, type='bar', name="Females") %>%
  add_trace(x=~race, y=~Males, name="Males") %>%
  layout(yaxis = list(title="", barmode='group'), 
         xaxis = list(title="Raw Data"))

# age cat and sex
age.race <- nsfg %>% count(agecat, race)
arboth <- dcast(age.race, agecat~race, value.var = "n")

p <- arboth %>% 
  plot_ly(x=~agecat, y= ~b, type='bar', name="Black") %>%
  add_trace(x=~agecat, y=~h, name="Hispanic") %>%
  add_trace(x=~agecat, y=~w, name="White") %>%
  add_trace(x=~agecat, y=~o, name="Other") %>%
  layout(yaxis = list(title="", barmode='group'), 
         xaxis = list(title=""), title="Counts- Raw Data")
p


#full weighted race
r1 <- nsfg %>% count(race) %>% mutate(prop = n/sum(n))
r2 <- svy %>% group_by(race) %>% summarize(n=survey_total()) %>% mutate(prop = n/sum(n))

props <- rbind(r1[,3], r2[,4]) 
props$id <- c(rep("raw",4), rep("weighted", 4))
props$race <- c(rep(c("black", "hispanic", "other", "white"),2))

ggplot(props, aes(x = id, y = prop, fill = race)) + geom_bar(stat = 'identity') + 
  scale_fill_manual(values=c('#1f77b4',  '#ff7f0e', '#d62728', '#2ca02c'))
