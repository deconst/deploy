import logging

class MyFilter(object):
    def __init__(self, level):
        self.__level = level

    def filter(self, logRecord):
        return logRecord.levelno == self.__level

def log_warnings():
    handler = logging.FileHandler('warnings.log')

    logging.captureWarnings(True)

    logger = logging.getLogger('py.warnings')
    logger.setLevel(logging.WARNING)
    logger.addHandler(handler)

    handler.addFilter(MyFilter(logging.WARNING))

    logger = logging.getLogger('novaclient.api_versions')
    logger.setLevel(logging.WARNING)
    logger.addHandler(handler)
