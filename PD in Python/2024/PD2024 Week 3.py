import pandas as pd
import numpy as np
import re

# Week 1 output loading
flow_card_df = pd.read_csv("G:/My Drive/Personal/Preppin Data/2024/Week 3/PD 2024 Wk 1 Output Flow Card.csv")
non_flow_card_df = pd.read_csv("G:/My Drive/Personal/Preppin Data/2024/Week 3/PD 2024 Wk 1 Output Non-Flow Card.csv")

# Union the Week 1 outputs
union_df = pd.concat([flow_card_df, non_flow_card_df], ignore_index=True)

# Week 3 Input loading and combining all of the sheets
wk3_xlsx = pd.read_excel("G:/My Drive/Personal/Preppin Data/2024/Week 3/PD 2024 Wk 3 Input.xlsx", sheet_name=None) # loads the entire excel file
wk3_combined = pd.concat(wk3_xlsx.values(), ignore_index=True) # Combines all the sheets into one dataframe

# Creating the if statement function for Class rename
def class_rename(x):
    if x == 'Economy':
        return 'First Class'
    elif x == 'First Class':
        return 'Economy'
    elif x == 'Business Class':
        return 'Premium Economy'
    else:
        return 'Business Class'

# Using the if statment to replace the Class row values
union_df['Class'] = union_df['Class'].apply(class_rename)

# Parsing out the first letter for each Class
def parse_first_letter(x):
    words = re.findall(r'\b\w', x)
    return "".join(words)
union_df['Class'] = union_df['Class'].apply(parse_first_letter)

# Changing the data type of Date to date
union_df['Date'] = pd.to_datetime(union_df['Date'])

# Getting the month number from Date
union_df['Date'] = union_df['Date'].dt.month 

# Sum the Price by Month and Class
summed_df = union_df.groupby(['Date', 'Class'])['Price'].sum().reset_index()

# Joining the targets data and flights data
new_union_df = pd.merge(
    left = wk3_combined, 
    right = summed_df,
    how = 'inner',
    left_on = ['Month', 'Class'],
    right_on = ['Date', 'Class']
)

# Difference to target and sorting
new_union_df['Difference to target'] = new_union_df['Price'] - new_union_df['Target']
new_union_df = new_union_df.sort_values(by = ['Difference to target'], ascending = True).reset_index(drop = True)

# Rearranging columns
new_union_df = new_union_df[['Difference to target', 'Date', 'Price', 'Class', 'Target']]

print(new_union_df)