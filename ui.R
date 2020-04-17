library(shiny)

# UI for word predictor application
shinyUI(fluidPage(
    
    # Application title
    titlePanel("Word Predictor"),
    
    # Sidebar with instructions ho to use the app
    sidebarLayout(
        sidebarPanel(
            
            h4("How to use this app"),
            br(),
            "1. Enter a text phrase in the input field",
            br(),br(),
            "2. Set the number of possible next words to predict",
            br(),br(),
            "3. Hit the Submit button"
        ),
        
        # Show input controls and predicted words
        mainPanel(
            textInput("inputText", "Input Pharse", "Go on a romantic date at the"),
            sliderInput("length", "No. of words in prediction", 1, 10, 3),
            actionButton("inputSubmit",label = "Submit",  
                         style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
            conditionalPanel(condition = "output.distText", 
                             h5("Perdicted Words")),
            verbatimTextOutput("distText")
        )
    )
))
