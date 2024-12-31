##Q6 Random waalk model

library(PerformanceAnalytics)
library(quantmod)
library(ggplot2)
library(dplyr)
library(zoo)
library(xts)
stock_prices <- getSymbols("ICICIBANK.NS", from = "2022-04-01", to = "2024-10-25",auto.assign =FALSE )
stock_prices <- Cl(stock_prices)  # Closing prices
# Calculating returns
stock_returns <- Return.calculate(stock_prices, method = "discrete")
stock_returns <- na.omit(stock_returns) 

# ALTERNATIVE METHOD
# Log returns (optional)
stock_returns_log <- Return.calculate(stock_prices, method = "log")
stock_returns_log <- na.omit(stock_returns_log)

set.seed(123) 




# Calculating mean and standard deviation of simple returns
mu <- mean(stock_returns)  # Mean return (drift)
mu
sigma <- sd(stock_returns)  # Volatility of returns
sigma
# Generate random walk
n <- 100  # Forecasting for next 100 days
random_walk <- numeric(n)  # Initialize vector for simulated prices

random_walk[1] <- as.numeric(last(stock_prices))  # Start from the last known price
tail(stock_prices,n=1)
class(stock_prices)
as.numeric(last(stock_prices))

for (i in 2:n) {
  random_walk[i] <- random_walk[i - 1] * (1 + mu + sigma * rnorm(1)) # Geometric RWM
}
future_dates <- seq(as.Date("2024-10-27"), by = "days", length.out = n)
class(future_dates)
random_walk_df <- data.frame(Date = future_dates, Price = random_walk)

ggplot(random_walk_df, aes(x = Date, y = Price)) +
  geom_line(color = "blue") +
  ggtitle("Random Walk Model Simulation for ICICIBANK.NS Stock Prices (Using Returns)") +
  xlab("Date") + ylab("Price")
