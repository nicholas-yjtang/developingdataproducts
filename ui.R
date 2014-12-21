library (shiny)
library(kernlab)
data(spam)

shinyUI(pageWithSidebar(
  headerPanel("Predicting spam"),
  sidebarPanel(
      conditionalPanel(
        'input.tabs=="Prediction"',
        HTML('<label for="spamtext">Insert your spam text here</label>'),
        tags$textarea(id="spamtext", rows=5,"Sample spam text"),      
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
                 h3(textOutput("predictionresult"), style="color:blue;font-weight:bold;text-align:center")
                 ),
        tabPanel("Input information",
                 div("This section describes the information on the input, transformed into data as described by ", 
                     a("UCI Machine Learning Repository",href="https://archive.ics.uci.edu/ml/machine-learning-databases/spambase/spambase.names")),                
                 br(),
                 div("Using the selection box on the left, you can choose which columns to display from the input information"),
                 br(),
                 h2("Data Dictionary"),                 
                 div("41 continuous real [0,100] attributes of type [WORD] = percentage of words in the e-mail that match WORD, i.e. 100 * (number of times the WORD appears in the e-mail) total number of words in e-mail."),
                 div("For example the column name money indicates the word money occuring in the text"),
                 br(),
                 div("7 continuous real [0,100] attributes of type num[NUMBER] = percentage of words in the e-mail that match WORD, i.e. 100 * (number of times the WORD appears in the e-mail) total number of words in e-mail. "),
                 div("For example num857 indicates the number 857 occuring in the text"),
                 br(),
                 div("6 continuous real [0,100] attributes of type char[CHARACTER] = percentage of characters in the e-mail that match CHAR,i.e. 100 * (number of CHAR occurences) / total characters in e-mail"),
                 div("For example charExclaimation indicates the percentage of exclaimation marks over the total number of characters"),
                 br(),
                 div("capitalAve - 1 continuous real [1,...] attribute, of the average length of uninterrupted sequences of capital letters."),
                 br(),
                 div("capitalLong - 1 continuous integer [0,...] attribute, of the longest uninterrupted sequence of capital letters"),
                 br(),
                 div("capitalTotal - 1 continuous integer [0,...] attribute, of the total number of capital letters in the email"),
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
                 h2("Data Dictionary"),                 
                 div("41 continuous real [0,100] attributes of type [WORD] = percentage of words in the e-mail that match WORD, i.e. 100 * (number of times the WORD appears in the e-mail) total number of words in e-mail."),
                 div("For example the column name money indicates the word money occuring in the text"),
                 br(),
                 div("7 continuous real [0,100] attributes of type num[NUMBER] = percentage of words in the e-mail that match WORD, i.e. 100 * (number of times the WORD appears in the e-mail) total number of words in e-mail. "),
                 div("For example num857 indicates the number 857 occuring in the text"),
                 br(),
                 div("6 continuous real [0,100] attributes of type char[CHARACTER] = percentage of characters in the e-mail that match CHAR,i.e. 100 * (number of CHAR occurences) / total characters in e-mail"),
                 div("For example charExclaimation indicates the percentage of exclaimation marks over the total number of characters"),
                 br(),
                 div("capitalAve - 1 continuous real [1,...] attribute, of the average length of uninterrupted sequences of capital letters."),
                 br(),
                 div("capitalLong - 1 continuous integer [0,...] attribute, of the longest uninterrupted sequence of capital letters"),
                 br(),
                 div("capitalTotal - 1 continuous integer [0,...] attribute, of the total number of capital letters in the email"),
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