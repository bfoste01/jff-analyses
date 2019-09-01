# Get lower triangle of the correlation matrix
  get_lower_tri<-function(cormat){
    cormat[upper.tri(cormat)] <- NA
    return(cormat)
  }

# Get upper triangle of the correlation matrix
  get_upper_tri <- function(cormat){
    cormat[lower.tri(cormat)]<- NA
    return(cormat)
  }

# Funtion to reorder the correlation matrix
reorder_cormat <- function(cormat){
# Use correlation between variables as distance
dd <- as.dist((1-cormat)/2)
hc <- hclust(dd)
cormat <-cormat[hc$order, hc$order]
}


# Function to tidy lavaan output
tidy.lavaan <- function(x, 
                        conf.int = TRUE,
                        conf.level = 0.95,
                        standardized=FALSE,
                        ...){
    tidyframe <- parameterEstimates(x, 
                       ci=conf.int, 
                       level=conf.level,
                       standardized=standardized) %>% 
        as_data_frame() %>% 
        tibble::rownames_to_column() %>% 
        mutate(term=paste(lhs, op, rhs)) %>% 
        rename(estimate=est, 
               std.error = se,
               p.value=pvalue,
               statistic = z,
               conf.low=ci.lower,
               conf.hi=ci.upper) %>% 
        select(term, op, everything(), -rowname, -lhs, -rhs)
    return(tidyframe)
}

## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
    library(plyr)

    # New version of length which can handle NA's: if na.rm==T, don't count them
    length2 <- function (x, na.rm=FALSE) {
        if (na.rm) sum(!is.na(x))
        else       length(x)
    }

    # This does the summary. For each group's data frame, return a vector with
    # N, mean, and sd
    datac <- ddply(data, groupvars, .drop=.drop,
      .fun = function(xx, col) {
        c(N    = length2(xx[[col]], na.rm=na.rm),
          mean = mean   (xx[[col]], na.rm=na.rm),
          sd   = sd     (xx[[col]], na.rm=na.rm)
        )
      },
      measurevar
    )

    # Rename the "mean" column    
    datac <- rename(datac, c("mean" = measurevar))

    datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean

    # Confidence interval multiplier for standard error
    # Calculate t-statistic for confidence interval: 
    # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
    ciMult <- qt(conf.interval/2 + .5, datac$N-1)
    datac$ci <- datac$se * ciMult

    return(datac)
}
fun_prop <- function (data = data.frame(), dots = NULL, ...) {

  dfr_prop <- data %>% 
    group_by_(.dots = dots) %>% 
    summarise_(n = ~n()) %>% 
    mutate(prop = prop.table(n))  # can this be done by NSE with mutate_() ??
  
  dfr_prop
} 
