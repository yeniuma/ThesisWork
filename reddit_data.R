# require(RedditExtractoR)
# require(pushshiftR)
# result <- fromJSON(file = "reddit_tokens.json")
# tokens_df <- as.data.frame(result)
# 
# response <- POST("https://www.reddit.com/api/v1/access_token",
#                  authenticate(tokens_df$app_id, tokens_df$secret),
#                  user_agent(tokens_df$app_name),
#                  body = list(grant_type = "password",
#                              username = tokens_df$reddit_username,
#                              password = tokens_df$reddit_password))
# access_token_json <- rawToChar(response$content)
# access_token_content <- fromJSON(access_token_json)
#access_token <- access_token_content$access_token 


require(devtools)
require(pushshiftR)
require(httr)
require(dplyr)
require(tidyverse)
require(rjson)
require(tibble)

before_time <- 1586188861 #legut�bb: 1585756861
after_time <- 1586102461 #legut�bb: 1585580461
reddit_tb <- tibble(
  author = character(),
  title = character(),
  selftext = character(),
  created_utc = numeric(),
  id = character(),
  num_comments = numeric(),
  score = numeric(),
  subreddit = character()
)

scraping_function <- function(b_time, a_time, until, df) {
  while (b_time <= until) {
    try({append_tb <- getPushshiftData(
          postType = "submission",
          size = 700,
          after = a_time,
          before = b_time,
          title = "bitcoin",
          subreddit = "CryptoCurrency",
          nest_level = 1)
      df <- bind_rows(df, append_tb)
      write.table(append_tb,file = 'reddit_CurrencyCurrency_btc.csv',append = TRUE,sep = ',',col.names = FALSE,
        row.names = FALSE)
      cat("Looping.. Currently" , nrow(df) , "rows..\n")
      cat("Variables currently:\n before_time:",b_time,"after_time:",a_time,"\n")
      a_time <- a_time + 86400
      b_time <- b_time + 86400
      Sys.sleep(2)})}}

scraping_function(before_time, after_time, 1625003999, reddit_tb)


