# deploy

This is an Ansible playbook that deploys Deconst onto a cluster.

## Running

To deploy or update a cluster:

 1. Copy the example credentials file and fill in your credentials.

    ```bash
    cp credentials.example.yml
    ${EDITOR} credentials.example.yml
    ```

 2. Run the playbook with the script.

    ```bash
    script/deploy
    ```
