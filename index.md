# Developer overview of infrastructure team portfolio

Intended Audience: infrastructure team developers

## infrastructure-integration-test

https://github.com/sul-dlss/infrastructure-integration-test

A collection of Capybara integration tests for the SDR.  Since it operates at the UI level and exercises a number of basic SDR functions that cross services, it can be a good walk through of some basic use cases in addition to providing regression tests.


## Infrastructure service areas

* [Stanford Digital Repository Software Services (SDR)](sdr/index)
  * [SDR concepts and service interactions](sdr/concepts_and_interactions)
* KSR "Know Systemic Racism"
  * A project to
    * organize, integrate, and present newly collected/accessioned data, existing collection materials, and advocacy resources...
    * with the goals of showing the interconnected subsystems that comprise systemic racism as a whole, connecting researchers and policy advocates, and giving policy advocates the tools and information to effectively fight systemic racism.
    * to start with something tractable, the first iteration is focused on the effects of racism in housing and policing in the bay area.
    * Started with UX interviews with a variety of researchers, policy advocates, and community organizers.  Has continued with document collection (including a joint project with EFF).  Expects to use timeline visualizations, mapping visualizations, and graph/network visualizations.
  * ask Astrid, Peter, John
* sul_pub
  * A system for harvest and managing of publication records for Stanford academic profiles, with controlled API access.
  * ask Peter (then JLitt then John)
* Sinopia
  * A set of apps for cataloging and using linked data (e.g. Bibframe), and for integrating linked data cataloging with the traditional ILS catalog.  The most visible application is the Sinopia Editor, which is a React front end for the Sinopia API, which is backed by a MongoDB instance (well, AWS DocumentDB).  An Airflow application, ils-middleware, handles integration with the ILS.
  * part of the LD4P grants
  * heading for Library Systems team
  * ask JLitt
* DLME
  * Digital Library for the Middle East - a grant funded project to eventually be turned over to a Qatar library
  * Project as a whole involves both Access and Infra teams
  * ask Aaron

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
