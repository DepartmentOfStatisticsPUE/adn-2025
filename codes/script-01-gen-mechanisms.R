# Function to generate cross-sectional data with missing patterns
generate_cross_sectional <- function() {
  set.seed(123)
  
  # Generate complete data
  n <- 100
  x1 <- rnorm(n)
  x2 <- rnorm(n)
  x3 <- rnorm(n)
  y <- 0.5*x1 + 0.3*x2 + 0.2*x3 + rnorm(n)
  
  # Create data frame
  df <- data.frame(y=y, x1=x1, x2=x2, x3=x3)
  
  mar_prob <- pnorm(scale(df$x1))
  mar_missing <- rbinom(n, 1, mar_prob)
  
  # 0. MAR pattern (x3 missing depending on x1)
  
  df$x3[mar_missing == 1] <- NA
  
  # 1. Univariate missing (MCAR in x1)
  missing_indices <- sample(1:n, 20)
  df$x1[missing_indices] <- NA
  
  # 2. Multivariate missing (MCAR in x2 and x3)
  df$x2[sample(1:n, 15)] <- NA
  df$x3[sample(1:n, 15)] <- NA
  
  # 3. Monotone missing pattern
  df <- df[order(df$x1, na.last = TRUE),]
  
  
  df$x2[1:10] <- NA
  df$x3[1:20] <- NA

  
  return(df)
}

# Function to generate panel data
generate_panel_data <- function() {
  set.seed(456)
  
  # Parameters
  n_units <- 20
  n_years <- 10
  years <- 2015:2024
  
  # Generate base components
  unit_ids <- rep(1:n_units, each=n_years)
  year <- rep(years, times=n_units)
  unit_effect <- rep(rnorm(n_units, mean=0, sd=1), each=n_years)
  time_trend <- scale(year - min(year))
  
  # Generate variables
  x1 <- unit_effect + 0.5*time_trend + rnorm(n_units*n_years, sd=0.5)
  x2 <- unit_effect + 0.3*time_trend + rnorm(n_units*n_years, sd=0.5)
  y <- 0.4*x1 + 0.3*x2 + unit_effect + 0.2*time_trend + rnorm(n_units*n_years, sd=0.3)
  
  # Create long format
  panel_long <- data.frame(
    unit_id = unit_ids,
    year = year,
    y = y,
    x1 = x1,
    x2 = x2
  )
  
  # Add missing patterns
  # 1. Unit attrition
  dropout_units <- c(3, 7, 12)
  panel_long[panel_long$unit_id %in% dropout_units & panel_long$year > 2020, 
             c("y", "x1", "x2")] <- NA
  
  # 2. Intermittent missing
  random_units <- sample(1:n_units, 8)
  for(unit in random_units) {
    missing_years <- sample(years, 2)
    panel_long[panel_long$unit_id == unit & panel_long$year %in% missing_years, 
               c("x1", "x2")] <- NA
  }
  
  # Create wide format
  panel_wide <- reshape(panel_long, 
                        idvar = "unit_id",
                        timevar = "year",
                        direction = "wide")
  
  return(list(long = panel_long, wide = panel_wide))
}

# Main function to generate and save all datasets
generate_and_save_data <- function() {
  # Generate datasets
  cross_sectional <- generate_cross_sectional()
  panel_data <- generate_panel_data()
  
  # Save to CSV
  write.csv(cross_sectional, "data/data2-cross_sectional.csv", row.names = FALSE)
  write.csv(panel_data$long, "data/data2-panel_long.csv", row.names = FALSE)
  write.csv(panel_data$wide, "data/data2-panel_wide.csv", row.names = FALSE)
  
  # Return all datasets
  return(list(
    cross_sectional = cross_sectional,
    panel_long = panel_data$long,
    panel_wide = panel_data$wide
  ))
}

# Run the data generation
data_list <- generate_and_save_data()

# Display summaries
cat("\nCross-sectional missing patterns:\n")
print(colSums(is.na(data_list$cross_sectional)))

cat("\nPanel (long format) missing patterns by year:\n")
print(tapply(is.na(data_list$panel_long$y), data_list$panel_long$year, sum))

cat("\nPanel (wide format) first few rows:\n")
print(head(data_list$panel_wide))