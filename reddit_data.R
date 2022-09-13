require(devtools)
require(pushshiftR)
require(httr)
require(dplyr)
require(tidyverse)
require(rjson)
require(tibble)
require(jsonlite)

before_time <- 1546905600
after_time <- 	1546300800

scraping_function <- function(b_time, a_time, until) {
  while (b_time <= until) {
    network_issue <- FALSE
    json_path <- paste("D:/Suli/Szakdolgozat1/data_to_be_cleaned/reddit_adat/bitcoin_sub/bitcoinJson", a_time, "_", b_time,".json", sep = "")
    tryCatch(
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
        write(toJSON(df),json_path)
        Sys.sleep(5)
      },
      error=function(errmsg) {
        if(grepl("HTTP", errmsg, fixed = TRUE)) {
          network_issue <- TRUE
          message("Here's the original error message:")
          message(errmsg)
          Sys.sleep(10)
        }
      }
    )
    if (!network_issue) {
      a_time <- a_time + 172800
      b_time <- b_time + 172800
    }
  }
}

scraping_function(before_time, after_time, 1648764000)

#json_path <- "myjson.json"
#myfile <- toJSON(test_tb)
#write(myfile,json_path)
#eeee_tb <- as.data.frame(fromJSON(paste(readLines(json_path), collapse="")), flatten=TRUE)
