#!/usr/bin/env python

import logging

from os import environ
from pymongo import MongoClient
from reporting import SlackHandler

mongo_host = environ.get('MONGO_HOST', 'mongo')
mongo_port_env = environ.get('MONGO_PORT', '27017')
mongo_port = int(mongo_port_env)

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

slack_handler = SlackHandler()
slack_handler.setLevel(logging.ERROR)
logger.addHandler(slack_handler)

try:
    client = MongoClient(mongo_host, mongo_port)
    submission_count = client.admin.submissionEnvelope.count_documents({})

    if submission_count < 100:
        logger.error('Retrieved less than 100 submissions.')
        exit(1)

    logger.info('Backup verification complete.')
except Exception as exception:
    logger.error(str(exception))
    exit(1)
