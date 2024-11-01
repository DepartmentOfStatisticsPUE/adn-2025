# ui.R
library(shiny)
library(naniar)

ui <- fluidPage(
  titlePanel("Wizualizacja imputacji danych"),
  
  sidebarLayout(
    sidebarPanel(
      # Data generation controls
      numericInput("seed", "Ziarno (set.seed):", 
                   value = 123, min = 1),
      numericInput("n_obs", "Liczba obserwacji:", 
                   value = 2000, min = 100, max = 5000),
      
      # MAR mechanism controls
      sliderInput("miss_rate", "Odsetek braków danych w Y:",
                  min = 0.1, max = 0.5, value = 0.2, step = 0.05),
      sliderInput("mar_strength", "Siła zależnosci braków danych z X",
                  min = 0.1, max = 5, value = 1, step = 0.1),
      
      actionButton("generate", "Wygeneruj dane"),
      
      # Imputation method selection
      selectInput("method1", "Pierwsza metoda (lewa kolumna):",
                  choices = c("Mean" = "mean",
                              "Median" = "median",
                              "KNN" = "knn",
                              "Regression" = "regression",
                              "Random Hot Deck" = "hotdeck"),
                  selected = "mean"),
      selectInput("method2", "Druga metoda (prawa kolumna):",
                  choices = c("Mean" = "mean",
                              "Median" = "median",
                              "KNN" = "knn",
                              "Regression" = "regression",
                              "Random Hot Deck" = "hotdeck"),
                  selected = "knn"),
      
      # Add k parameter for KNN
      numericInput("k_param", "Liczba najbliższych sąsiadów:",
                   value = 5, min = 1, max = 20)
    ),
    
    mainPanel(
      fluidRow(
        column(6, 
               plotOutput("plot1", height = "400px"),
               plotOutput("marginal_y1", height = "200px")
        ),
        column(6, 
               plotOutput("plot2", height = "400px"),
               plotOutput("marginal_y2", height = "200px")
        )
      )
    )
  )
)