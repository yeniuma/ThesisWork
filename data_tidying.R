library(tidyverse)
library(academictwitteR)
library(writexl)
library(sentimentr)


all_tweets_retry <- bind_tweets(data_path = "twitter_adatok_btc_retry", output_format = "tidy")
write_xlsx(all_tweets_retry,"all_btc_tweets_retry.xlsx")

formatted_tweets <- all_tweets_retry %>% select(tweet_id, text, created_at,user_location,
                                                like_count, user_followers_count)

first_part_tweets <- formatted_tweets[1:200000,]
second_part_tweets <- formatted_tweets[200001:575511,]

first_part_sentences <- get_sentences(first_part_tweets$text)
second_part_sentences <- get_sentences(second_part_tweets$text)

first_part_grouped_sentiments <- sentiment_by(first_part_sentences)
second_part_grouped_sentiments <- sentiment_by(second_part_sentences)

all_sentiments <- bind_rows(first_part_grouped_sentiments,second_part_grouped_sentiments) %>% select(c(-element_id, -word_count))

btc_df_to_be_used <- cbind(formatted_tweets, all_sentiments)

#sentences <- get_sentences(formatted_tweets$text)
#sentiments <- sentiment(sentences)


#grouped_sentiment <- sentiment_by(sentences)
