library(gtrendsR)
library(writexl)
library(trendecon)

btc_google_trends <- ts_gtrends(keyword = c("bitcoin","btc","Bitcoin", "BTC"), time = "2019-01-01 2022-03-30")

btc_google_trends_daily <- ts_gtrends_mwd(keyword = c("bitcoin","btc","Bitcoin", "BTC"), from = "2019-01-01")

btc_interest_over_time <- btc_google_trends$interest_over_time

write.csv(btc_google_trends_daily, "btc_google_trends.csv")

hist(btc_google_trends_daily$value)

d <- density(btc_google_trends_daily$value)
plot(d, type="n")
polygon(d, col="red", border="gray")

