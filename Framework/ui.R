#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(ggplot2)

header <- dashboardHeader(title = "Diabetic Foot Application")

# side bar with input parameters

sidebar <- dashboardSidebar(
  
    selectInput("algorithm", "Choose an Algorithm:", list("Hierarchical Clusting"="hclust", "Partitioning around Metoids"="pam", "Density Based Clustering"="dbscan")),
    conditionalPanel(
     condition = "input.algorithm =='hclust'",
     radioButtons("linkage", "Choose a Linkage Type:", c("Complete Linkage"="complete","Single Linkage"="single","Centroid Linkage"="centroid")),
     sliderInput("hclustnum", "Number of Clusters",1, 10, 0, step = 1)
    ),

    conditionalPanel(
     condition = "input.algorithm =='pam'",
     sliderInput("pclusttnum", "Number of Clusters",1, 10, 0, step = 1, value=4)
    ),

    conditionalPanel(
     condition = "input.algorithm =='dbscan'",
     numericInput("epsilon", "Epsilon Neightborhood",3),
     sliderInput("minPoints", "Number of Minimum Points",1, 10, 0, step = 1,value=4)
    ),
  
    
    fluidRow(
          column(1,tableOutput(outputId = "summary"))
          )
)

# body consisting of plots

body <- dashboardBody(

    fluidPage(
      
      fluidRow(
        column(6,plotOutput(outputId="mtk1_plot")),  
        column(6,plotOutput(outputId="mtk2_plot"))
 
      ),
      
      fluidRow(
        column(6,plotOutput(outputId="mtk3_plot")),  
        column(6,plotOutput(outputId="mtk4_plot"))
      ),
      
      fluidRow(
        column(6,plotOutput(outputId="mtk5_plot")),  
        column(6,plotOutput(outputId="D1.T"))
      ),
      
      fluidRow(
        column(6,plotOutput(outputId="L.T")),  
        column(6,plotOutput(outputId="C.T"))
      )
  )
)


ui <- dashboardPage(header, sidebar, body)
