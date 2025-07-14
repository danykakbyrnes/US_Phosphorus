# -*- coding: utf-8 -*-
"""
Created on Thu May  8 15:31:02 2025

@author: danyk
"""

import pandas as pd
import matplotlib.pyplot as plt
from dotenv import load_dotenv

load_dotenv()

# Filepaths to shapefile and raster (ESPG 5070)
Regional_filepath = os.getenv("PUE_DRIVERS")

sheetNames = ['Table11', 'Table12', # corn
              'Table17', 'Table18', # cotton 
              'Table23', 'Table24', # soybeans
              'Table29', 'Table30'] # wheat
sheet = 'Table11' 
for sheet in sheetNames:
    T = pd.read_excel(Regional_filepath+'fertilizeruse_ersdata.xlsx',
                      sheet_name=sheet)
    T.dropna(how='all', inplace=True)
    sheet_item = T.columns[0]
   
    years = [int(year) for year in T.iloc[0, 1:].tolist()]
    colNames = ['State'] + years
    T = T.drop([1, 3])  # Drop positions 1 and 3
    T = T.iloc[:-4]  # Drop the last 3 rows
    T.columns = colNames
    
    T_long = pd.melt(
    T,
    id_vars=[T.columns[0]],
    var_name='Year',
    value_name=sheet_item)
    
    if sheet in 'Table11':
        T_all = T_long 
    else:
        T_all = pd.merge(T_all, T_long, on=['State','Year'], how='outer')

    T_all.drop(T_all.loc[T_all['Year']==2018].index, inplace=True)
    
T_all.to_csv(Regional_filepath+'fertilizeruse_ersdata_reformatted.csv',
             index=False)
#%%  Filter data for specified state
State_Name = 'Illinois'
State_data = T_all[T_all['State'] == State_Name]

# Create a list of all the table columns for easier reference
table_columns = [
    'Table 11. Percentage of corn acreage receiving phosphate fertilizer, selected States',
    'Table 12. Phosphate used on corn, rate per fertilized acre receiving phosphate fertilizer, selected States',
    'Table 17. Percentage of cotton acreage receiving phosphate fertilizer, selected States',
    'Table 18. Phosphate used on cotton, rate per fertilized acre receiving phosphate, selected States',
    'Table 23. Percentage of soybean acreage receiving phosphate fertilizer, selected States',
    'Table 24. Phosphate used on soybeans, rate per fertilized acre receiving phosphate, selected States',
    'Table 29. Percentage of wheat acreage receiving phosphate fertilizer, selected States',
    'Table 30. Phosphate used on wheat, rate per fertilized acre receiving phosphate, selected States'
]

# Create short titles for each subplot
short_titles = [
    'Corn P2O5 Fertilized Acreage %',
    'Corn P2O5 Rate/Acre',
    'Cotton P2O5 P2O5 Fertilized Acreage %',
    'Cotton Rate/Acre',
    'Soybean P2O5 P2O5 Fertilized Acreage %',
    'Soybean P2O5 Rate/Acre',
    'Wheat P2O5 Fertilized Acreage %',
    'Wheat P2O5 Rate/Acre'
]

# Creating scatter plot for the specified state
plt.figure(figsize=(20, 10))

for i, (column, title) in enumerate(zip(table_columns, short_titles)):
    plt.subplot(2, 4, i+1)
    
    # Skip if data is all NaN/None
    if State_data[column].notna().any():  # Check if there's any non-NA data
        plt.plot(State_data['Year'], State_data[column], marker='o', linestyle='-', color='green')
        
        # Set y-label based on whether it's a percentage or rate
        if 'Percentage' in column:
            plt.ylabel('Percentage (%)')
        else:
            plt.ylabel('Rate (lbs/acre)')
            
        plt.title(title)
        
    else:
        plt.text(0.5, 0.5, 'No data available', 
                 horizontalalignment='center',
                 verticalalignment='center',
                 transform=plt.gca().transAxes)
        plt.title(title)

plt.suptitle(f'Phosphate Fertilizer Usage in {State_Name}',
             fontsize=16,
             y=1.02)

plt.tight_layout()
plt.show()

Corn_pctFert= [State_data.loc[State_data['Year'] <= 1980].iloc[:,2].mean(),
               State_data.loc[State_data['Year'] >= 2000].iloc[:,2].mean()]

Cotton_pctFert = [State_data.loc[State_data['Year'] <= 1980].iloc[:,4].mean(),
                  State_data.loc[State_data['Year'] >= 2000].iloc[:,4].mean()]


Soybean_pctFert = [State_data.loc[State_data['Year'] <= 1980].iloc[:,6].mean(), 
                   State_data.loc[State_data['Year'] >= 1980].iloc[:,6].mean(),
                  State_data.loc[State_data['Year'] <= 2017].iloc[:,6].mean()]

Wheat_pctFert = [State_data.loc[State_data['Year'] <= 1980].iloc[:,8].mean(),
                 State_data.loc[State_data['Year'] >= 2000].iloc[:,8].mean()]
