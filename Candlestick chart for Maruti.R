##Q4
# Loading necessary libraries
library(quantmod)
library(TTR)
library(PerformanceAnalytics)
library(ggplot2)

# Downloading stock data for MARUTI
Maruti <- getSymbols("MARUTI.NS",from = "2022-01-01",auto.assign = FALSE) #, to = till date
head(Maruti)
Maruti <- na.locf(Maruti)
class(Maruti)
candleChart(Maruti)

# Explanation of Candlestick Components:
#Body: The wide part of the candlestick, showing the difference between the opening and closing prices.

#Bullish (Green/White): Close price is higher than the open price.

#Bearish (Red/Black): Close price is lower than the open price.

#Wicks (Shadows): Thin lines above and below the body, representing the highest and lowest prices during the period.

#Upper Wick: Indicates the highest price.

#Lower Wick: Indicates the lowest price.

#Open Price: The price at which the security opened for the period.

#Close Price: The price at which the security closed for the period.



addSMA(20,  col = "blue")
addEMA(50,col = "yellow")
addMACD(50,col = "white")
addVo()

