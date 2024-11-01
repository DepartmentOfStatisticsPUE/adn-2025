# server.R
library(shiny)
library(simputation)
library(naniar)
library(dplyr)
library(ggplot2)
library(tidyr)

server <- function(input, output) {
  
  # Reactive values for storing datasets
  original_data_rv <- reactiveVal(NULL)
  data_rv <- reactiveVal(NULL)
  
  # Function to generate missing values using MAR mechanism
  generate_mar_missing <- function(data, x_var, miss_rate, strength) {
    n <- nrow(data)
    
    # Standardize X to have mean 0 and sd 1
    x_std <- scale(data[[x_var]])
    
    # Calculate probability of missing using logistic function
    # strength parameter controls how strongly X affects missingness
    logit <- strength * x_std
    prob_missing <- 1 / (1 + exp(-logit))
    
    # Adjust probabilities to achieve desired missing rate
    # This ensures we get approximately the requested proportion of missing values
    prob_missing <- prob_missing / sum(prob_missing) * n * miss_rate
    prob_missing <- pmin(prob_missing, 1)  # ensure no probability exceeds 1
    
    # Generate missing values based on calculated probabilities
    is_missing <- rbinom(n, 1, prob_missing) == 1
    
    return(is_missing)
  }
  
  # Generate data when button is clicked
  observeEvent(input$generate, {
    set.seed(input$seed)
    n <- input$n_obs
    
    # Generate X from log-normal distribution
    x <- rlnorm(n, meanlog = 2, sdlog = 0.3)
    
    # Generate Y with non-linear relationship to X
    y <- 1 + 5*x - 0.1*x^2 - 4*sin(x) - 5*cos(x) + rnorm(n, mean = 0, sd = sqrt(x))
    
    # Create original complete data frame
    original_data <- data.frame(x = x, y = y)
    original_data_rv(original_data)
    
    # Create data frame with missing values
    data <- original_data
    
    # Generate missing values in Y using MAR mechanism
    is_missing_y <- generate_mar_missing(data, "x", 
                                         input$miss_rate, 
                                         input$mar_strength)
    
    data$y[is_missing_y] <- NA
    
    data_rv(data)
  })
  
  # Initialize data on startup
  observe({
    if (is.null(data_rv())) {
      input$generate
    }
  })
  
  # Function to impute data using specified method
  imputeData <- function(data, method) {
    if(is.null(data)) return(NULL)
    
    imputed <- data
    
    # Store original missing value indicators
    is_missing_y <- is.na(data$y)
    
    # Apply imputation based on method
    if(method == "mean") {
      imputed <- impute_mean_all(imputed)
    } else if(method == "median") {
      imputed <- impute_median_all(imputed)
    } else if(method == "knn") {
      imputed <- impute_knn(imputed, y ~ x, k = input$k_param)
    } else if(method == "regression") {
      imputed <- impute_lm(imputed, y ~ x)
    } else if(method == "hotdeck") {
      imputed <- impute_rhd(imputed, y ~ 1)
    }
    
    # Add indicators for imputed values
    imputed$is_imputed_x <- FALSE  # X is never imputed
    imputed$is_imputed_y <- is_missing_y
    
    imputed
  }
  
  # Get imputed data for both methods
  getImputedData1 <- reactive({
    imputeData(data_rv(), input$method1)
  })
  
  getImputedData2 <- reactive({
    imputeData(data_rv(), input$method2)
  })
  
  # Create scatter plot function
  createScatterPlot <- function(data, method_name) {
    if(is.null(data)) return(NULL)
    
    ggplot(data, aes(x = x, y = y)) +
      # Plot non-imputed points
      geom_point(data = subset(data, !is_imputed_y),
                 color = "black", alpha = 0.6) +
      # Plot imputed points
      geom_point(data = subset(data, is_imputed_y),
                 color = "red", alpha = 0.6) +
      labs(title = paste("Metoda imputacji:", method_name),
           subtitle = "Wartości zaimputowane oznaczono kolorem czerwonym") +
      theme_minimal()
  }
  
  # Create marginal distribution plot function
  createMarginalPlot <- function(original_data, missing_data, imputed_data, var, method_name) {
    if(is.null(imputed_data)) return(NULL)
    
    # Create data for density plots
    original_df <- data.frame(
      value = original_data[[var]],
      type = "Oryginalne"
    )
    
    missing_df <- data.frame(
      value = missing_data[[var]],
      type = "Z brakami danych"
    )
    
    imputed_df <- data.frame(
      value = imputed_data[[var]],
      type = "Po zaimputowaniu"
    )
    
    combined_df <- rbind(original_df, missing_df, imputed_df)
    
    ggplot(combined_df, aes(x = value, color = type)) +
      geom_density(size = 1) +
      scale_color_manual(values = c("Oryginalne" = "black", 
                                    "Z brakami danych" = "gray",
                                    "Po zaimputowaniu" = "red")) +
      labs(title = paste("Rozkład zmiennej ", var, "-", method_name),
           x = var, y = "Gęstość") +
      theme_minimal() +
      theme(legend.position = "top")
  }
  
  
  # Render scatter plots
  output$plot1 <- renderPlot({
    createScatterPlot(getImputedData1(), input$method1)
  })
  
  output$plot2 <- renderPlot({
    createScatterPlot(getImputedData2(), input$method2)
  })
  

  output$marginal_y1 <- renderPlot({
    createMarginalPlot(original_data_rv(), data_rv(), getImputedData1(), "y", input$method1)
  })


  output$marginal_y2 <- renderPlot({
    createMarginalPlot(original_data_rv(), data_rv(), getImputedData2(), "y", input$method2)
  })
  

}