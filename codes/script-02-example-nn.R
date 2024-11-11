# Set seed for reproducibility
set.seed(2024)

# Generate basic variables
n <- 1000

# Generate gender (płeć)
gender <- sample(c("K", "M"), n, replace = TRUE, prob = c(0.52, 0.48))

# Generate age (wiek) - normal distribution with mean 40 and sd 15, truncated to 18-80
age <- round(pmax(pmin(rnorm(n, mean = 40, sd = 15), 80), 18))

# Generate education (wykształcenie) with probabilities based on typical distribution
education_levels <- c("brak", "podstawowe", "średnie", "wyższe")
education_probs <- c(0.02, 0.13, 0.55, 0.30)  # approximate distribution
education <- sample(education_levels, n, replace = TRUE, prob = education_probs)

# Generate reading habits based on education and age
reading_prob <- function(edu, age) {
  # Base probabilities for education levels
  edu_prob <- switch(edu,
                     "brak" = 0.1,
                     "podstawowe" = 0.3,
                     "średnie" = 0.6,
                     "wyższe" = 0.8
  )
  
  # Age effect: slight increase until 50, then slight decrease
  age_effect <- ifelse(age <= 50,
                       1 + (age - 18) * 0.01,
                       1 + (50 - 18) * 0.01 - (age - 50) * 0.005
  )
  
  # Combine effects and ensure probability is between 0 and 1
  prob <- pmin(pmax(edu_prob * age_effect, 0), 1)
  return(prob)
}

# Generate reading status
reading <- sapply(1:n, function(i) {
  prob <- reading_prob(education[i], age[i])
  sample(c(TRUE, FALSE), 1, prob = c(prob, 1-prob))
})

# Function to calculate probability of missing data
missing_prob <- function(edu, age) {
  # Base probabilities for education levels (higher for lower education)
  edu_prob <- switch(edu,
                     "brak" = 0.6,
                     "podstawowe" = 0.35,
                     "średnie" = 0.2,
                     "wyższe" = 0.1
  )
  
  # Age effect: increasing with age
  age_effect <- 1 + (age - 18) * 0.005  # slight increase with age
  
  # Combine effects and ensure probability is between 0 and 1
  prob <- pmin(pmax(edu_prob * age_effect, 0), 1)
  return(prob)
}

# Generate missing values based on education and age
missing_probs <- sapply(1:n, function(i) {
  missing_prob(education[i], age[i])
})

missing_indices <- which(rbinom(n, 1, missing_probs) == 1)
reading_with_missing <- reading
reading_with_missing[missing_indices] <- NA

# Create data frame
data <- data.frame(
  plec = gender,
  wiek = age,
  wyksztalcenie = factor(education, levels = education_levels, ordered = TRUE),
  czyta_ksiazki = reading,
  czyta_ksiazki_z_brakami = reading_with_missing
)

# Save to CSV
write.csv(data, "data/data4-czytelnictwo.csv", row.names = FALSE)



