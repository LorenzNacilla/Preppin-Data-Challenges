import pandas as pd
import datetime

df = pd.read_csv("G:/My Drive/Personal/Preppin Data/2024/Week 1/PD 2024 Wk 1 Input.csv")

# Splitting the Flight Details field based on the //
df2 = df["Flight Details"].str.split("//", expand=True)

# Renaming all of the split fields
df["Date"] = df2[0]
df["Flight Number"] = df2[1]
df["From and to"] = df2[2]
df["Class"] = df2[3]
df["Price"] = df2[4]

# Dropping the Flight Details field
df.drop(columns=["Flight Details"], inplace=True)

# Splitting the From and to based on the -
df3 = df["From and to"].str.split("-", expand=True)

# Renaming the From and To fields
df["From"] = df3[0]
df["To"] = df3[1]

# Dropping the original From and to field
df.drop(columns=["From and to"], inplace=True)

# Rearranging the columns
df = df.reindex(columns=["Date", "Flight Number", "From", "To", "Class", "Price", "Flow Card?", "Bags Checked", "Meal Type"])

# Replacing the FLow Card? column with 1 as yes and 0 as no
df["Flow Card?"] = df["Flow Card?"].apply(lambda x: "Yes" if x== 1 else "No")

# Making the Price field as a decimal/numeric
df["Price"] = pd.to_numeric(df["Price"])

# Changing the date format
df["Date"] = pd.to_datetime(df["Date"]) # Making it to a date type first
df["Date"] = df["Date"].dt.strftime("%d/%m/%Y") # Changing the format

# Rows where they have a flow card
flow_cards = df[df["Flow Card?"] == "Yes"]

# Rows where they don't have a flow card
non_flow_cards = df[df["Flow Card?"] == "No"]

print(flow_cards)
print(non_flow_cards)





