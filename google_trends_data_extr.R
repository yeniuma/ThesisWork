library(gtrendsR)
library(writexl)
# install.packages("remotes")
remotes::install_github("trendecon/trendecon")
library(trendecon)

btc_google_trends <- ts_gtrends(keyword = c("bitcoin","btc","Bitcoin", "BTC"), time = "2019-01-01 2022-03-30")

btc_google_trends_daily <- ts_gtrends_mwd("bitcoin", from = "2019-01-01")

btc_interest_over_time <- btc_google_trends$interest_over_time

write.csv(btc_google_trends_daily, "btc_google_trends.csv")

