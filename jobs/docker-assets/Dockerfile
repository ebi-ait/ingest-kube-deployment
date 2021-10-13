FROM quay.io/ebi-ait/ingest-base-images:python_3.7-slim

COPY ./scripts/populate.py populate.py
COPY ./scripts/requirements.txt requirements.txt

ENV BASE_API_URL=https://api.ingest.dev.archive.data.humancellatlas.org

RUN pip install -r requirements.txt
CMD python ./populate.py -u $BASE_API_URL