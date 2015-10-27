import logging

def log_warnings():
    handler = logging.FileHandler('warnings.log')

    logging.captureWarnings(True)

    logger = logging.getLogger('py.warnings')
    logger.setLevel(logging.WARNING)
    logger.addHandler(handler)

    logger = logging.getLogger('novaclient.api_versions')
    logger.setLevel(logging.WARNING)
    logger.addHandler(handler)
