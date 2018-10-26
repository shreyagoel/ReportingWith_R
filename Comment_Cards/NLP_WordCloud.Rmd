---
title: "Sentiment Analysis and NLP - WordClouds"
author: "Shreya Goel"
project: "Comment Cards - Expedition Feedbacks"
output: html_document
---

```{r Install Packages}
install.packages("dplyr")
install.packages("tidyr")
install.packages("ggplot2")
install.packages("tm")
install.packages("SnowballC")
install.packages("wordcloud")
install.packages("topicmodels")
```

```{r Read Data}
data <- read.csv("Data.csv", header = TRUE, sep = ",")
data1 <- data[-c(1:4,11:15,20:22,24:99,101,103:117)]
data2 <- dplyr::filter(data1, sg_year == "2018", sg_comment_yes_or_no == "1", sg_number_of_negatives >= "1")
```

```{r NLP on selective comments}
data2 <- dplyr::filter(data1, sg_year == "2018", sg_comment_yes_or_no == "1", sg_number_of_negatives >= "1")
data9 <- data2[c(11,25:44)]
data11 <- data9
data11$res_exp_oe <- gsub("<.*?>", "", data11$res_exp_oe)
data11$res_exp_oe <- gsub("nbsb", "", data11$res_exp_oe)

corpus <- Corpus(VectorSource(data11$res_exp_oe))
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeWords, stopwords('english'))
corpus <- tm_map(corpus, stemDocument)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removeWords, "lindblad")

tdm.corpus <- TermDocumentMatrix(corpus)
positive <- readLines("positive-words.txt")
negative <- readLines("negative-words.txt")
data11$positive <- tm_term_score(tdm.corpus, positive)
data11$negative <- tm_term_score(tdm.corpus, negative)
data11$score <- data11$positive - data11$negative

dtm.tfi <- DocumentTermMatrix(corpus, control = list(weighting = weightTf))
dtm.tfi <- dtm.tfi[,dtm.tfi$v >= 0.1]
rowTotals <- apply(dtm.tfi , 1, sum)
dtm.tfi   <- dtm.tfi[rowTotals> 0, ]
lda.model = LDA(dtm.tfi, k = 3, seed = 150)
terms(lda.model)
topics(lda.model)

tdm.corpus <- TermDocumentMatrix(corpus)
mat<-as.matrix(tdm.corpus)
wordcount<-sort(rowSums(mat),decreasing = TRUE)
wordcount<-data.frame(word=names(wordcount),freq=wordcount)
head(wordcount,10)
set.seed(1)

#WORDCLOUD
wordcloud(words = wordcount$word,freq = wordcount$freq, min.freq = 5, max.words = 150, random.order = FALSE, rot.per = 0.35, colors = brewer.pal(12,"Paired"))
```
