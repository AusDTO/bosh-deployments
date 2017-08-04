# Concourse CI - BOSH deployment details

BOSH release for Concourse (<https://concourse.ci/>) - CI tool.

## Usage

### Setting up local BOSH environment
The instructions for deploying a local BOSH2 director are [here](../setup-local-bosh.md)

### Basic deployment
the provided `concourse.yml` should just work, albeit for a simple deployment.

```bash
export BOSH_ENVIRONMENT=<bosh-target>
bosh deploy -n -d concourse concourse.yml
```

Run `bosh vms` to gather IP address for web node, then point your browser at it.

```bash
$ bosh vms
Using environment '192.168.50.6' as client 'admin'

Task 6. Done

Deployment 'concourse'

Instance                                     Process State  AZ  IPs         VM CID                                VM Type
db/26729543-60d8-45b1-85fe-82f10383a4f0      running        z1  10.244.0.3  bcb8b001-3de3-4f47-5999-fc2cd966c0e4  default
web/dba148aa-104c-4d2d-ae28-6f4d0f1856a8     running        z1  10.244.0.2  d3376055-c42f-45d2-47c5-f0ccff21c450  default
worker/1a05479f-d211-4ed3-96b4-1535c08dbdf5  running        z1  10.244.0.4  2acc2753-451b-4120-47c4-2320acdbfa03  default

3 vms

Succeeded
```

From above, you would point your browser to <http://10.244.0.2:8080> and see the concourse UI


### Operator files
Bosh2 allows you to customise a default deployment manifests through operator files and optionally variables that you pass in to the deployment.  Below are examples

#### use Github for authentication
The [github-auth.yml](operators/github-auth.yml) file provides the ability to make your concourse deployment use github for auth.  Below is an example:

```bash
bosh deploy -n -d concourse concourse.yml \
-o operators/github-auth.yml \
-v github-auth-client-id=xxx \
-v github-auth-client-secret=yyy \
-v github-auth-org=AusDTO \
-v github-auth-org-teams="cloud.gov.au, Security"
```

[Credhub](https://github.com/cloudfoundry-incubator/credhub) allows you to store credentials securely and not require you to specify them at deployment time (cli, or CI tool).

Set the values using the [credhub-cli](https://github.com/cloudfoundry-incubator/credhub-cli) and run the BOSH deployment without needing to specify the values
```bash
credhub set -n "/local/concourse/github-auth-client-id" -v xxx
credhub set -n "/local/concourse/github-auth-client-secret" -v yyy

bosh deploy -n -d concourse concourse.yml \
-o operators/github-auth.yml \
-v github-auth-org=AusDTO \
-v github-auth-org-teams="cloud.gov.au, Security"
```

#### network location
The default deployment manifest deploys to a subnet called `default`.  This is unlikely to be where you want this to run real deployments.  The [networking.yml](operators/networking.yml) file provides the ability to adjust the subnet details for the deployment.  Below is an example:

```bash
bosh deploy -n -d concourse concourse.yml \
-o operators/networking.yml \
-v network-name=ci
```

#### set a static ip

The default deployment manifest will automatically allocate an ip for the concourse web interface. The [static-ip.yml](operators/static-ip.yml) file provides the ability to specify a static ip for the web interface. Below is an example:

```bash
bosh deploy -n -d concourse concourse.yml \
-o operators/static-ip.yml \
-v static-ip=10.0.1.10
```

#### external URL for concourse
The default deployment manifest configures concourse to have an external_url of `localhost`.  The [url.yml](operators/url.yml) file provides the ability adjust the external URL that users will browse to for this service.  Below is an example:

```bash
bosh deploy -n -d concourse concourse.yml \
-o operators/url.yml \
-v external-url=https://ci.cloud.gov.au
```

#### modify vm-types (instance sizes)
The default deployment uses vm-types of `default`.  The [vm-types.yml](operators/vm-types.yml) file provides the ability to size your concourse instances to meet your needs.  Below is an example:

```bash
bosh deploy -n -d concourse concourse.yml \
-o operators/vm-types.yml \
-v vm-type-web=t2.medium \
-v vm-type-db=t2.medium \
-v vm-type-worker=m4.large \
```

#### adjust number of worker nodes
The default deployment includes 1 CI worker node.  The [worker-numbers.yml](operators/worker-numbers.yml) file provides the ability adjust the number of CI worker nodes.  Below is an example:

```bash
bosh deploy -n -d concourse concourse.yml \
-o operators/worker-numbers.yml \
-v workers=4
```

#### add HTTPS
The default deployment exposes the web interface on HTTP.  The [instant-https.yml](operators/instant-https.yml) file adds integration with the [instant-https BOSH release](https://github.com/govau/instant-https-boshrelease).  Below is an example:

```bash
bosh deploy -n -d concourse concourse.yml \
-o operators/instant-https.yml \
-v external-hostname=ci.cloud.gov.au \
-v cert-contact-email=webmaster@example.com \
-v acme-api-url=https://acme-staging.api.letsencrypt.org/directory  # Use https://acme-v01.api.letsencrypt.org/directory in production after testing
```
