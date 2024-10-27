# Repozytorium na potrzeby zajęć z przedmitu "Analiza danych niekompletnych"

## Podstawowe informacje

+ Materiały: github, moodle
+ Zaliczenie: projekt przez Kaggle
+ [Sylabus](https://esylabus.ue.poznan.pl/pl/document/8ba52650-091b-4852-9553-34fc9410f610.pdf)
+ [Slajdy](https://www.overleaf.com/read/kzydvvmfvtnq#32e3c2)

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