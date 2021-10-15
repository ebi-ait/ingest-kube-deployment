import logging
import requests

from os import environ
from logging import Formatter, Handler, LogRecord

SLACK_WEBHOOK = environ.get('SLACK_WEBHOOK', 'unspecified')

fallback_logger = logging.getLogger(__name__)


class SlackMessageFormatter(Formatter):

    def format(self, log_record: LogRecord):
        return log_record.msg


class SlackHandler(Handler):
    
    def __init__(self, formatter=SlackMessageFormatter()):
        super(SlackHandler, self).__init__()
        if formatter:
            self.setFormatter(formatter)

    def emit(self, log_record: LogRecord):
        try:
            log_entry = self.format(log_record)
            r = requests.post(SLACK_WEBHOOK, json={'text': log_entry})
            r.raise_for_status()
        except Exception as exception:
            fallback_logger.error(str(exception))


