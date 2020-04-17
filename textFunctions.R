library(ngram)
library(tm)
library(tidytext)
library(quanteda)
library(data.table)
library(tokenizers)
library(qdapDictionaries)
library(lexicon)

data(profanity_alvarez)

# creates data.table with ngrams, single words, n-1 ngram and counts of occurances
calculateNGrams <- function(text, n = 3L, stopwords = character(), 
                            stemWords = FALSE, minCount = 1) {
    # special treatment if words should be stemmed
    if(stemWords) {
        text <- tokenize_word_stems(text, stopwords = stopwords)
        text <- sapply(text, paste, collapse = " ")
    }
    
    # calculate ngrams
    vecNGrams <- unlist(tokenize_ngrams(text, n = n, stopwords = stopwords))
    dtNGrams <- data.table(nGram = vecNGrams)
    rm(vecNGrams)
    gc()
    
    # delete NAs 
    dtNGrams <- dtNGrams[!is.na(nGram),]
    # count occurances and delete occurances less than minCount
    setkey(dtNGrams,nGram)
    dtNGrams <- dtNGrams[,.N,by = nGram]
    dtNGrams <- dtNGrams[N >= minCount,]
    
    # delete profanity words
    dtNGrams <- dtNGrams[!dtNGrams[[n]] %in% profanity_alvarez,]
    
    # split ngrams and count occurances, when last word is excluded
    if(n > 1) {
        dtNGrams <- cbind(dtNGrams[,tstrsplit(nGram, " ")],dtNGrams)
        dtNGrams[,nMinus1 := do.call(paste,.SD), .SDcols = 1:(n-1)]
        dtNGrams[,countMinus1:=sum(N), by = nMinus1]
        dtNGrams <- dtNGrams[order(countMinus1,N,decreasing = T)]
    } else {
        dtNGrams <- dtNGrams[order(N,decreasing = T)]
    }
    rm(text)
    gc()
    dtNGrams
}
