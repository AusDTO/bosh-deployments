# Prometheus Monitoring - BOSH deployment details

Prometheus is an Open source monitoring tool.  A BOSH release was created for it [prometheus-boshrelease](https://github.com/cloudfoundry-community/prometheus-boshrelease).

The BOSH release deploys the following monitoring tools - [Prometheus](<https://prometheus.io/>), [AlertManager](https://github.com/prometheus/alertmanager) and  [Grafana](<https://grafana.com/>).


## Usage

### Setting up local BOSH environment
The instructions for deploying a local BOSH2 director are [here](../setup-local-bosh.md)

### Basic deployment
The [prometheus boshrelease](https://github.com/cloudfoundry-community/prometheus-boshrelease) provides great documentation as well as the core BOSH deployment manifest and standard operator files.  
This *DTA* repository provides some custom operator files and a concourse pipelines for deploying it to our environments.

#### [deployment-name](operators/deployment-name.yml)
The default deployment name `prometheus` is specified in the main deployment manifest.  This operator file allows you change the name - useful if you deploy more than 1 prometheus service.

#### [dta-platform](operators/dta-platform.yml)
This operator file performs the main customisations for deploying prometheus to cloud.gov.au environments.

#### [dta-platform-dev](operators/dta-platform-dev.yml)
like above, but without public VMs with EIPs.  Good for dev/testing BOSH releases
