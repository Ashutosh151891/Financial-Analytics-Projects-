library(timeSeries)
library(fPortfolio)
library(quantmod)
library(dplyr)
library(ggplot2)
library(PerformanceAnalytics)
library(tidyverse)
coalindia <- getSymbols("COALINDIA.NS",from = "2021-08-02",to = "2024-07-30", auto.assign = FALSE)
eichermot <- getSymbols("EICHERMOT.NS",from = "2021-08-02",to = "2024-07-30", auto.assign = FALSE)
hdfcbank <- getSymbols("HDFCBANK.NS",from = "2021-08-02",to = "2024-07-30", auto.assign = FALSE)
adanigreen <- getSymbols("ADANIGREEN.NS",from = "2021-08-02",to = "2024-07-30", auto.assign = FALSE)
techm <- getSymbols("TECHM.NS",from = "2021-08-02",to = "2024-07-30", auto.assign = FALSE)
powergrid <- getSymbols("POWERGRID.NS",from = "2021-08-02",to = "2024-07-30", auto.assign = FALSE)
ntpc <- getSymbols("NTPC.NS",from = "2021-08-02",to = "2024-07-30", auto.assign = FALSE)
itc <- getSymbols("ITC.NS",from = "2021-08-02",to = "2024-07-30", auto.assign = FALSE)
infy <- getSymbols("INFY.NS",from = "2021-08-02",to = "2024-07-30", auto.assign = FALSE)
heromoto <- getSymbols("HEROMOTOCO.NS",from = "2021-08-02",to = "2024-07-30", auto.assign = FALSE)

#Selecting only the adjusted price 
coalindia <- Ad(coalindia)
coalindia
eichermot <- Ad(eichermot)
hdfcbank <- Ad(hdfcbank)
adanigreen <- Ad(adanigreen)
techm <- Ad(techm)
powergrid <- Ad(powergrid)
ntpc <- Ad(ntpc)
itc <- Ad(itc)
infy <- Ad(infy)
heromoto <- Ad(heromoto)

#Omit the blank cells in indidividual stocks 
coalindia <- na.locf(coalindia)
eichermot<- na.locf(eichermot)
hdfcbank<- na.locf(hdfcbank)
adanigreen<- na.locf(adanigreen)
techm<- na.locf(techm)
powergrid<- na.locf(powergrid)
ntpc<- na.locf(ntpc)
itc<- na.locf(itc)
infy<- na.locf(infy)
heromoto<- na.locf(heromoto)

#now merging the ten stocks 
ten_stocks<- merge.xts(coalindia,eichermot,hdfcbank,adanigreen,techm,powergrid,ntpc,itc,infy,heromoto)
class(ten_stocks)
head(ten_stocks)

#calculating returns for the ten stocks 
ten_stocks_returns<- Return.calculate(ten_stocks, method = 'discrete')
head(ten_stocks_returns)
class(ten_stocks_returns)

#clearing na from ten stocks
ten_stocks_returns<- na.omit(ten_stocks_returns)

#calculating return of portfolio
ten_stocks_ptfreturns<- Return.portfolio(ten_stocks_returns, weights =c (0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1,0.1), geometric= FALSE)
ten_stocks_ptfreturns
mean(ten_stocks_ptfreturns)
var_cov<- cov(ten_stocks_returns)
sd(ten_stocks_ptfreturns)

#calculating ten stocks return
ten_stocks_returns<- as.timeSeries(ten_stocks_returns)
class(ten_stocks_returns)
efficient_frontier111<- portfolioFrontier(ten_stocks_returns,`setRiskFreeRate<-`(portfolioSpec(),0.07/252),constraints="longonly")

#plotting efficient frontier
plot(efficient_frontier111, c(1,2,3,4,7,8))

