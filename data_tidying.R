library(tidyverse)
library(academictwitteR)
library(writexl)
library(plyr)
library(sentimentr)
library(lubridate)
library(plotly)


twitter_data_combining_func <- function(path, output_xlsx){
  print("Combining JSONs into a data frame...")
  all_tweets <- bind_tweets(data_path = path, output_format = "tidy")
  print("Selecting columns...")
  formatted_tweets <- all_tweets %>% 
    select(tweet_id, text, created_at,user_location,like_count, user_followers_count)
  
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

btc_tweets <- data_combining_func("twitter_adatok_btc_retry", "all_btc_tweets_test.xlsx")
eth_tweets <- data_combining_func("twitter_adatok_eth", "all_eth_tweets.xlsx")

reddit_data_combining_func <- function(path){
  reddit_df <- read.csv(file = path) %>% 
    filter(num_comments >= 10, selftext != "[removed]", is.na(excess)) %>%
    distinct(id, .keep_all =TRUE) %>% 
    select(created_utc, title, num_comments) %>%
    transform(created_utc = as_datetime(as.numeric(created_utc)))
  
  n_of_rows <- nrow(reddit_df)
  print("Getting sentiments...")
  reddit_sentiments <- reddit_df[1:n_of_rows,2] %>%
    get_sentences() %>% 
    sentiment_by()
  output_df <- cbind(reddit_df, reddit_sentiments) %>% select(c(-word_count,-element_id))
  print("Done!")
  return(output_df)
}

first_reddit_df <- reddit_data_combining_func("D:/Suli/szakdolgozat1/data to be cleaned/reddit_adat/reddit_tb_btc.csv")
second_reddit_df <- reddit_data_combining_func("D:/Suli/szakdolgozat1/data to be cleaned/reddit_adat/reddit_binance_bitcoin.csv") 
third_reddit_df <- reddit_data_combining_func("D:/Suli/szakdolgozat1/data to be cleaned/reddit_adat/reddit_CurrencyCurrency_btc.csv") #empty
fourth_reddit_df <- reddit_data_combining_func("D:/Suli/szakdolgozat1/data to be cleaned/reddit_adat/reddit_CurrencyCurrency_btc2.csv") #empty
fifth_reddit_df <- reddit_data_combining_func("D:/Suli/szakdolgozat1/data to be cleaned/reddit_adat/reddit_cryptocurrencies_bitcoin.csv") #empty

all_reddit_df <- rbind(first_reddit_df, second_reddit_df)

clean_btc_tweets <- btc_tweets %>% select(created_at, ave_sentiment) %>% mutate(created_at = as_datetime(created_at))
clean_reddit_data <- all_reddit_df %>% select(created_utc, ave_sentiment) %>% dplyr::rename(created_at = created_utc)
clean_btc_data <- bind_rows(clean_btc_tweets, clean_reddit_data)

btc_data_aggr <- clean_btc_data %>% 
  mutate(year = year(created_at), month = month(created_at), day = day(created_at)) %>%
  mutate(created_at = make_date(year, month,day)) %>%
  dplyr::group_by(created_at) %>%
  dplyr::summarize(daily_avg_sent = mean(ave_sentiment)) %>%
  plot_ly(x = ~created_at, y = ~daily_avg_sent, type= 'scatter', mode = 'lines', line = list(color = 'rgb(167, 112, 230)')
            , height = 500) %>%
  layout(title = "Average sentiment on Bitcoin from 2019 to 2022",
  paper_bgcolor='rgb(255, 255, 255)', plot_bgcolor='rgb(186, 186, 186)',
  xaxis = list(title = 'Date', range = list("2019-01-01 00:00:00", "2019-12-31 23:59:59"), rangeslider = list(type = "date", visible = T),
               list(dtickrange=list(NULL, 1000), value="%H:%M:%S.%L ms"),
               list(dtickrange=list(1000, 60000), value="%H:%M:%S s"),
               list(dtickrange=list(60000, 3600000), value="%H:%M m"),
               list(dtickrange=list(3600000, 86400000), value="%H:%M h"),
               list(dtickrange=list(86400000, 604800000), value="%e. %b d"),
               list(dtickrange=list(604800000, "M1"), value="%e. %b w"),
               list(dtickrange=list("M1", "M12"), value="%b '%y M"),
               list(dtickrange=list("M12", NULL), value="%Y Y"),
               rangeselector=list(
                 buttons=list(
                   list(count=1, label="1M", step="month", stepmode="backward"),
                   list(count=6, label="6M", step="month", stepmode="backward"),
                   list(count=1, label="1Y", step="year", stepmode="backward"),
                   list(count=1, label="YTD", step="year", stepmode="todate"),
                   list(step="all", label = "ALL")
                 )),
               list(dtick = "M1", tickformat="%b\n%Y",
                    ticklabelmode="period")),
  yaxis = list(title = "Average sentiment",
               gridcolor = 'rgb(255,255,255)',
               showgrid = TRUE,
               showline = FALSE,
               showticklabels = TRUE,
               tickcolor = 'rgb(140, 140, 140)',
               ticks = 'outside',
               zeroline = FALSE))

btc_data_aggr
