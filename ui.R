library (shiny)
library(kernlab)
data(spam)

shinyUI(pageWithSidebar(
  headerPanel("Predicting spam"),
  sidebarPanel(
      conditionalPanel(
        'input.tabs=="Prediction"',
        textInput(inputId="spamtext", label = "Insert your spam text here", value="Sample spam text"),
        actionButton("goPredict", "Predict")      
      ),
      conditionalPanel(
        'input.tabs=="Input information" || input.tabs=="Original data"',
        checkboxGroupInput('show_vars', 'Columns in input to show:',
                           names(spam)[1:length(spam)-1], selected = names(spam)[1:length(spam)-1]) 
      ),
      conditionalPanel(
        'input.tabs=="About"',
        div("Author: Nicholas Tang"),
        div("Version: 1.0")
      )      
    ),
  mainPanel(
      tabsetPanel(
        id = "tabs",
        tabPanel("Prediction", 
                 div("This project will attempt to guess if the text you type (on the left hand side) in is considered spam"),
                 br(),
                 div("The prediction model is built using boosted trees, with the spam data from the UCI Machine Learning"),
                 br(),
                 div("Please wait for an output to appear before attempting to use the application."),
                 br(),
                 br(),
                 h2("Prediction output:"),
                 br(),
                 div(textOutput("predictionresult"), style="color:blue;font-size=200%")
                 ),
        tabPanel("Input information",
                 div("This section describes the information on the input, transformed into data as described by ", 
                     a("UCI Machine Learning Repository",href="https://archive.ics.uci.edu/ml/machine-learning-databases/spambase/spambase.names")),                
                 br(),
                 div("Using the selection box on the left, you can choose which columns to display from the input information"),
                 br(),
                 fluidPage(
                   titlePanel("Information on the input text"),
                   fluidRow(
                     dataTableOutput(outputId="spamtable")
                     )
                   )
                 ),
        tabPanel("Original data",
                 div("This section describes the original spam data used to create the prediction model as given by ", 
                     a("UCI Machine Learning Repository",href="https://archive.ics.uci.edu/ml/datasets/Spambase")),                
                 br(),
                 div("Using the selection box on the left, you can choose which columns to display from the original spam data"),
                 br(),
                 fluidPage(
                   titlePanel("Information on the original spam data"),
                   fluidRow(
                     dataTableOutput(outputId="originalspam")
                   )
                 )
        ),        
        tabPanel("About", 
                div("More information on this project can be found ", a("here", href="https://nicholas-yjtang.github.io/developingdataproducts_slidify/")
                    )
        )
      )
    )
))