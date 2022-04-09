require(httr)  
require(dplyr)
#require(rtweet)
require(tidyverse)
require(rjson)
require(data.table)
require(academictwitteR)

#result <- fromJSON(file = "academic_twitter_tokens.json")
#tokens_df <- as.data.frame(result)
#
#appname <- tokens_df$appname
#key <- tokens_df$key
#secret <- tokens_df$secret
#access_token <- tokens_df$access_token
#access_secret <- tokens_df$access_secret
#bearer_token <- tokens_df$bearer_token


set_bearer()

#twitter_token <- create_token(
#  app = appname,
#  consumer_key = key,
#  consumer_secret = secret,
#  access_token = access_token,
#  access_secret = access_secret)

#query_ <- build_query(query="(#btc OR #bitcoin OR #ethereum OR #eth OR #dogecoin OR #doge OR #cake OR #pancakeswap OR \"Bitcoin\" OR \"Ethereum\" OR \"DogeCoin\" OR \"Pancakeswap\")",lang="en",is_retweet=FALSE,is_verified=TRUE)
#
#btc_tweets <- get_all_tweets(
#                query=query_,
#                start_tweets="2021-06-01T00:00:00Z",
#                end_tweets="2022-03-29T23:59:59Z",
#                data_path="twitter_adatok/",
#                bind_tweets=FALSE,
#                n=100000,
#                bearer_token=get_bearer(),
#                export_query=TRUE
#)

btc_query <- build_query(query="(#btc OR #bitcoin  OR \"bitcoin\" OR \"btc\" OR \"xbt\" OR \"satoshi\")",lang="en",is_retweet=FALSE,is_verified=TRUE)

btc_tweets <- get_all_tweets(
  query=btc_query,
  start_tweets="2019-01-01T00:00:00Z",
  end_tweets="2022-03-30T23:59:59Z",
  data_path="twitter_adatok_btc/",
  bind_tweets=FALSE,
  n=Inf,
  bearer_token=get_bearer(),
  export_query=TRUE
)

eth_query <- build_query(query="(#eth OR #ethereum  OR \"ethereum\" OR \"eth\")",lang="en",is_retweet=FALSE,is_verified=TRUE)

eth_tweets <- get_all_tweets(
  query=eth_query,
  start_tweets="2019-01-01T00:00:00Z",
  end_tweets="2022-03-30T23:59:59Z",
  data_path="twitter_adatok_eth/",
  bind_tweets=FALSE,
  n=Inf,
  bearer_token=get_bearer(),
  export_query=TRUE
)

#tweets <- search_tweets(q = '#btc OR #bitcoin OR #ethereum OR #eth OR #dogecoin OR #doge OR #cake OR #pancakeswap OR "Bitcoin" 
                        #OR "Ethereum" OR "DogeCoin" OR "Pancakeswap" is:verified', n = 100, 
                        #lang="en")

#selected <- btc_tweets2 %>%
  #filter(followers_count > 1000 & friends_count > 50)
  #select(created_at,	screen_name,	text,	source,	is_quote,	is_retweet,	favorite_count,	retweet_count,	reply_count,	quote_count,
  #       followers_count, friends_count)


#write.table(selected,file = 'btc_twitter_data.csv', append = TRUE, sep = ',', col.names = TRUE,
           #row.names = FALSE)

#save(btc_tweets, file="btc_rtweet.RData")
#load("btc_rtweet.RData")


