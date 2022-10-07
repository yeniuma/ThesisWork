library('rvest')
library('stringr')
library('jsonlite')

url <- 'https://bitinfocharts.com/comparison/tweets-btc.html#alltime'
webpage <- read_html(url)
res <- str_match(webpage, 'new Dygraph\\(document.getElementById\\(\"container\\"\\),\\s*(.*?)\\s*, \\{labels')
res[,2] <- gsub("new Date\\(", "", res[,2])
res[,2] <- gsub("\\)", "", res[,2])
document <- fromJSON(txt=res[,2])
document
print(document[1, 1])
print(document[1, 2])

document <- as.data.frame(document)

write_csv(document, file = "D:/Suli/Szakdolgozat1/data_to_be_cleaned/n_of_tweets_#bitcoin.csv")
