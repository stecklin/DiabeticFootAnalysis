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

# Define server logic required to draw a plot
shinyServer(function(input, output) {
  
#load diabetic foot data
# !!!!!!!!!! path must be changed!!!  
footdata <-readRDS(paste0("C:/Users/Alina/Desktop/Uni/Visual Analytics/Projekt/ClusteringShiny/Data/data.rds")) %>% tidyr::unnest()


# reactive builds a reactive object, object will respond to every reactive value in the code
# some histplot dummy
histplot <- reactive({
 
  if(input$algorithmns == "Height")
    hist(footdata$Height, main= "Histogram for height", xlab= "Height", border="blue", col="green")
  if(input$algorithmns == "Weight")
    hist(footdata$Weight, main= "Histogram for weight", xlab= "Weight", border="blue", col="red")
  if(input$algorithmns == "Age")
    hist(footdata$Age, main= "Histogram for age", xlab= "Age", border="blue", col="yellow")
    
})

#some scatterplot dummy
scatterplot <- reactive({
  
  if(input$algorithmns == "Height")
    plot(footdata$Height, footdata$Weight)
  if(input$algorithmns == "Age")
    plot(footdata$Age, footdata$Weight)
    
})

output$plot1 <- renderPlot({
  
 dataplots = histplot()
 print(dataplots)
  
})

output$plot2 <- renderPlot({
  
  dataplots = scatterplot()
  print(dataplots)
  
})

  
})
