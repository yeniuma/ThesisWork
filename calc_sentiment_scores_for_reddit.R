reddit_vader_df <- NULL

for (i in 1:nrow(sent_bitcoin_sub_df)){
  outs <-  vader_df(sent_bitcoin_sub_df$sentences[i])
  reddit_vader_df <- rbind(reddit_vader_df,outs)
}

write_rds(reddit_vader_df,"D:/Suli/Szakdolgozat1/data_to_be_cleaned/reddit_adat/bitcoin_sub/reddit_vader_df.rds")