# Repozytorium na potrzeby zajęć z przedmitu "Analiza danych niekompletnych"

## Podstawowe informacje

+ Materiały: github, moodle
+ Zaliczenie: projekt przez Kaggle
+ [Sylabus](https://esylabus.ue.poznan.pl/pl/document/8ba52650-091b-4852-9553-34fc9410f610.pdf)
+ [Slajdy](https://www.overleaf.com/read/kzydvvmfvtnq#32e3c2)
+ Shiny:
  + [Wizualizacja imputacji danych 1](https://berenz.shinyapps.io/missing-data-class1/)

+ Zaliczenie:
  + szablon w quarto: [plik.qmd](zaliczenie/szablon-raportu-adn2025.qmd), [wygląd raportu](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/zaliczenie/szablon-raportu-adn2025.html)
  + [szablon w jupyter notebook (colab)](https://colab.research.google.com/drive/1cfBdAJQv31UdpYDGj7wbs3dDzeCcbBAR?usp=sharing)
  
## Materiały na zajęcia

### 1. Problematyka braków danych

  + przydatne procedury:
    + R: `rnorm`, `plogis`, `density`, ...
    + Python: `np.random...`,  `gaussian_kde`, ...
  + [kody do generowania braków danych](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/codes/1-probelmatyka-brakow-danych.html)

### 2. Kodowanie braków danych w pakietatch statystycznych:
  + R: `NA`, `NA_integer_`, `NA_character_`, `is.na`, `Inf`, `NaN`
  + Python: `np.nan`, `pd.np.nan`, `pd.NA`, `pd.NaT`, `is.null`
  + Zbiory danych na potrzeby zajęć:
    + `csv`
    + `sav` -- [Bilans Kapitału Ludzkiego](https://www.parp.gov.pl/component/site/site/bilans-kapitalu-ludzkiego) -- [zbiór](), [kwestionariusz](https://www.parp.gov.pl/images/publications/BKL/Kwestionariusz_z_badania_ludnoci_BKL_edycja_2021_1.docx)

### 3. Metody wizualizacji braków danych
  + narzędzia:
    + R: `VIM`, `naniar`, `panelView`
    + Python: `missingno`, `upsetty`
  + Kody generujące przykłady: [R](codes/script-01-gen-mechanisms.R), [Python](codes/script-01-gen-mechanisms.py)
  + Zbiory danych na zajęcia: [dane przekrojowe](data/data2-cross_sectional.csv), [dane panelowe (long)](data/data2-panel_long.csv), [dane panelowe (wide)](data/data2-panel_wide.csv)
  + Zbiór danych na ćwiczenia [data2-zajecia-przyklad1.csv](data/data2-zajecia-przyklad1.csv)
  + Notatnik na zajęcia: [Wizualizacja braków danych](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/codes/2-wizualizacja-brakow.html)
  + [Notatnik](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/codes/2-wizualizacja-brakow-zadanie.html) z rozwiązaniem zadania z zajęć.
  
### 4. Imputacja danych

+ Imputacja dedukcyjna:
    + R: `zoo::na.locf`, `tidyr::fill`, `data.table::nafill`, `deducorrect`
    + Python: `fillna` z `pandas`
    + Zbiór danych na ćwiczenia [data3-zajecia-przyklad1.csv](data/data3-przyklad-imputacji.csv)
    + [Notatnik](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/codes/3-imputacja-dedukcyjna.html)

+ Imputacja metodą najbliższego sąsiada:
    + R: `simputation`, `VIM`
    + Python: `KNNImputer` z `sklearn.impute`
    + Zbiór danych na ćwiczenia [data4-czytelnictwo.csv](data/data4-czytelnictwo.csv)
    + [Notatnik](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/codes/4-imputacja-nn.html)
    
+ Imputacja metodą predykcyjnego dopasowania średnich (ang. *predictive mean matching*)
  + R: `simputation`, `FNN`
  + Python: `sklearn.linear_model`, `sklearn.neighbors`
  + Zbiór danych na ćwiczenia [data4-czytelnictwo.csv](data/data4-czytelnictwo.csv)
  + [Notatnik](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/codes/5-imputacja-pmm.html)

+ Imputacja wielokrotna
  + R: [`mice`](https://github.com/amices/mice), [`rMIDAS`](https://cran.r-project.org/web/packages/rMIDAS/index.html)
  + Python: `IterativeImputer` (from `sklearn.impute`), [`MIDASpy`](https://github.com/MIDASverse/MIDASpy)
  + [Notatnik](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/codes/6-imputacja-mi.html)

+ Imputacja regresyjna

### 5. Kalibracja

+ Wstęp do kalibracji
  + R: `survey`, `sampling`, `laeken`
  + Python: [`samplics`](https://samplics-org.github.io/samplics/pages/weight_adj.html)
  + [Notatnik](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/codes/7-kalibracja-wstep.html)
  + Dane na zajęcia [data5-kalibracja.csv](data/data5-kalibracja.csv)

+ Kalibracja (bardziej zaawansowana)
  + R: `survey`
  + Python: [`samplics`](https://samplics-org.github.io/samplics/pages/weight_adj.html)
  + [Notatnik](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/codes/8-kalibracja-case-study.html)
  + Dane na zajęcia [gospodarstwa-zajecia.xlsx](data/gospodarstwa-zajecia.xlsx)
  

### 6. Ważenie przez odwrotność prawdopodobieństwa odpowiedzi

+ PSW
  + R: `stats`, `glmnet`
  + Python: TBA
  + [Notatnik](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/codes/9-propensity-score.html)
  + Dane na zajęcia [gospodarstwa-zajecia.xlsx](data/gospodarstwa-zajecia.xlsx)
  

### 7. Estymacja wariancji

+ R: `boot`
+ Python: TBA
+ [Notatnik](https://htmlpreview.github.io/?https://raw.githubusercontent.com/DepartmentOfStatisticsPUE/adn-2025/refs/heads/main/codes/10-estymacja-wariancji.html)
+ Dane na zajęcia [gospodarstwa-zajecia.xlsx](data/gospodarstwa-zajecia.xlsx)