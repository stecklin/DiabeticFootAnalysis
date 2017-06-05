#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Define UI for application that draws a histogram
 shinyUI(
   
   fluidPage(
     # Title 
     titlePanel("Diabetic Foot Application"),
     fluidRow(
       # Side panels
       column(3,
              wellPanel(
                selectInput(inputId = "algorithmns", label = "Choose an Algorithm:",
                            choices = c("Height","Weight", "Age"))
              ),
              wellPanel(
                h4("Filter"),
                tags$small(paste0(
                  "Depending on the selected algorithm, the user can modify different parameters"
                )),
                sliderInput("year", "I am a slider", 1940, 2014, value = c(1970, 2014)),
                sliderInput("oscars", "I am another slider",
                            0, 4, 0, step = 1),
                
                textInput("director", "Field for textinput"),
                textInput("cast", "Another field for textinput")
              ),
              wellPanel(
                selectInput("xvar", "Dummy x Variable", choices = c("A","B", "C")),
                selectInput("yvar", "Dummy y Variable", choices = c("1","2", "3")),
                tags$small(paste0(
                  "Note: Dummy for a note!"
                ))
              )
       ),
       
       #Plots
       column(9,
              # currently a histogram
              plotOutput(outputId = "plot1"),
              wellPanel(
                span("Dummy Histplot",
                     textOutput("Dummy Values")
                )
              ),
              # currently a scatterplot
              plotOutput(outputId = "plot2")
       )
     )
   )   

)
