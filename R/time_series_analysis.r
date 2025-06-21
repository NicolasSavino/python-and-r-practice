# time_series_analysis.R
# A template for loading time-series data, decomposing, fitting an ARIMA model,
# forecasting future values, and evaluating model performance.

# 0. Install & load required packages ----
pkgs <- c("tidyverse", "lubridate", "forecast", "tseries")
installed <- rownames(installed.packages())
for (p in pkgs) if (!p %in% installed) install.packages(p)
library(tidyverse)
library(lubridate)
library(forecast)
library(tseries)

# 1. Read in time-series CSV ----
# Expect a CSV with columns Date (YYYY-MM-DD) and Value
df <- read_csv("data/time_series.csv",
               col_types = cols(
                 Date  = col_date(format = "%Y-%m-%d"),
                 Value = col_double()
               ))

# 2. Inspect and plot raw data ----
glimpse(df)
ggplot(df, aes(Date, Value)) +
  geom_line() +
  labs(title = "Raw Time Series", x = "Date", y = "Value")

# 3. Convert to ts object ----
# If daily, use frequency=365; monthly use 12; quarterly use 4; adjust as needed.
start_year  <- year(min(df$Date))
start_period<- month(min(df$Date))
ts_data <- ts(df$Value,
              start = c(start_year, start_period),
              frequency = 12)  # monthly data

# 4. Decompose series ----
decomp <- stl(ts_data, s.window = "periodic")
autoplot(decomp) + ggtitle("STL Decomposition")

# 5. Check stationarity ----
adf_test <- adf.test(ts_data, alternative = "stationary")
print(adf_test)

# 6. Fit ARIMA model automatically ----
fit <- auto.arima(ts_data, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)
summary(fit)

# 7. Diagnose residuals ----
checkresiduals(fit)

# 8. Forecast future values ----
horizon <- 12  # forecast 1 year ahead
fc <- forecast(fit, h = horizon)
autoplot(fc) +
  labs(title = "ARIMA Forecast", x = "Time", y = "Value")

# 9. Evaluate with a train/test split ----
# Reserve last `horizon` points for test
n_total <- length(ts_data)
n_train <- n_total - horizon
train_ts <- window(ts_data, end = c(time(ts_data)[n_train]))
test_ts  <- window(ts_data, start = c(time(ts_data)[n_train + 1]))

fit_train <- auto.arima(train_ts, seasonal = TRUE)
fc_train <- forecast(fit_train, h = horizon)

accuracy(fc_train, test_ts)  # gives MAE, RMSE, etc.

# 10. Save forecast and accuracy outputs ----
if (!dir.exists("output")) dir.create("output")
write_csv(as_tibble(fc_train), "output/forecasts.csv")
acc <- accuracy(fc_train, test_ts) %>% as_tibble(rownames = "Measure")
write_csv(acc, "output/accuracy.csv")

# 11. Wrap modeling in a function ----
run_arima_forecast <- function(ts_series, h = 12) {
  model <- auto.arima(ts_series)
  fc    <- forecast(model, h = h)
  list(model = model, forecast = fc, accuracy = accuracy(fc, ts_series))
}

# Example usage:
# result <- run_arima_forecast(ts_data, h = 6)
# print(result$accuracy)
