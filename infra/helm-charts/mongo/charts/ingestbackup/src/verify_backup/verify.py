#!/usr/bin/env python3

import logging

from os import environ
from pymongo import MongoClient
from reporting import SlackHandler

backup_dir = f'{environ.get("S3_BUCKET")}/{environ.get("BACKUP_DIR")}'
mongo_host = environ.get('MONGO_HOST', 'mongo')
mongo_port_env = environ.get('MONGO_PORT', '27017')
mongo_port = int(mongo_port_env)

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

slack_handler = SlackHandler()
slack_handler.setLevel(logging.INFO)
logger.addHandler(slack_handler)

try:
    mongo_user = environ.get('MONGO_USER')
    mongo_password = environ.get('MONGO_PASSWORD')
    client = MongoClient(mongo_host, mongo_port, username = mongo_user, password = mongo_password)
    submission_count = client.admin.submissionEnvelope.count_documents({})

    if submission_count < 100:
        logger.error(f'Backup verify at {backup_dir}: Expected at least 100 submissions from the backup but got {submission_count}.')
        exit(1)

    logger.info('Backup verification complete.')
except Exception as exception:
    cause = str(exception)
    error_message = f'Backup verification failed: {cause}.'
    logger.error(error_message)
    exit(1)
