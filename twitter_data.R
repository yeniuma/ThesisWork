require(httr)  
require(dplyr)
#require(rtweet)
require(tidyverse)
require(rjson)
require(data.table)
require(academictwitteR)

set_bearer()


btc_query <- build_query(query="(#btc OR #bitcoin  OR \"bitcoin\" OR \"btc\" OR \"xbt\" OR \"satoshi\")",lang="en",is_retweet=FALSE,is_verified=TRUE)

btc_tweets <- get_all_tweets(
  query=btc_query,
  start_tweets="2019-01-01T00:00:00Z",
  end_tweets="2022-03-30T23:59:59Z",
  data_path="twitter_adatok_btc_retry/",
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


