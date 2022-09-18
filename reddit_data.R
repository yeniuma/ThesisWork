require(devtools)
require(pushshiftR)
require(httr)
require(dplyr)
require(tidyverse)
require(rjson)
require(tibble)

before_time <- 1546905600
after_time <- 	1546300800

scraping_function <- function(b_time, a_time, until) {
  while (b_time <= until) {
    path <- paste("D:/Suli/Szakdolgozat1/data_to_be_cleaned/reddit_adat/bitcoin_sub/bitcoinRds", a_time, "_", b_time,".rds", sep = "")
    network_issue <- tryCatch(
        {
          df <- getPushshiftData(
            postType = "submission",
            size = 1000,
            after = a_time,
            before = b_time,
            title = "bitcoin",
            subreddit = "Bitcoin",
            nest_level = 1)
          cat("Looping.. Currently" , nrow(df) , "rows..\n")
          cat("Variables currently:\n before_time:",b_time,"after_time:",a_time,"\n")
          write_rds(df,path)
          Sys.sleep(5)
        },
        error=function(errmsg) {
          if(grepl("HTTP", errmsg, fixed = TRUE)) {
            message("Here's the original error message:")
            message(errmsg)
            Sys.sleep(10)
            return(TRUE)
          }
          return(FALSE)
        }
    )
    if (is_empty(network_issue) || network_issue == FALSE) {
      print('Increase time interval by 2 days...')
      a_time <- a_time + 172800
      b_time <- b_time + 172800
    }
    else{
      print('Increase time interval by 1 day...')
      a_time <- a_time + 86400
      b_time <- b_time + 86400
      cat('Network issue, retrying same interval,', a_time, ',', b_time,'...')
    }
  }
}

scraping_function(before_time, after_time, 1648764000)
