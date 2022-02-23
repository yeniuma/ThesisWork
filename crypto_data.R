require(httr)
require(jsonlite)
require(dplyr)
require(rtweet)
require(tidyverse)
require(rjson)

result <- fromJSON(file = "tokens.json")
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


btc_tweets <- search_tweets(q = "#btc", n = 10000, include_rts = FALSE)


write.csv(btc_df, "btc_tweets.csv")

btc_df <- btc_tweets[, c("created_at", "screen_name", "text", "source", "is_quote", "is_retweet",
                         "favorite_count", "retweet_count","reply_count","quote_count", "hashtags")]

btc_df2 <- unnest(btc_df, hashtags)
sapply(btc_df, class)
write.csv(btc_df2, "btc_df.csv")
