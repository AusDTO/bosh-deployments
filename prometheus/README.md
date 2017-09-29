# Prometheus Monitoring - BOSH deployment details

Prometheus is an Open source monitoring tool.  A BOSH release was created for it [prometheus-boshrelease](https://github.com/cloudfoundry-community/prometheus-boshrelease).

The BOSH release deploys the following monitoring tools - [Prometheus](<https://prometheus.io/>), [AlertManager](https://github.com/prometheus/alertmanager) and  [Grafana](<https://grafana.com/>).


## Usage

### Setting up local BOSH environment
The instructions for deploying a local BOSH2 director are [here](../setup-local-bosh.md)

### Basic deployment
The [prometheus boshrelease](https://github.com/cloudfoundry-community/prometheus-boshrelease) provides great documentation as well as the core BOSH deployment manifest and standard operator files.  
This *DTA* repository provides some custom operator files and a concourse pipelines for deploying it to our environments.

#### [aws-environment](operators/aws-environment.yml)
This operator file performs the main customisations for deploying prometheus to cloud.gov.au environments.

#### [deployment-name](operators/deployment-name.yml)
The default deployment name `prometheus` is specified in the main deployment manifest.  This operator file allows you change the name - useful if you deploy more than 1 prometheus service.

#### [networking](operators/networking.yml)
Update the network name from `default` to `Support`

#### [storage](operators/storage.yml)
Set the desired volume size for persistant volumes

#### [vm-extensions](operators/vm-extensions.yml)
Add the `monitoring` vm-extensions to all instances.  This ensures that security groups are setup correctly.

#### [vm-types](operators/vm-types.yml)
Set the desired vm-types (AWS instance_types) for prometheus instances.
