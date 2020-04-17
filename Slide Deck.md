Coursera Data Science Capstone Project - Word Prediction
========================================================
author: Ilja Muhl
date: 16.04.2020
autosize: true

The Task
========================================================

- The task of the Coursera Data Science Capstone Course ([see here](<https://www.coursera.org/learn/data-science-project/home/welcome>)) is to build a Shiny app that takes a input phrase (multiple words) and predicts the next word.  
- It should work similar to the an smartphone app that suggests you the next word, while you are typing.  
- The task is separated in smaller tasks, like data exploration, building the predictive function, building the shiny app.

The Model
========================================================

- The Model uses data form Twitter, Blogs and News article provided by Coursera ([see here]((<https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip>)) to train the prediction.
- The data is cleaned (to lower case, remove punctuation), n-grams and the frequency with which this n-grams occur in the data are calculated.  
- When a phrase is given, the model uses the last 1-3 words to find a matching n-gram that starts with these 1-3 words and have one additional word.  
- The model returns the additional words of the matching n-grams with the highest frequency in the training data.



The Shiny App
========================================================

- A Shiny App is build based on the described model above ([see here](www.test.de)).
- It uses precalculated n-gram tables as reference for the prediciton funciton.
- The App has an input field, where a phrase can be entered, a slider to adjust the number of words to be returned and a submit button to start the calculation
- Then 1-10 words with the highest probability to be the next word are displayed in the output field

The Links
========================================================

- Shiny App: <https://ilja-muhl.shinyapps.io/WordPrediction/>
- Code on github: <https://github.com/imuhl/Wordprediction>
- Coursera Data Science Capstone course: <https://www.coursera.org/learn/data-science-project/home/welcome>
