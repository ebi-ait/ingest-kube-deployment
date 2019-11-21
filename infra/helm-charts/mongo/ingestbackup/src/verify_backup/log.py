#!/usr/bin/env python3
from argparse import ArgumentParser
import logging
from collections import namedtuple

from reporting import SlackHandler

UNKNOWN_LOGGING_LEVEL = -1

logging.basicConfig()
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)

slack_handler = SlackHandler()
slack_handler.setLevel(logging.ERROR)
logger.addHandler(slack_handler)

LoggingLevel = namedtuple('LoggingLevel', ['level', 'name'])


def logging_level(name: str):
    try:
        level = getattr(logging, name.upper())
    except AttributeError:
        level = UNKNOWN_LOGGING_LEVEL
    return LoggingLevel(level=level, name=name)


if __name__ == '__main__':
    parser = ArgumentParser(description='logging utility')
    parser.add_argument('message', type=str, help='the message to log')
    parser.add_argument('-l', dest='logging_level', default='info', type=logging_level, help='logging level')

    args = parser.parse_args()
    logging_level = args.logging_level.level
    if logging_level != UNKNOWN_LOGGING_LEVEL:
        logger.log(logging_level, args.message)
    else:
        print(f'Unknown logging level [{args.logging_level.name}]')
        exit(1)
