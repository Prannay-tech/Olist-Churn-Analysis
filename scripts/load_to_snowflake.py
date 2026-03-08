import os
import pandas as pd
import snowflake.connector
from snowflake.connector.pandas_tools import write_pandas
from dotenv import load_dotenv
from cryptography.hazmat.primitives import serialization

load_dotenv()

with open("keys/rsa_key.p8", "rb") as key_file:
    private_key = serialization.load_pem_private_key(key_file.read(), password=None)

conn = snowflake.connector.connect(
    account=os.getenv('SNOWFLAKE_ACCOUNT'),
    user=os.getenv('SNOWFLAKE_USER'),
    private_key=private_key,
    warehouse=os.getenv('SNOWFLAKE_WAREHOUSE'),
    database=os.getenv('SNOWFLAKE_DATABASE'),
    schema=os.getenv('SNOWFLAKE_SCHEMA'),
    role='ACCOUNTADMIN'
)

cursor = conn.cursor()
cursor.execute("USE DATABASE OLIST_DB")
cursor.execute("USE SCHEMA RAW")
cursor.execute("USE WAREHOUSE OLIST_WH")

files = {
    'olist_customers_dataset.csv': 'CUSTOMERS',
    'olist_orders_dataset.csv': 'ORDERS',
    'olist_order_items_dataset.csv': 'ORDER_ITEMS',
    'olist_order_payments_dataset.csv': 'ORDER_PAYMENTS',
    'olist_order_reviews_dataset.csv': 'ORDER_REVIEWS',
    'olist_products_dataset.csv': 'PRODUCTS',
    'olist_sellers_dataset.csv': 'SELLERS',
    'product_category_name_translation.csv': 'PRODUCT_CATEGORY_TRANSLATION'
}

data_path = './data/raw/'

for filename, table_name in files.items():
    print(f"Loading {filename}...")
    df = pd.read_csv(data_path + filename)
    df.columns = [col.upper() for col in df.columns]
    df = df.rename(columns={
        'PRODUCT_NAME_LENGHT': 'PRODUCT_NAME_LENGTH',
        'PRODUCT_DESCRIPTION_LENGHT': 'PRODUCT_DESCRIPTION_LENGTH'
    })
    success, nchunks, nrows, _ = write_pandas(conn, df, table_name, overwrite=True)
    print(f"  ✓ {nrows} rows loaded into {table_name}")

conn.close()
print("\nAll tables loaded successfully!")