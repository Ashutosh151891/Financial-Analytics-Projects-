library(fPortfolio)
library(timeSeries)
library(quantmod)
library(dplyr)
library(ggplot2)
library(zoo)
library(PerformanceAnalytics)
library(tidyverse)

symbols = c("COALINDIA.NS", "EICHERMOT.NS", "HDFCBANK.NS", "ADANIGREEN.NS", "TECHM.NS", "POWERGRID.NS", "NTPC.NS", "ITC.NS", "INFY.NS", "HEROMOTOCO.NS")
symbols
portfolio_stocks <- lapply(symbols, function(x){
  getSymbols(x, from= "2021-08-02" ,to= "2024-07-30",auto.assign = FALSE)
})
head(portfolio_stocks)
class(portfolio_stocks)

#converting it into data frame 
portfolio_stocks_df <- as.data.frame(portfolio_stocks)
class(portfolio_stocks_df)
portfolio_stocks_df <- Ad(portfolio_stocks_df)
portfolio_stocks_df

#converting the dat frame into timeseries \
portfolio_stocks_ts <- as.timeSeries(portfolio_stocks_df)

#calculating returns of individual securities
portfolio_stocks_return <- Return.calculate(portfolio_stocks_ts)
head(portfolio_stocks_return)

# removing NA values
portfolio_stocks_return<- na.omit(portfolio_stocks_return)
head(portfolio_stocks_return)

# calculating portfolio returns of 10 securities
portfolio_stocks_pfreturn<- Return.portfolio(portfolio_stocks_return,c(0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1),geometric=FALSE)
head(portfolio_stocks_pfreturn)

mean(portfolio_stocks_pfreturn)
var_cov<- cov(portfolio_stocks_return)
sd(portfolio_stocks_pfreturn)

# calculaing efficient frontier
efficient_frontier111 <- portfolioFrontier(portfolio_stocks_return, `setRiskFreeRate<-`(portfolioSpec(),0.07/252),constraints="longonly")
efficient_frontier111

# plotting efficient frontier
plot(efficient_frontier111,c(1,2,3,4)) 
