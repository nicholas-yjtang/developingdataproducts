require (shiny)
require(UsingR)
require(kernlab)
require(caret)  
require(e1071)
require(gbm)
data(spam)


newdata <- spam[1,-length(spam)]

shinyServer(
  function(input, output) {

    isolate(withProgress(message = 'Currently creating the prediction model. Please wait...', value = 0.1, {

      if (!file.exists("model.rda")) {
        set.seed(12345)
        inTrain <- createDataPartition(y=spam$type,p=0.6,list=FALSE)
        training <- spam[inTrain,]
        testing <- spam[-inTrain,]
        fitControl <- trainControl(method="cv", number=10)
        modelFit <- train(type ~., data=training, method="gbm", 
                        trControl = fitControl, verbose=FALSE)  
        save(modelFit, file="model.rda")
      }
      else {
        load("model.rda")
      }
      setProgress(1)
    }))
    
    output$predictionresult <- renderText({
        input$goPredict    
        isolate({
          newtext <- input$spamtext      
          sapply(names(spam),setSpamData, text=newtext)      
          predictions <- predict(modelFit, newdata)
          as.character(predictions[[1]])
          })
    })    

    output$spamtable <- renderDataTable({ 
      input$goPredict
      newdata[,input$show_vars,drop=FALSE]                
    })
    
    output$originalspam <- renderDataTable({
      spam[,c(input$show_vars, "type"), drop=FALSE]      
    })
  }
)

setSpamData <- function(spamKeyword,text){  
  result <- 0
  if (nchar(text)==0) {
    
  }
  else if (grepl("^capital", spamKeyword)){
    num <- nchar(text)   
    capseq <- getCapSequence(text)
    if (grepl("Ave", spamKeyword)) {
      result <- mean(capseq)
    }
    else if (grepl("Long", spamKeyword)) {
      result <- max(capseq)
    } 
    else if (grepl("Total", spamKeyword)) {
      result <- sum(capseq)
    }
  }
  else {
    keyword <- spamKeyword
    num <- sum(gregexpr("\\W+", text)[[1]] > 0) + 1
    if (grepl("^char", spamKeyword)) {
      num <- nchar(text)
      if (grepl("Semicolon", spamKeyword)) {
        keyword <- ";"
      }
      else if (grepl("Roundbracket", spamKeyword)) {
        keyword <- "\\(|\\)"
      }
      else if (grepl("Squarebracket", spamKeyword)) {
        keyword <- "\\[|\\]"
      }
      else if (grepl("Exclamation", spamKeyword)) {
        keyword <- "\\!"
      }
      else if (grepl("Dollar", spamKeyword)) {
        keyword <- "\\$"
      }
      else if (grepl("Hash", spamKeyword)) {
        keyword <- "\\#"
      }       
    }
    else if (grepl("^num", spamKeyword)) {
      keyword <- gsub("^num", "", spamKeyword)
    }
    
    if (spamKeyword!="type") {
      result <- sum(gregexpr(keyword, text, ignore.case = TRUE)[[1]] > 0)/num * 100
    }  
  }
  if (spamKeyword!="type") {  
    newdata[1,spamKeyword] <<- result
  }
}

getCapSequence <- function(text) {
  num <- nchar(text)   
  capseq <- gregexpr("[A-Z]", text)[[1]]
  if (capseq[1] != -1) {
    returnVector <- c(1)
    if (length(capseq)!=1) {
      for (i in 2:length(capseq)) {      
        if (capseq[i]==capseq[i-1]+1) {
          returnVector[length(returnVector)] <- returnVector[length(returnVector)] + 1
        }
        else {
          returnVector <- append(returnVector, 1)      
        }
      }
    }
  }
  else {
    returnVector <- c(0)
  }
  returnVector
}
