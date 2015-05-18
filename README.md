# deploy

This is an Ansible playbook that deploys Deconst onto a cluster. You'll need at least Ansible 1.9.0.1.

## Running

To deploy or update a cluster:

 1. Copy the example credentials file and fill in your credentials.

    ```bash
    cp credentials.example.yml credentials.yml
    ${EDITOR} credentials.yml
    ```

 2. Run the playbook with the script.

    ```bash
    script/deploy
    ```
