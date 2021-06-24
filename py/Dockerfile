FROM python:3

WORKDIR /usr/src/app

COPY xlsx_to_csv.py ./
COPY test.py ./
COPY csv_format.json ./
COPY test_in.xlsx ./
COPY requirements.txt ./

RUN pip install -r requirements.txt

CMD [ "python", "./test.py" ]