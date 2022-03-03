require(httr)  
require(dplyr)
require(rtweet)
require(tidyverse)
require(rjson)

result <- fromJSON(file = "twitter_tokens.json")
tokens_df <- as.data.frame(result)

appname <- tokens_df$appname
key <- tokens_df$key
secret <- tokens_df$secret
access_token <- tokens_df$access_token
access_secret <- tokens_df$access_secret

twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret,
  access_token = access_token,
  access_secret = access_secret)


btc_tweets <- search_tweets(q = "\"#btc\"", n = 50, include_rts = FALSE, 
                            lang="en",`-friends_count` = "0..10")

save(btc_tweets, file="btc_rtweet.RData")
load("btc_rtweet.RData")

