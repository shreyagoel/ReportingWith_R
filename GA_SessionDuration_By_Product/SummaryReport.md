---
title: "Summary Report"
author: "Shreya Goel"
project: "Google Analytics - Session Duration"
output: html_document
---

```{r Install Packages}
install.packages("dplyr")
install.packages("tidyr")
```

```{r Data MAIN}

oct17 <- read.csv("oct2017.csv", header = TRUE, sep = ",")

#repeat the following segment for all the months that follow
data <- oct17
data$month <- "oct"
data$year <- 2017
oct17 <- data
rm(data)

nov17 <- read.csv("nov2017.csv", header = TRUE, sep = ",")
dec17 <- read.csv("dec2017.csv", header = TRUE, sep = ",")
jan18 <- read.csv("jan2018.csv", header = TRUE, sep = ",")
feb18 <- read.csv("feb2018.csv", header = TRUE, sep = ",")
mar18 <- read.csv("mar2018.csv", header = TRUE, sep = ",")
apr18 <- read.csv("apr2018.csv", header = TRUE, sep = ",")
may18 <- read.csv("may2018.csv", header = TRUE, sep = ",")
jun18 <- read.csv("jun2018.csv", header = TRUE, sep = ",")
jul18 <- read.csv("jul2018.csv", header = TRUE, sep = ",")
aug18 <- read.csv("aug2018.csv", header = TRUE, sep = ",")
sep18 <- read.csv("sep2018.csv", header = TRUE, sep = ",")
```

```{r Merging Data}
colnames(oct17) <- colnames(nov17) <- colnames(dec17) <- colnames(jan18) <- colnames(feb18) <- colnames(mar18) <- colnames(apr18) <- colnames(may18) <- colnames(jun18) <- colnames(jul18) <- colnames(aug18) <- colnames(sep18) <- c("session_duration","data_range","segment","unique_users","sessions","new_users","bounce_rate","email_signups","brochure_requests","brochure_views","brochure_downloads","month","year")

data <- full_join(oct17, nov17, by = NULL, copy = FALSE)
data <- full_join(data, dec17, by = NULL, copy = FALSE)
data <- full_join(data, jan18, by = NULL, copy = FALSE)
data <- full_join(data, feb18, by = NULL, copy = FALSE)
data <- full_join(data, mar18, by = NULL, copy = FALSE)
data <- full_join(data, apr18, by = NULL, copy = FALSE)
data <- full_join(data, may18, by = NULL, copy = FALSE)
data <- full_join(data, jun18, by = NULL, copy = FALSE)
data <- full_join(data, jul18, by = NULL, copy = FALSE)
data <- full_join(data, aug18, by = NULL, copy = FALSE)
data <- full_join(data, sep18, by = NULL, copy = FALSE)
```

```{r Data Subset}
data_all <- dplyr::filter(data, session_duration == "All")
data <- dplyr::filter(data, session_duration != "All")
```

```{r Data Cleaning - Part I}
data$session_duration <- gsub(" seconds", "", data$session_duration) 
data$segment <- gsub(" URL", "", data$segment)
data$segment <- gsub("SG ", "", data$segment)
data$unique_users <- gsub(",", "", data$unique_users)

data$segment <- as.factor(data$segment)
data$session_duration <- as.integer(data$session_duration)
data$unique_users <- as.integer(data$unique_users)
```

```{r Data Cleaning - Part II}
data$`<2mins` <- ifelse(data$session_duration<=180,1,0)
data$`2-5mins` <- ifelse(data$session_duration>180 & data$session_duration<=300,1,0)
data$`5-10mins` <- ifelse(data$session_duration>300 & data$session_duration<=600,1,0)
data$`10-30mins` <- ifelse(data$session_duration>600 & data$session_duration<=1800,1,0)
data$`>30mins` <- ifelse(data$session_duration>1800,1,0)

data$duration_segment <- ifelse(data$`<2mins`==1,"<2mins", 
                                ifelse(data$`2-5mins`==1,"2-5mins", 
                                       ifelse(data$`5-10mins`==1,"5-10mins",
                                              ifelse(data$`10-30mins`==1,"10-30mins",
                                                     ifelse(data$`>30mins`==1,">30mins",
                                                            "Unknown")))))
data$duration_segment <- as.factor(data$duration_segment)
data <- dplyr::filter(data, !is.na(data$duration_segment))
data$year <- as.factor(data$year)
```

```{r Towards the Summary by product - PART I}
data1 <- data[c(3,12,13,19,4)]
data1$month_year = paste(data1$month, data1$year, sep="_")
data_prod1 <- dplyr::filter(data1, segment == "Product1")
data_prod1 <- data_alas[c(6,4,5)]
# Do this for all other products
```

```{r Towards the Summary by product - PART II}
aggregate(unique_users ~ month_year + duration_segment, data = data_prod1, FUN = 'sum')
sol_prod1 <- ddply(data_prod1, .(month_year,duration_segment), summarize, UniqueUsers = sum(unique_users))
sol_prod1 <- tidyr::spread(data=sol_prod1, duration_segment, UniqueUsers)
sol_prod1$Product <- "Product 1"
# Do this for all other products

data2 <- full_join(sol_prod1, sol_prod2, by = NULL) # Do this for all other products
data2 <- data2[c(7,1:6)]
sol <- aggregate(data2[, 3:7], list(data2$Product), mean)
```

```{r Remove the unwanted data}
rm(data, data1, data_all, data_prod1, oct17, b=nov17, dec17, jan18, feb18, mar18, apr18, may18, jun18, jul18, aug18, sep18, sol_prod1, sol_prod2, data2)
```

```{r}
#Cleaning the final solution table
sol$`<2mins` <-round(sol$`<2mins`)
sol$`>30mins` <-round(sol$`>30mins`)
sol$`5-10mins` <-round(sol$`5-10mins`)
sol$`2-5mins` <-round(sol$`2-5mins`)
sol$`10-30mins` <-round(sol$`10-30mins`)
sol$Product <- sol$Group.1
sol <- sol[c(7,2:6)]
```

```{r SAVING SOLUTION TABLE}
write.table(sol, ".../Solution_R.csv", sep=",")
```
