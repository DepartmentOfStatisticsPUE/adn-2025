import numpy as np
import pandas as pd

def generate_cross_sectional():
    np.random.seed(123)
    
    n = 100
    x1 = np.random.normal(0, 1, n)
    x2 = np.random.normal(0, 1, n)
    x3 = np.random.normal(0, 1, n)
    y = 0.5*x1 + 0.3*x2 + 0.2*x3 + np.random.normal(0, 1, n)
    
    df = pd.DataFrame({
        'y': y,
        'x1': x1,
        'x2': x2,
        'x3': x3
    })
    
    # Univariate missing (MCAR in x1)
    missing_indices = np.random.choice(n, 20, replace=False)
    df.loc[missing_indices, 'x1'] = np.nan
    
    # Multivariate missing (MCAR in x2 and x3)
    df.loc[np.random.choice(n, 15, replace=False), 'x2'] = np.nan
    df.loc[np.random.choice(n, 15, replace=False), 'x3'] = np.nan
    
    # Monotone missing pattern
    df = df.sort_values('x1')
    df.iloc[:10, df.columns.get_loc('x2')] = np.nan
    df.iloc[:20, df.columns.get_loc('x3')] = np.nan
    
    # MAR pattern (x3 missing depending on x1)
    mar_prob = pd.Series(x1).transform(lambda x: (x - x.mean()) / x.std())
    mar_prob = 1 / (1 + np.exp(-mar_prob))
    mar_missing = np.random.binomial(1, mar_prob)
    df.loc[mar_missing == 1, 'x3'] = np.nan
    
    return df

def generate_panel_data():
    n_units = 20
    n_years = 10
    years = range(2015, 2025)
    
    unit_ids = np.repeat(range(1, n_units + 1), n_years)
    year = np.tile(years, n_units)
    unit_effect = np.repeat(np.random.normal(0, 1, n_units), n_years)
    time_trend = (year - min(year)) / (max(year) - min(year))
    
    x1 = unit_effect + 0.5 * time_trend + np.random.normal(0, 0.5, n_units * n_years)
    x2 = unit_effect + 0.3 * time_trend + np.random.normal(0, 0.5, n_units * n_years)
    y = 0.4 * x1 + 0.3 * x2 + unit_effect + 0.2 * time_trend + np.random.normal(0, 0.3, n_units * n_years)
    
    panel_long = pd.DataFrame({
        'unit_id': unit_ids,
        'year': year,
        'y': y,
        'x1': x1,
        'x2': x2
    })
    
    # Unit attrition
    dropout_units = [3, 7, 12]
    dropout_mask = (panel_long['unit_id'].isin(dropout_units)) & (panel_long['year'] > 2020)
    panel_long.loc[dropout_mask, ['y', 'x1', 'x2']] = np.nan
    
    # Intermittent missing
    random_units = np.random.choice(range(1, n_units + 1), 8, replace=False)
    for unit in random_units:
        missing_years = np.random.choice(years, 2, replace=False)
        mask = (panel_long['unit_id'] == unit) & (panel_long['year'].isin(missing_years))
        panel_long.loc[mask, ['x1', 'x2']] = np.nan
    
    # Create wide format
    panel_wide = panel_long.pivot(index='unit_id', 
                                columns='year',
                                values=['y', 'x1', 'x2'])
    
    panel_wide.columns = [f"{var}_{year}" for var, year in panel_wide.columns]
    panel_wide = panel_wide.reset_index()
    
    return panel_long, panel_wide

def save_all_data():
    cross_sectional = generate_cross_sectional()
    panel_long, panel_wide = generate_panel_data()
    
    cross_sectional.to_csv('data/data2-py-cross_sectional.csv', index=False)
    panel_long.to_csv('data/data2-py-panel_long.csv', index=False)
    panel_wide.to_csv('data/data2-py-panel_wide.csv', index=False)
    
    return cross_sectional, panel_long, panel_wide

if __name__ == "__main__":
    cross_sectional, panel_long, panel_wide = save_all_data()
    
    print("\nCross-sectional missing patterns:")
    print(cross_sectional.isnull().sum())
    
    print("\nPanel (long format) missing patterns by year:")
    missing_by_year = pd.DataFrame({
        'y_missing': panel_long.groupby('year')['y'].apply(lambda x: x.isnull().sum()),
        'x1_missing': panel_long.groupby('year')['x1'].apply(lambda x: x.isnull().sum()),
        'x2_missing': panel_long.groupby('year')['x2'].apply(lambda x: x.isnull().sum())
    })
    print(missing_by_year)
    
    print("\nPanel (wide format) first few rows:")
    print(panel_wide.head())
    
