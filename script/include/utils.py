import logging
import os

# Get our bearings on the filesystem.
root = os.path.realpath(os.path.join(os.path.dirname(__file__), "..", ".."))

# Log certificate warnings to 'warnings.log'.

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

# Credentials

_credentials = None

def credential(key):
    """
    Lazily load and parse the credentials file.
    """

    if _credentials is None:
        with open(os.path.join(root, "credentials.yml")) as credfile:
            _credentials = yaml.load(credfile)
    return _credentials.get(key)

def content_store_url(quiet=False):
    """
    Access the public content store URL.

    Respect the environment variable CONTENT_STORE_URL if it is populated.
    Otherwise, find the content store load balancer and derive its public IP
    via the Rackspace API.

    Prints the derived URL to stdout as a side-effect unless "quiet" is set to
    True.
    """

    content_store_url = os.environ.get("CONTENT_STORE_URL")
    if content_store_url:
        if content_store_url.endswith("/"):
            content_store_url = content_store_url[:-1]

        if not quiet:
            print("Using content store URL: {}".format(content_store_url))
    else:
        rackspace_username = creds["rackspace_username"]
        rackspace_apikey = creds["rackspace_api_key"]
        rackspace_region = creds["rackspace_region"]

        instance_name = creds["instance"]

        pyrax.set_setting("identity_type", "rackspace")
        pyrax.set_setting("region", rackspace_region)
        pyrax.set_credentials(rackspace_username, rackspace_apikey)
        clb = pyrax.cloud_loadbalancers

        the_lb = None
        content_lb_name = "deconst-{}-content".format(instance_name)
        for lb in clb.list():
            if lb.name == content_lb_name:
                the_lb = lb

        if not the_lb:
            raise Exception("Content service load balancer not found")

        addr = the_lb.virtual_ips[0].address
        port = the_lb.port
        proto = "http"

        ssl_termination = the_lb.get_ssl_termination()
        if ssl_termination:
            proto = "https"
            port = ssl_termination["securePort"]

        content_store_url = "{}://{}:{}".format(proto, addr, port)

        if not quiet:
            print("Derived content store URL: {}".format(content_store_url))
            print("If this is incorrect, set CONTENT_STORE_URL to the correct value.")
