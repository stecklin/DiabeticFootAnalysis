#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
library(stringr)
library(cluster)
library(dbscan)
source("dataUtils.R")
source("evaluateResults.R")


shinyServer(function(input, output) {

# load datasets  
footdata <- loadRawData("C:/Users/Alina/Desktop/Uni/VisualAnalytics/Projekt/Daten_Zusatzaufgabe/data.rds")
distMat <- loadDistData("C:/Users/Alina/Desktop/Uni/VisualAnalytics/Projekt/Git/dtwDist_openEnd_cleaned.rds")  

# plot mean timeline
plot_mean <- function(data,sensor){
  
  if(input$algorithm=="hclust")
    predict<- addPredictions(footdata, clust_hclust())
  if(input$algorithm=="pam")   
    predict<- addPredictions(footdata, clust_pam()$clustering)
  if(input$algorithm=="dbscan")
    predict<- addPredictions(footdata, clust_db()$cluster)
  
  mean <- getMean(predict,data)
  names(mean)<-c("Cluster", "Time", "Mean")
  mean$Cluster <- factor(mean$Cluster)
  ggplot(data=mean, aes(x=Time, y=Mean, group=Cluster, color=Cluster)) +
    geom_line()+
    ggtitle(sensor)
}

# function for diabetic cluster info box
summary_plot<- function(){
  
  if(input$algorithm=="hclust")
    predict<- addPredictions(footdata, clust_hclust())
  if(input$algorithm=="pam")   
    predict<- addPredictions(footdata, clust_pam()$clustering)
  if(input$algorithm=="dbscan")
    predict<- addPredictions(footdata, clust_db()$cluster)
  
  summa <- getStatistics(predict)
  names(summa)<-c("Label","Cluster","Number")
  return(summa)
  
}

# ---- reactive clustering algirithms --------- # 
clust_pam <- reactive({
  pam(distMat, input$pclustnum)
})

clust_hclust <- reactive({
  hc <- hclust(as.dist(distMat), method=input$linkage)
  return(cutree(hc, k=input$hclustnum))
})

clust_db <- reactive({
  dbscan(distMat, input$epsilon, minPts=input$minPoints)
})
#-----------------------------------------------

#----- 8 plots for each sensor ------------------
output$mtk1_plot <- renderPlot({
  
  plot_mean(footdata$MTK1.T,"MTK1.T")
  
})

output$mtk2_plot <- renderPlot({
  
  plot_mean(footdata$MTK2.T,"MTK2.T")
  
})

output$mtk3_plot <- renderPlot({
  
  plot_mean(footdata$MTK3.T,"MTK3.T")
  
})

output$mtk4_plot <- renderPlot({
  
  plot_mean(footdata$MTK4.T,"MTK4.T")
  
})

output$mtk5_plot <- renderPlot({
  
  plot_mean(footdata$MTK5.T,"MTK5.T")
  
})

output$D1.T <- renderPlot({
  
  plot_mean(footdata$D1.T,"D1.T")
  
})

output$L.T <- renderPlot({
  
  plot_mean(footdata$L.T,"L.T")
  
})

output$C.T <- renderPlot({
  
  plot_mean(footdata$C.T,"C.T")
  
})

#output info cluster box
output$summary<-renderTable({
  
  summary_plot()
  
})
  
})
