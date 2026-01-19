import pandas as pd

# Loading in the data
flow_df = pd.read_csv("G:/My Drive/Personal/Preppin Data/2024/Week 2/PD 2024 Wk 1 Output Flow Card.csv")
non_flow_df = pd.read_csv("G:/My Drive/Personal/Preppin Data/2024/Week 2/PD 2024 Wk 1 Output Non-Flow Card.csv")

# Checking the metadata
# flow_df.info()
'''
#   Column         Non-Null Count  Dtype
---  ------         --------------  -----
 0   Date           1883 non-null   object
 1   Flight Number  1883 non-null   object
 2   From           1883 non-null   object
 3   To             1883 non-null   object
 4   Class          1883 non-null   object
 5   Price          1883 non-null   float64
 6   Flow Card?     1883 non-null   object
 7   Bags Checked   1883 non-null   int64
 8   Meal Type      1594 non-null   object
'''
# This applies to the non_flow_info as well - know to change the date to a date format

# Unioning the data together
union_df = pd.concat([flow_df, non_flow_df]).reset_index()

# Converting the date field to a quarter number
union_df['Date'] = pd.to_datetime(union_df['Date']) # Change the date field to a date type
union_df['Date'] = union_df['Date'].dt.quarter # Getting the quarter number
union_df.rename(columns={'Date': 'Quarter'}, inplace=True) # Renaming Date to Quarter

# Getting the median price per Quarter, Flow Card? and Class and pivoting Class to columns
median_df = union_df.groupby(['Quarter', 'Flow Card?', 'Class'])['Price'].median().reset_index()
median_df = median_df.pivot(index= ['Quarter', 'Flow Card?'], columns = 'Class', values = 'Price').reset_index() # Pivoting the Class to columns and resetting the index
median_df.columns.name = '' # This gets rid of the class column name in the output after the pivot
median_df['Aggregation'] = 'Median' # Creating a new column for the aggregation type

# Getting the minimum price per Quarter, Flow Card? and Class and pivoting Class to columns
min_df = union_df.groupby(['Quarter', 'Flow Card?', 'Class'])['Price'].min().reset_index()
min_df = min_df.pivot(index= ['Quarter', 'Flow Card?'], columns = 'Class', values = 'Price').reset_index()
min_df.columns.name = ''
min_df['Aggregation'] = 'Minimum'

# Getting the maximum price per Quarter, Flow Card? and Class and pivoting Class to columns
max_df = union_df.groupby(['Quarter', 'Flow Card?', 'Class'])['Price'].max().reset_index()
max_df = max_df.pivot(index= ['Quarter', 'Flow Card?'], columns = 'Class', values = 'Price').reset_index()
max_df.columns.name = ''
max_df['Aggregation'] = 'Maximum'

# Union all of the pivoted sections
union_df = pd.concat([median_df, min_df, max_df]).reset_index(drop=True)

# Renaming the Class columns
union_df.rename(columns = {
    'Economy': 'First',
    'First Class': 'Economy',
    'Business Class': 'Premium',
    'Premium Economy': 'Business'
    },
    inplace=True
)

# Rearranging columns
union_df = union_df[['Flow Card?', 'Quarter', 'Aggregation', 'Economy', 'Premium', 'Business', 'First']]


print(union_df)
print("number of rows is", len(union_df))