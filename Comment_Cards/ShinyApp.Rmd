---
title: "Shiny App"
author: "Shreya Goel"
project: "Comment Cards - Expedition Feedbacks"
output: html_document
---

```{r Install Packages}
install.packages("dplyr")
install.packages("tidyr")
install.packages("ggplot2")
install.packages("plotly")
install.packages("shiny")
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

```{r Shiny Tool - POINT PLOT}
ui <- fluidPage(plotlyOutput("distPlot"))
server <- function(input, output) {
   output$distPlot <- renderPlotly({
      ggplot(data6, aes(x=feedback, y=number_of_records, color="blues")) + 
       geom_line() + 
       geom_point() +
       theme(axis.text.x=element_blank())})}
shinyApp(ui = ui, server = server)
```
