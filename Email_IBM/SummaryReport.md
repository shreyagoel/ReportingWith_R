---
title: "Summary Report"
author: "Shreya Goel"
project: "Email - Effective Pivots"
output: html_document
---

```{r}
setwd(".../Email_IBM")
```

```{r Install Packages}
install.packages("dplyr") 
install.packages("tidyr") 
```

```{r Read the data}
data <- read.csv("Data.csv", header = TRUE, sep = ",")
data <- data[c(3:39)]
```

```{r Subset data on 2017}
data1 <- dplyr::filter(data, year == "2017", mailing_name_short != "ReturningGuest", mailing_name_short != "ExploreMore", mailing_template != "AC", mailing_template != "NW", mailing_template != "WB", mailing_template != "TH", mailing_template != "PV")
```

```{r Understand the variables}
summary(data1$mailing_template)
summary(data1$mailing_name_short)
summary(data1$segment)
```
```{r Data Subsetting based on Segments in 2017 with all the filters}
summary(data1$segment)
data_ta <- dplyr::filter(data1, segment == "TA")
# subset date based on PG, HF, FFL, JP, Au
```

```{r Understanding the Effect of "Y" for Emails sent to Travel agents}
DATA <- data_ta # supply the data you wish to feed
DATA$y <- DATA$sent_day_of_week # Change Y --> group by product / email campaign / month / year / template etc. 

DATA$x <- 1

DATA1 <- aggregate(list(DATA$x,DATA$number_sent,DATA$unsubscribes,DATA$gross_click,DATA$unique_clicks,DATA$gross_open,DATA$unique_opens,DATA$gross_abuse), by=list(Weekday=DATA$y), FUN=sum)

names(DATA1) <- c("weekdays","count_ofemails","email_sent","unsubscribes","gross_clicks","unique _clicks","gross_open","unique_open","gross_abuse") # change the first column name according to the variable y selected above

Weekdays_TA <- DATA1 # Save your data table separately - This is a fixed table unlike the pivot table
```
