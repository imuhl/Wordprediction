library(shiny)

# server logic to predict the next word based on an input phrase
shinyServer(function(input, output) {
    
    showModal(modalDialog("loading...", footer=NULL))
    
    # get pre-calculated data
    for(n in 1:4) {
        print(paste0("loading ",n,"grams"))
        print(system.time(load(file = paste0("dt",n,"gramsCompact.rds"))))
    }
    
    #load prediction function
    source("wordpredictor.R")
    
    removeModal()
    
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