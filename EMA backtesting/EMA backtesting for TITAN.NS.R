###Q1
##Shows when to hold when to sell
# Loading necessary libraries
library(quantmod)
library(writexl)
library(dplyr)

# Fetch historical stock data from 1st January 2021 till date
ticker <- "TITAN.NS"
stock_data <- getSymbols(ticker, from="2021-01-01", auto.assign = FALSE)
stock_data <- na.locf(stock_data)  # Handle any missing data by carrying the last observation forward

# Define periods for EMAs
short_period <- 5
long_period <- 21

# Calculate EMAs
ema_short <- EMA(Ad(stock_data), n = short_period)
ema_long <- EMA(Ad(stock_data), n = long_period)

# Generate signals based on EMA crossover (Buy when short EMA crosses above long EMA, Sell when it crosses below)
trading_signal <- ifelse((ema_short > ema_long) & (lag(ema_short) < lag(ema_long)), "Buy",
                         ifelse((ema_short < ema_long) & (lag(ema_short) > lag(ema_long)), "Sell", "Hold"))

# Convert trading signals into buy positions
# Initialize position and gain vectors
position <- ifelse(trading_signal == "Buy", 1, 0)  # Holding 1 unit on Buy, 0 otherwise
position <- na.locf(position, na.rm = FALSE)  # Carry forward the position until a Sell signal

# Calculate daily returns based on adjusted close price
daily_returns <- Return.calculate(Ad(stock_data), method = "discrete")
daily_returns[is.na(daily_returns)] <- 0  # Replace any NA returns with 0

# Strategy return: Daily returns only if we're in a buy position
strategy_returns <- daily_returns * position

# Calculate cumulative returns
cumulative_daily_ret <- cumprod(1 + daily_returns) - 1
cumulative_strategy_ret <- cumprod(1 + strategy_returns) - 1

# Prepare final data frame for export
stock_df <- data.frame(
  Date = index(stock_data),
  Adjusted_Close = as.numeric(Ad(stock_data)),
  EMA_Short = as.numeric(ema_short),
  EMA_Long = as.numeric(ema_long),
  Signal = trading_signal,
  Position = position,
  Daily_Return = as.numeric(daily_returns),
  Strategy_Return = as.numeric(strategy_returns),
  Cumulative_Daily_Return = as.numeric(cumulative_daily_ret),
  Cumulative_Strategy_Return = as.numeric(cumulative_strategy_ret)
)

# Export the data frame to Excel
output_filename <- paste0(ticker, "_EMA_Strategy_Backtesting.xlsx")
write_xlsx(stock_df, output_filename)
