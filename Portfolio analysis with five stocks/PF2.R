#loading necessary libraries 
library(tidyverse)
library(fPortfolio)
library(PerformanceAnalytics)
library(ggplot2)
library(quantmod)
library(zoo)
library(dplyr)


symbols = c("HDFCBANK.NS", "M&M.NS", "NTPC.NS", "LT.NS", "TCS.NS")
symbols
portfolio_stocks <- lapply(symbols, function(x){
  getSymbols(x, from= "2021-01-01" ,to= "2024-10-25",auto.assign = FALSE)
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

# calculating portfolio returns of 5 securities, taking equal weights 
portfolio_stocks_pfreturn<- Return.portfolio(portfolio_stocks_return,c(0.1,0.1,0.1,0.1,0.1),geometric=FALSE)
head(portfolio_stocks_pfreturn)

mean(portfolio_stocks_pfreturn)
var_cov<- cov(portfolio_stocks_return)
sd(portfolio_stocks_pfreturn)

# calculaing efficient frontier
efficient_frontier111 <- portfolioFrontier(portfolio_stocks_return, `setRiskFreeRate<-`(portfolioSpec(),0.064/252),constraints="longonly")
efficient_frontier111

# plotting efficient frontier
plot(efficient_frontier111,c(1,2,3,4,7,8)) 


###Finding out weights of minimum variance portfolio
# Set up the portfolio specification
spec <- portfolioSpec()
setRiskFreeRate(spec) <- 0.064 / 252  # Setting the risk-free rate for daily data

# Defining constraints for a long-only portfolio
constraints <- "LongOnly"

# Calculating the minimum variance portfolio
min_var_portfolio <- efficientPortfolio(portfolio_stocks_return, spec, constraints)
min_var_portfolio

# Extracting and viewing weights of the minimum variance portfolio
min_var_weights <- getWeights(min_var_portfolio)
print(min_var_weights)