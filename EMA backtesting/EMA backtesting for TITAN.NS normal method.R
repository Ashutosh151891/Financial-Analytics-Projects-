##Q1 
library(quantmod)
library(PerformanceAnalytics)
library(fPortfolio)
library(ggplot2)
library(dplyr)

library(writexl)

titan <- getSymbols("TITAN.NS", from = "2021-01-01",auto.assign = FALSE)
head(titan)
titan <- na.locf(titan)
#ema 5 computation
ema5 <- EMA(Ad(titan),n=5)
#ema 21 computation
ema21 <- EMA(Ad(titan),n=21)
# Identify the signal #
ema_trading_signal <- lag(ifelse(ema5>ema21 & lag(ema5)<lag(ema21),1,ifelse(ema5<ema21 & lag(ema5)>lag(ema21),-1,0)))
ema_trading_signal[is.na(ema_trading_signal)] <- 0
i=1
ema_trading_positions <- 0
changeover <- 0L
for(i in 1:nrow(titan)){
  if(ema_trading_signal[i]==1){
    ema_trading_positions[i] = 1
    changeover=1
  }else if(ema_trading_signal[i]==-1){
    ema_trading_positions[i]=0
    changeover=0
  }else {
    ema_trading_positions[i]=changeover
  }
}

sum(ema_trading_positions)

ema_trading_signal <- na.omit(ema_trading_signal)
sum(ema_trading_signal)
titan[1:2,1:2]
titan[c(1,3),c(4,6)]
titan[c(1,nrow(titan)),]
nrow(titan)


# Creating Trading Positions
daily_returns = Return.calculate(Ad(titan),method="discrete")
daily_returns[is.na(daily_returns)] <- 0
strategy_returns <- ema_trading_positions * daily_returns
#daily_returns <- na.omit(daily_returns)
#strategy_returns <- na.omit(strategy_returns)
cum_str_returns <-  cumprod(1+strategy_returns) - 1
cum_stock_returns <- cumprod(1+daily_returns) -1



titan_df <- cbind(titan,ema5,ema21,ema_trading_signal,ema_trading_positions,daily_returns,strategy_returns,cum_stock_returns,cum_str_returns)
class(titan_df)
head(titan_df)
titan_df <- as.data.frame(titan_df)
titan_df$Date <- row.names(titan_df)
titan_df <- relocate(titan_df,Date, .before = "TITAN.NS.Open")
colnames(titan_df) <- c("Date","Open","High","Low","Close","vol","Adj.P","EMA_n1","EMA_n2","EMA_sig","EMA_pos","dly_ret","str_ret","cum_d_ret","cum_str_ret")

write_xlsx(titan_df,"titan_ema_strategy(sum)-23258.xlsx")
getwd()


Return.annualized(daily_returns)
Return.annualized(strategy_returns)

table.AnnualizedReturns(daily_returns)
StdDev.annualized(daily_returns)
StdDev(daily_returns)
SharpeRatio(strategy_returns)