# Developer overview of DLSS Infrastructure portfolio

Intended Audience: DLSS Infrastructure team developers

## Integration Tests

https://github.com/sul-dlss/infrastructure-integration-test

A collection of RSpec- and Capybara-based integration tests for the [SDR](sdr/). Since it operates at the UI level and exercises a number of basic SDR functions that cross services, it can be a good walkthrough of basic use cases in addition to providing regression tests.

The tests are run locally, by developers, against a deployed environment.

## Team Portfolio

* [Stanford Digital Repository (SDR)](sdr/)-specific documentation
  * [SDR concepts and interactions](sdr/concepts_and_interactions)
* KSR ("Know Systemic Racism")
  * A project to
    * organize, integrate, and present newly collected/accessioned data, existing collection materials, and advocacy resources...
    * with the goals of showing the interconnected subsystems that comprise systemic racism as a whole, connecting researchers and policy advocates, and giving policy advocates the tools and information to effectively fight systemic racism.
    * to start with something tractable, the first iteration is focused on the effects of racism in housing and policing in the bay area.
    * Started with UX interviews with a variety of researchers, policy advocates, and community organizers.  Has continued with document collection (including a joint project with EFF).  Expects to use timeline visualizations, mapping visualizations, and graph/network visualizations.
  * Most knowledgeable team members: Astrid, Peter, John
* sul_pub
  * A system for harvesting and managing of publication records for Stanford academic profiles, with controlled API access.
  * Most knowledgeable team members: Peter, JLitt, John
* Sinopia
  * A set of apps for cataloging linked data (e.g. Bibframe), and for integrating linked data cataloging with the traditional ILS catalog. The most visible application is the Sinopia Editor, which is a React frontend that talks to the Sinopia API, which is backed by MongoDB (in the form of AWS DocumentDB). An Airflow application, ils-middleware, handles integration with the ILS.
  * Supported by the Mellon Foundation-funded LD4* grants, i.e., Linked Data for Libraries (LD4L) and Linked Data for Production (LD4P)
  * Long-term support and maintenance trending in the direction of the DLSS Library Systems team
  * Most knowledgeable team members: JLitt, Jeremy (now of Library Systems, formerly of Infrastructure)
* DLME
  * Digital Library of the Middle East - a grant-funded project that we are commercially supporting for the Qatar National Library
  * Project as a whole involves both Access and Infrastructure teams, with the former team maintaining the DLME web application and the latter the DLME metadata transformation pipeline.
  * Most knowledgeable team members: Aaron

## OpenAPI

We've adopted OpenAPI (FKA "swagger") for specification, validation, and documentation of RESTful HTTP APIs, several of which we maintain for [SDR](sdr/)

## Operations and deployment

### Puppet

The DLSS operations team uses Puppet for configuration management of on-premises virtual machines, to which most of the team's applications are deployed.

### shared_configs

[shared configs](https://github.com/sul-dlss/shared_configs) is a private GitHub repository storing configuration for a given application and environment, each in a separate branch. Integrates with our Capistrano-based deployment. We are planning to migrate secrets out of shared_configs _en masse_ to Vault, a separate service not covered here.

### Capistrano

Most of our applications are developed using Ruby, and the predominant deployment tool in the Ruby community is Capistrano, which is what we use for deployment. Along with one of our sibling teams, the Access team, we maintain a few Capistrano-related gems for, e.g.:

* [capistrano-shared_configs](https://github.com/sul-dlss/capistrano-shared_configs): integration with our shared_configs repository (see above)
* [dlss-capistrano](https://github.com/sul-dlss/dlss-capistrano/#included-tasks): for a number of functions not covered by broader community gems, e.g., managing systemd-managed Sidekiq and resque-pool

Most knowledgeable team member: Mike
