library(ngram)
library(tm)
library(tidytext)
library(quanteda)
library(data.table)
library(tokenizers)

source("textFunctions.R")

# get data ----------------------------------------------------------------

# blogs data
con <- file("../data/final/en_US/en_US.blogs.txt", open = "rb")
enBlogs <- readLines(con = con, encoding = "UTF-8", skipNul = TRUE)
close(con)

# news data
con <- file("../data/final/en_US/en_US.news.txt", open = "rb")
enNews <- readLines(con = con, encoding = "UTF-8", skipNul = TRUE)
close(con)

# twitter data
con <- file("../data/final/en_US/en_US.twitter.txt", open = "rb")
enTwitter <- readLines(con = con, encoding = "UTF-8", skipNul = TRUE)
close(con)

# convert to data.table
enBlogs <- data.table(text = enBlogs)
enNews <- data.table(text = enNews)
enTwitter <- data.table(text = enTwitter)

# combine to one data.tabe
dtCombined <- rbindlist(list(enBlogs = enBlogs,
                             enNews = enNews,
                             enTwitter = enTwitter), idcol = "source")

rm(enBlogs,enNews, enTwitter)


# calculation -------------------------------------------------------------

text <- dtCombined$text
rm(dtCombined)
gc()

minCount <- 3

for(n in 1:4) {
    print(paste0(n,"grams..."))
    if(n >= 4 && minCount == 1){
        minCount <- 2
    }
    
    # calculate ngrams and save results
    varName <- paste0("dt",n,"grams")
    print(
        system.time(
            assign(varName, calculateNGrams(text, n = n,
                                            stemWords = FALSE,
                                            minCount = minCount))))
    save(list = varName, file = paste0(varName,".rds"))
    
    # save a compact version of the results
    if(n >= 2){
        assign(paste0(varName,"Compact"),get(varName)[,c(n,(n+3)), with = F])
    } else {
        assign(paste0(varName,"Compact"),get(varName)[,1])
    }
    save(list = paste0(varName,"Compact"), file = paste0(varName,"Compact.rds"))
    
    
    rm(list = varName)
    rm(list = paste0(varName,"Compact"))
    gc()
}

# end ---------------------------------------------------------------------


