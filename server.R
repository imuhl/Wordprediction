library(shiny)
library(data.table)

# server logic to predict the next word based on an input phrase
shinyServer(function(input, output) {
    
    showModal(modalDialog("loading...", footer=NULL))
    # # get pre-calculated data
    # for(n in 1:4) {
    #     print(paste0("loading ",n,"grams"))
    #     print(system.time(load(file = paste0("dt",n,"gramsCompact.rds"))))
    # }
    #load prediction function
    source("wordpredictor.R", local = TRUE)
    
    removeModal()
    
    # function to predict the next possible words from a given phrase
    wordprediction <- function(phrase) {
        words <- unlist(tokenize_words(phrase))
        count <- length(words)
        
        # check if last part (last 3, 2 or 1 word) of input phrase can be found in ngrams
        # and save next word of corresponding ngram in results
        result <- character()
        if(count >=3) {
            searchPhrase <- paste(words[(count-2):count],collapse=" ")
            grams <- dt4gramsCompact[nMinus1 == searchPhrase,][[1]]
            countGrams <- min(10,length(grams))
            if(countGrams > 0) {
                result <- grams[1:countGrams]
            }
        }
        if(count >=2) {
            searchPhrase <- paste(words[(count-1):count],collapse=" ")
            grams <- dt3gramsCompact[nMinus1 == searchPhrase,][[1]]
            countGrams <- min(10,length(grams))
            if(countGrams > 0) {
                result <- c(result,grams[1:countGrams])
            }
        }
        if(count >=1) {
            searchPhrase <- paste(words[count],collapse=" ")
            grams <- dt2gramsCompact[nMinus1 == searchPhrase,][[1]]
            countGrams <- min(10,length(grams))
            if(countGrams > 0) {
                result <- c(result,grams[1:countGrams])
            }
        }
        result <- c(result,dt1gramsCompact[[1]])
        result <- unique(result)
        result[1:10]
    }
    
    # execute only if submit button was hit
    reactivePrediction <- eventReactive(
        input$inputSubmit,
        {
            showModal(modalDialog("calculating...", footer=NULL))
            print(system.time(predWords <- paste(wordprediction(input$inputText)[1:input$length], 
                                                 collapse = "\n")))
            removeModal()
            predWords
        }
    )

    # render prediction output
    output$distText <- renderText({
        reactivePrediction()
    })
    
    
})
