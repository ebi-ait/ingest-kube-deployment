FROM quay.io/ebi-ait/ingest-base-images:python_3.7-slim

COPY ./scripts/populate.py populate.py
COPY ./scripts/requirements.txt requirements.txt

RUN pip install -r requirements.txt
CMD python ./populate.py