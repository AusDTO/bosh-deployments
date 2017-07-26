### Setting up local environment

1. Assumes BOSH2 cli is installed with binary named `bosh`.

1. Deploy a local BOSH2 environment with VBOX: <https://github.com/cloudfoundry/bosh-deployment>. the `uaa.yml` and `credhub.yml` operator files will add UAA and credhub to the BOSH director.

    ```bash
    bosh create-env ./bosh.yml \
    --state ./state.json \
    --vars-store ./creds.yml \
    -o ./virtualbox/cpi.yml \
    -o ./virtualbox/outbound-network.yml \
    -o ./bosh-lite.yml \
    -o ./bosh-lite-runc.yml \
    -o ./jumpbox-user.yml \
    -o ./uaa.yml \
    -o ./credhub.yml \
    -v director_name="local" \
    -v internal_ip=192.168.50.6 \
    -v internal_gw=192.168.50.1 \
    -v internal_cidr=192.168.50.0/24 \
    -v outbound_network_name=NatNetwork
    ```

1. Set access to new BOSH2 director.

    ```bash
    export BOSH_CLIENT=admin
    export BOSH_ENVIRONMENT=vbox
    export BOSH_CLIENT_SECRET=`bosh int ./creds.yml --path /admin_password`
    bosh -e 192.168.50.6  --ca-cert <(bosh int ./creds.yml --path /director_ssl/ca) alias-env vbox
    ```

1. Set access to credhub (credentials store for BOSH)

    ```bash
    export CREDHUB_CLI_USERNAME=credhub-cli
    export CREDHUB_CLI_PASSWORD=`bosh int ./creds.yml --path /credhub_cli_password`
    credhub login -s https://192.168.50.6:8844 -u $CREDHUB_CLI_USERNAME -p $CREDHUB_CLI_PASSWORD --skip-tls-validation
    ```

1. apply the provided BOSH cloud-config: <https://github.com/cloudfoundry/bosh-deployment/blob/master/warden/cloud-config.yml>

    ```bash
    bosh update-cloud-config ./warden/cloud-config.yml
    ```

1. fetch a stemcell from bosh.io

    ```bash
    bosh upload-stemcell https://bosh.io/d/stemcells/bosh-warden-boshlite-ubuntu-trusty-go_agent
    ```

1. updating routing table to reach BOSH deployed services
    ```bash
    sudo route add -net 10.244.0.0/16    192.168.50.6
    ```
