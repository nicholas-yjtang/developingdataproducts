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
        'input.tabs=="Spam information"',
        checkboxGroupInput('show_vars', 'Columns in spam to show:',
                           names(spam)[1:length(spam)-1], selected = names(spam)[1:length(spam)-1]) 
      )
    ),
  mainPanel(
      tabsetPanel(
        id = "tabs",
        tabPanel("Prediction", 
                 div("This project will attempt to guess if the text you type (on the left hand side) in is considered spam"),
                 div("The prediction model is built using glm, with the spam data from the library kernlab"),
                 h2("The prediction output:"),
                 textOutput("predictionresult")
                 ),
        tabPanel("Spam information",
                 fluidPage(
                   titlePanel("Information on the spam input text"),
                   fluidRow(
                     dataTableOutput(outputId="spamtable")
                     )
                   )
                 )
        
      )
    )
))