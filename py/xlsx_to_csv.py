import pandas as pd
import json
import requests

class xlsx_to_csv:
    with open('csv_format.json') as json_file:
        csv_format = json.load(json_file)

    @staticmethod
    def ping_internet(url = 'https://www.google.com'):        
        response = requests.get(url)
        print("Get request to '{}' returned status code {}".format(url, response.status_code))
        return response.status_code

    @staticmethod
    def convert(xlsx_file_path, csv_file_path):
        df_xlsx = pd.DataFrame(pd.read_excel(xlsx_file_path, engine='openpyxl'))
        df_csv = df_xlsx[[]].copy(deep=True)

        for column, type in xlsx_to_csv.csv_format.items():
            if column in df_xlsx:
                df_csv[column] = df_xlsx[column].astype(type)
            elif column == 'commas_count':
                df_csv[column] = df_xlsx['commas_used'].fillna('').str.count(',').astype(type)
            else:
                raise Exception('column not found: {}'.format(column))
        
        df_csv.to_csv(csv_file_path, index=False)
        xlsx_to_csv.ping_internet()
        return df_csv

