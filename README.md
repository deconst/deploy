# Deploy Deconst

These instructions deploy Deconst onto a Docker Swarm cluster.

Clone this repository once for each deconst instance you wish to administer. The contents of `credentials.yml` customize and identify each deployment.

## Prerequisites

TODO

## Running

To deploy or update a cluster:

1. Copy the example credentials file and fill in your credentials and customizations. Alternately, use a credentials file corresponding to an existing deployment you'd like to maintain.

    ```bash
    cp credentials.example.yml credentials.yml
    ${EDITOR} credentials.yml

    # Or:
    script/decrypt ~/cred-repo/credentials-staging.yml.enc
    ```

1. Run the `deploy` script.

    ```bash
    script/deploy
    ```

### Parameters

Deconst guards against inconsistent `credentials.yml` files being run by multiple maintainers. If you intentionally make changes to the credentials file, you'll need to provide extra variables to `script/deploy`.

If you change the `deployment`, run with:

```bash
script/deploy -e 'new_deployment=true'
```

If you make any other local changes to a `credentials.yml` file, run with:

```bash
script/deploy -e 'credentials_update=true'
```

To only update the control repository's content map, layout map or templates:

```bash
script/deploy --tags control
```

To force a restart of selected services:

```bash
# Restart only presenters
script/deploy --tags restart -e 'presenter_restart=true'

# Other restart control variables:
# -e 'service_pod_restart=true'         Service pods (content services and presenter)
# -e 'logstash_forwarder_restart=true'  Logstash-forwarder
# -e 'logstash_restart=true'            Logstash
```

To force the generation of new TLS certificates:

```bash
script/deploy --extra-vars="gencerts=yes"
```

## Utilities

This repository contains a number of utilities to assist in basic ops work. Each script keys off of the credentials in `credentials.yml`, so it will use the correct Rackspace account and hosts.

* `script/status` performs a `docker status` on each host. It's useful for quickly seeing if all expected services are up and running.
* `script/logs <component>` tails the Docker container logs of each matching service across the cluster. The number of lines given can be controlled by setting `LOG_LINES`. For example: `LOG_LINES=50 script/logs presenter`.
* `script/genkey <name>` reads the admin API key from your credentials file and issues a new API key with the provided name.
* `script/ips` lists the IP addresses of each host in the cluster.
* `script/lb` audits and corrects load-balancer node membership on the cluster. Consult `--help` for details.
* `script/reindex` asynchronously triggers a full content reindex in Elasticsearch.
