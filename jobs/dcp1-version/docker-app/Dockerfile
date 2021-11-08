FROM quay.io/ebi-ait/ingest-base-images:python_3.7-slim

COPY scripts/requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY scripts/dcp1-metadata.txt.tar.gz dcp1-metadata.txt.tar.gz
RUN tar -xzvf dcp1-metadata.txt.tar.gz

COPY scripts/populate_dcp_version.py populate_dcp_version.py

ENV DCP1_GS_FILES_LIST=dcp1-metadata.txt

CMD python ./populate_dcp_version.py