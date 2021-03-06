---
title: "Summarizing Negative Comment Categories"
author: "Shreya Goel"
project: "Comment Cards - Expedition Feedbacks"
output: html_document
---

```{r Install Packages}
install.packages("dplyr")
install.packages("tidyr")
install.packages("ggplot2")
```

```{r Read Data}
data <- read.csv("Data.csv", header = TRUE, sep = ",")
data1 <- data[-c(1:4,11:15,20:22,24:99,101,103:117)]
data2 <- dplyr::filter(data1, sg_year == "2018", sg_comment_yes_or_no == "1", sg_number_of_negatives >= "1")
data3 <- data2[c(25:44)]
data4 <- tidyr::gather(data3, key = "Feedback", value = "n")
data5 <- drop_na(data4)
data6 <- data5 %>% group_by(Feedback) %>% summarise(sum(n)) #Solution DATASET
colnames(data6) <- c("feedback", "number_of_records")
```

```{r Solution Table}
write.table(data6, ".../Solution.csv", sep=",")
```

```{r Counting # of comments sampled in the reporting}
data7 <- data3
data7$complains <- rowSums(data7, na.rm = TRUE)
data7$complains <- as.integer(data7$complains)
data8 <- dplyr::filter(data7, data7$complains > 0)
```

```{r Getting the Feedbacks barplot}
data6 <- data6[order(data6$number_of_records),]
feedback_plot <- ggplot(data6, aes(x=feedback, y=number_of_records))
feedback_plot + geom_bar(stat = "identity", aes(fill = data6$feedback)) + 
  geom_text(aes(label=number_of_records), vjust = -0.5, size = 3.5) +
  ylim(-2, 62) + 
  theme(axis.text.x=element_text(angle=90,hjust=1,vjust=0.01), axis.ticks.x=element_blank(), plot.title = element_text(face = "bold", size=15), legend.position = "none") +
    labs(title="Comment Cards", subtitle="2018 Data - 244 negative comments analyzed", y="Number of Records", x="Feedback")
```
