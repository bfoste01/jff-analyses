
# Hexabin
```{r}
items.hex.tot <- gather(items %>%
  select(ProfProg, LearnAnywhere, Personalization, FlexibleAssessment, Ownership), 
  subscale) 
  
# create hexbin
p.items.hex.tot.1 <- ggplot(items.hex.tot,aes(x=subscale,y=value)) + stat_binhex() + scale_fill_gradientn(colours=c("yellow","orange", "red"),name = "Frequency", na.value=NA) + 
  theme_fivethirtyeight() + 
  ylim(0, 15) 
# calculating mean for sample per subscale
out1 <- data.frame (with (items.hex.tot,  tapply( value, factor(subscale), mean, 
                                                  na.rm=TRUE)))
names(out1) <- c("meanY")
out1$grp <- rownames (out1)

# ploting mean connected with lines
p.items.hex.tot.2 <- p.items.hex.tot.1 + geom_point (aes(grp, meanY), data = out1, pch = 19, col = "blue", cex = 3)

# save the plot
ggsave("../plots/p.items.hex.tot.1.png", p.items.hex.tot.2, width = 8, 
    height = 5)
```

# Sandbox
```{r}
# select oute items for 
ProfProg.items <- gather(na.omit(select(items, mastercompR, nextcompR, rubricR)), item, value)

# create prop table 
ProfProg.prop <- ProfProg.items %>%
  group_by(item)%>%
  count(value) %>%
  mutate(prop = prop.table(n)) %>%
  select(-n) %>%
  spread(value, prop) 
# rename columns 
names(ProfProg.prop)[names(ProfProg.prop) == '0'] <- 'Never'
names(ProfProg.prop)[names(ProfProg.prop) == '1'] <- 'Sometimes'
names(ProfProg.prop)[names(ProfProg.prop) == '2'] <- 'Seldom'
names(ProfProg.prop)[names(ProfProg.prop) == '3'] <- 'Often'
names(ProfProg.prop)[names(ProfProg.prop) == '4'] <- 'Always'
ProfProg.prop

mytitle<-"\"Responses to the Proficiency-Based Progression Items\"\n"
mylevels<-c("Never", "Sometimes", "Seldom", "Often",  "Always")
numlevels<-length(ProfProg.prop[1,])-1
numcenter<-ceiling(numlevels/2)+1
ProfProg.prop$midvalues<-ProfProg.prop[,numcenter]/2
tab2<-cbind(ProfProg.prop[,1],ProfProg.prop[,2:ceiling(numlevels/2)],
  tab$midvalues,ProfProg.prop$midvalues,ProfProg.prop[,numcenter:numlevels+1])
colnames(tab2)<-c("outcome",mylevels[1:floor(numlevels/2)],"midlow",
  "midhigh",mylevels[numcenter:numlevels])


```

```{r}

tab<-read_csv("../data/test.csv") # from your path, with read.csv()

mytitle<-"\"What do you think will be the economic situation in your country during the next\nfew years (3-5 years) compared to the current situation?\"\n"
mylevels<-c("Much worse", "Somewhat worse", "Almost the same", "Somewhat better",  "Much better")

numlevels<-length(tab[1,])-1 #5
numcenter<-ceiling(numlevels/2)+1 #4
tab$midvalues<-tab[,numcenter]/2
tab2<-cbind(tab[,1],tab[,2:ceiling(numlevels/2)],
  tab$midvalues,tab$midvalues,tab[,numcenter:numlevels+1])
colnames(tab2)<-c("outcome",mylevels[1:floor(numlevels/2)],"midlow",
  "midhigh",mylevels[numcenter:numlevels])
```

```{r}
#data <- read_csv("../data/test.csv")
data<-read.csv("http://rnotr.com/assets/files/ab3.csv")
library(ggplot2)
library(reshape2)
library(magrittr)
library(plotly)

#starting coordinates for segments
data$s.Much.worse<-0-data$Much.worse-data$Somewhat.worse-.5*data$Almost.the.same
data$s.Somewhat.worse<-0-data$Somewhat.worse-.5*data$Almost.the.same
data$s.Almost.the.same<-0-.5*data$Almost.the.same
data$s.Somewhat.better<-0+.5*data$Almost.the.same
data$s.Much.better<-0+.5*data$Almost.the.same+data$Somewhat.better
#order by worse categories
data$Country<-factor(data$Country, levels = data$Country[order(-(data$s.Much.worse))])
#to percents
data[,2:11]<-data[,2:11]*100

mdfr <- melt(data, id=c("Country"))
mdfr<-cbind(mdfr[1:60,],mdfr[61:120,3])
colnames(mdfr)<-c("Country","variable","value","start")
#remove dot in levels
mylevels<-c("Much worse","Somewhat worse","Almost the same","Somewhat better","Much better")
mdfr$variable<-droplevels(mdfr$variable)
levels(mdfr$variable)<-mylevels
#custom color palette
pal<-c("#DF4949", "#E27A3F", "#BEBEBE","#45B29D", "#334D5C")

p<-ggplot(data=mdfr) +
  geom_segment(aes(x = Country, y = start, xend = Country, yend = start+value, colour = variable,
  text=paste("Country: ",Country,"<br>Percent: ",value,"%")), size = 6) +
  geom_hline(yintercept = 0, color =c("#646464")) +
  coord_flip() +
  scale_color_manual("Response", labels = mylevels, values = pal, guide="legend") +
  labs(title="", y="Percent",x="") +
  scale_y_continuous(breaks=seq(-100,100,25), limits=c(-100,100)) +
  theme(panel.background = element_rect(fill = "#ffffff"),
        panel.grid.major = element_line(colour = "#CBCBCB"))
p
p + theme_fivethirtyeight()
```



# Sandbox
# create count of missing  
ProfProg.count.na <- ProfProg.items %>%
  group_by(item)%>%
  count(is.na(value)) %>%
  rename(response = "is.na(value)",
         question = item, 
         count = n) %>%
  mutate(response = as.factor(response)) 

# recode logical values to not missing and missing
ProfProg.count.na$response <- dplyr::recode(ProfProg.count.na$response, "FALSE" = "Not Missing", "TRUE" = "Missing")
ProfProg.count.na

# plot
my_order_na <- c("Not Missing","Missing")

p.na <- licorice(ProfProg.count.na, answers_order = my_order_na, middle_pos = 2, type = "fill", sort=T) + 
  ggtitle("Response Variability in Proficiency-based Progression Items") + 
  labs(x = 'Questions', fill = 'Response') +
  theme(legend.position = 'bottom')
p.na + scale_fill_manual(values = rev(to_swap))
p.na
  
# combine
library(gridExtra)

grid.arrange(
  licorice(ProfProg.count, answers_order = my_order, middle_pos = 2, type = "center", sort=T) + 
  ggtitle("Response Variability in Proficiency-based Progression Items") + 
  labs(x = 'Questions', fill = 'Response') +
  theme(legend.position = 'bottom'),
  licorice(ProfProg.count.na, answers_order = my_order_na, middle_pos = 2, type = "fill", sort=T) +
    theme(axis.text.y=element_blank()) +
    scale_fill_discrete(""),
  ncol = 2,
  widths = c(3/4,1/4)
)


```
