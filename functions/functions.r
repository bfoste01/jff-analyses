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
