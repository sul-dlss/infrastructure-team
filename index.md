Intended Audience: infrastructure team developers

## infrastructure-integration-test

https://github.com/sul-dlss/infrastructure-integration-test)

A collection of Capybara integration tests for the SDR.  Since it operates at the UI level and exercises a number of basic SDR functions that cross services, it can be a good walk through of some basic use cases in addition to providing regression tests.


## Infrastructure service areas

* [Stanford Digital Repository Software Services (SDR)](sdr/index)
  * [SDR concepts and service interactions](sdr/concepts_and_interactions)
* KSR
* sul_pub
* Sinopia
* DLME

## OpenAPI

We've adopted OpenAPI for specification, validation, and documentation of REST calls for many of our apps that have a REST API.

## Operations and deployment

### Puppet
_SUL DLSS uses Puppet for its lower level IT infrastructure, such as loading software onto VMs for our apps_

### dlss-capistrano
_Ruby gem to facilitate deployment of apps to SUL VMs_

(ask Mike)

### shared_configs
_Where we keep per environment configuration.  Working on migrating secrets (e.g. creds for inter-service auth) to Vault._
