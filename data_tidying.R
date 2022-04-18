library(tidyverse)
library(academictwitteR)
library(writexl)
library(sentimentr)

data_combining_func <- function(path, output_xlsx){
  print("Combining JSONs into a data frame...")
  all_tweets <- bind_tweets(data_path = path, output_format = "tidy")
  print("Selecting columns...")
  formatted_tweets <- all_tweets %>% select(tweet_id, text, created_at,user_location,
                                            like_count, user_followers_count)
  
  n_of_rows <- nrow(formatted_tweets)
  print("Getting sentiments...")
  first_part_sentiments <- formatted_tweets[1:round(n_of_rows/2),2] %>%
    get_sentences() %>% 
    sentiment_by()
  second_part_sentiments <- formatted_tweets[(round(n_of_rows/2)+1):n_of_rows,2] %>%
    get_sentences() %>% 
    sentiment_by()
  print("Binding data frames together...")
  all_sentiments <- bind_rows(first_part_sentiments,second_part_sentiments) %>% select(c(-element_id, -word_count))
  print("Binding columns...")
  output_df_name <- cbind(formatted_tweets, all_sentiments)
  write_xlsx(output_df_name, output_xlsx)
  print("Done!")
  return(output_df_name)
}

btc_tweets <- data_combining_func("twitter_adatok_btc_retry", "all_btc_tweets.xlsx")
eth_tweets <- data_combining_func("twitter_adatok_eth", "all_eth_tweets.xlsx")

