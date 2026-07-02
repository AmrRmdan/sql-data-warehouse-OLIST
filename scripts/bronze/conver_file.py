"""
Data Warehouse Project - Olist Dataset Cleaning Script
------------------------------------------------------
Purpose: 
This script cleans the 'olist_order_reviews_dataset.csv' file. 
It resolves formatting issues in review titles and messages (like newlines, 
commas, and quotes) that can break the CSV structure or corrupt data 
when loading it into a Data Warehouse.
"""
import pandas as pd


# Input path for the raw dataset
input_path = r"E:\project DataWarehouse\Brazilian E-Commerce Public Dataset by Olist\datasets\olist_order_reviews_dataset.csv"
# Output path for the clean dataset
output_path = r"E:\project DataWarehouse\Brazilian E-Commerce Public Dataset by Olist\datasets\olist_order_reviews_dataset_clean.csv"

print("Cleaning and adjusting encoding for the Reviews file...")

# Step 1: Load the dataset using UTF-8 encoding to preserve special Portuguese characters
df = pd.read_csv(input_path, encoding='utf-8')

# Step 2: Clean text columns using Regular Expressions (Regex)
# - .astype(str): Converts all data into strings to avoid errors with missing values (NaN)
# - str.replace(r'[\r\n,"]', ' '): Replaces carriage returns (\r), newlines (\n), commas (,), 
#   and double quotes (") with a single space. This prevents CSV parsing corruption.
df['review_comment_title'] = df['review_comment_title'].astype(str).str.replace(r'[\r\n,"]', ' ', regex=True)
df['review_comment_message'] = df['review_comment_message'].astype(str).str.replace(r'[\r\n,"]', ' ', regex=True)

# Step 3: Export the cleaned data back to a new CSV file
# - index=False: Prevents Pandas from writing row numbers into the file
# - encoding='utf-8': Ensures the file is saved with proper global text standards
df.to_csv(output_path, index=False, encoding='utf-8')

print("Cleaning successful! The new clean file is ready at:", output_path)
