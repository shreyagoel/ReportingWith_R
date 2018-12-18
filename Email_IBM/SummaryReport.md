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
install.packages("dplyr") #Data Manipulation
install.packages("tidyr") #Data Manipulation
```

```{r Read the data}
data <- read.csv("Data.csv", header = TRUE, sep = ",")
data <- data[c(3:39)]
```

```{r Subset the data}
data1 <- dplyr::filter(data, year == "2017", mailing_name_short != "ReturningGuest", mailing_name_short != "ExploreMore", mailing_template != "AC", mailing_template != "NW", mailing_template != "WB", mailing_template != "TH", mailing_template != "PV")
```

```{r Understand the variables}
summary(data1$mailing_template)
summary(data1$mailing_name_short)
summary(data1$segment)
```

```{r Travel Agents Emails}
data_ta <- dplyr::filter(data1, segment == "TA")
data_ta$x <- 1
```

```{r Understanding the Effect of Weekdays for Emails sent to Travel agents}
data_ta1 <- aggregate(list(data_ta$x,data_ta$number_sent,data_ta$unsubscribes,data_ta$gross_click,data_ta$unique_clicks,data_ta$gross_open,data_ta$unique_opens,data_ta$gross_abuse), by=list(Weekday=data_ta$sent_day_of_week), FUN=sum)
names(data_ta1) <- c("weekdays","count_ofemails","email_sent","unsubscribes","gross_clicks","unique _clicks","gross_open","unique_open","gross_abuse")
```
