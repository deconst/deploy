# Deconst Playbook

This is a bunch of scripts using `docker` and `docker-compose` that deploys Deconst onto a Docker Swarm cluster on [Carina](https://getcarina.com/).

Clone this repository once for each deconst instance you wish to administer. Copy `env.example` to `env` to customize and identify each deployment.

## Prerequisites

* Docker
* Docker Compose

## Running

Work with a cluster:

 1. Copy the example env file and fill in your credentials and customizations. Alternately, use an env file corresponding to an existing deployment you'd like to maintain.

    ```bash
    cp env.example env
    ${EDITOR} env
    ```

 2. Work with the deconst docs using scripts in the `script` directory.

    ```bash
    script/deploy
    script/deconst-docs-assets
    open http://$(docker port deconst_presenter_lb 80)

    script/scale 3
    docker exec deconst_presenter_lb cat /etc/nginx/nginx.conf
    docker exec deconst_content_lb cat /etc/nginx/nginx.conf

    script/destroy
    ```
