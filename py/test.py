import pandas as pd
from xlsx_to_csv import xlsx_to_csv

# Transform XLSX into CSV file
xlsx_file = 'test_in.xlsx'
csv_file = 'test_out.csv'
xlsx_to_csv.convert(xlsx_file, csv_file)

# Load CSV file and display
print('Loading and displaying file "{}":'.format(csv_file))
df = pd.read_csv(csv_file)
print(df)