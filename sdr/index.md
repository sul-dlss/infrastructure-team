# Stanford Digital Repository (SDR) Services

For a graphical depiction of the interconnected services comprising SDR, check out the [SDR Service Topology diagram](https://docs.google.com/drawings/d/1F2pmkcAQwYHktS99CD6W5Wn2irXGIWSw-bBWkoin4mA/edit?pli=1).

## Argo

Argo is the management interface for the SDR.  This site is only available to privileged library-affiliated users and gives them an administrator-oriented UI. Argo is a frontend to the functions provided by the rest of SDR, including dor-services-app, preservation-catalog, and SDR-API.

NOTE: Most of the tests in infrastructure-integration-tests exercise different functions provided by Argo.

Most knowledgeable team members: Andrew (SDR Repository Manager, not on our team), JCoyne, John

## suri

The SURI (Stanford Uniform Resource Identifier) service, AKA suri-rails, mints identifiers for SDR objects, persisting them to its own PostgreSQL database. It is a Rails-based, API-only web application.

Most knowledgeable team members: JCoyne, Naomi

* We sometimes call our identifiers druids - Digital Repository Unique IDs
* They have a very specific format -- see https://github.com/sul-dlss/druid-tools, https://consul.stanford.edu/pages/viewpage.action?title=SURI+2.0+Specification&spaceKey=chimera, and https://github.com/sul-dlss/cocina-models/blob/d075d583765116860ffe369ee464634abebb40b4/openapi.yml#L973-L976
* SURI (AKA "suri-rails") is a Rails-based, API-only web application: https://github.com/sul-dlss/suri-rails

## dor-services-app

dor-services-app (DSA) is a Rails-based, API-only web application acting as the internal API for managing the SDR. It has a direct connection to the persistence layer and all other systems write to/read from the persisted data through DSA. It has grown to be a sort of kitchen sink nexus for a great deal of cross-application / cross-service needs.

Other applications connect to DSA via a Ruby gem we maintain called `dor-services-client`, which handles the HTTP connections.

Most knowledgeable team members: any of us

## dor-indexing-app

dor-indexing-app (DIA) is a Rails-based, API-only web application whose sole job is to create Solr representations of SDR objects. The Solr index DIA writes to is used primarily by Argo and dor-services-app since the Fedora 3 repository underlying DSA has minimal query capabilities.

Most knowledgeable team members: JCoyne, Mike

## Workflow Server

The workflow server (AKA workflow-server-rails) is a Rails-based, API-only web application that tracks workflows associated with repository objects, including the state of each step and error strings for failed steps. The data is persisted in a PostgreSQL database.

Other applications connect to the workflow server via a Ruby gem we maintain called `dor-workflow-client`, which handles the HTTP connections.

Most knowledgeable team members: JCoyne

## SDR-API

This is an external facing API. It is not totally complete as it doesn't produce derivatives for book/image types and it doesn't yet have fined grained authorization.  Currently all of the h2 and GoogleBooks deposits flow through this API.  This in turn communicates with dor-services-app on the back end

Other applications connect to SDR-API via a Ruby gem we maintain called `sdr-client`, which handles the HTTP connections.

NOTE: the infrastructure-integration-test's `sdr_deposit_spec.rb` can provide a walkthrough for how to deposit via the application.

Most knowledgeable team members: JCoyne

## ETD

The ETD application (AKA hydra_etd) is a Rails-based web application with both a user interface where students can deposit theses and dissertations into the repository and an API for interconnection with the University's PeopleSoft instance.

NOTE: the infrastructure-integration-test's `create_etd_spec.rb` can provide a walkthrough for how to use the application.

Most knowledgeable team members: Naomi, Mike

## H2

H2 is a Rails-based web application where Stanford-affiliated users can self deposit their research into SDR. H2 is a ground-up rewrite of our previous self-deposit application, Hydrus, hence "H2" (nicknamed happy_heron).

NOTE: the infrastructure-integration-test's `create_object_h2_spec.rb` can provide a walkthrough for how to do a self-deposit.

Most knowledgeable team members: JCoyne, Mike

## Google Books

The Google Books app (AKA GBooks) is a Rails-based UI application kicking off accessioning of Google Book content owned by Stanford into SDR, allowing automatic downloads of books we have sent off to Google for scanning. The app provides a minimal UI for monitoring and is only used by the Infrastructure team and Andrew (the Repository Manager). The books are deposited as a single ZIP file with all the images included. They are marked as dark (private) in the repository, as many of them are in copyright. GBooks consumes the SDR-API to deposit into SDR, and was the initial test-case for developing SDR-API.

Most knowledgeable team members: J-Litt, JCoyne, Aaron

## Pre-assembly

DLSS staff that accession content into SDR ("Accessioneers") use pre-assembly, a Rails-based UI application, to create the content metadata for files they want to accession.

NOTE: the infrastructure-integration-test's `create_preassembly_image_spec.rb` can provide a walkthrough for how to use the application.

## preservation_catalog

preservation_catalog (AKA prescat) is a Rails-based, API-only web application that is responsible for:

* Cataloging all on-premises and cloud-based copies of all preserved repository objects, including the status determined by the most recent audit of the object
* Running audits (a variety of presence and integrity checks) regularly on all copies of preserved repository objects

NOTE: Prescat has _read-only_ access to the preservation storage mounts, as none of its functionality requires manipulation of preservation storage (the only things prescat writes to are its PostgreSQL database cataloging the state of all of our preserved objects, the Redis instance backing its queues, and the tmp space on its filesystem used for creating archival zips to send to cloud storage endpoints).

Most knowledgeable team members: John

## Robot Suites

Different specialized robot codebases perform the individual steps of accessioning, preservation, making available for access, etc.  More about how they hand off to each other and interact with other services [here](concepts_and_interactions#Workflows-and-Robots). A robot in this context is a "small" computational step that has no knowledge other than what is needed for it to do its job.

### robot-console

robot-console is a tiny Rails app providing the user interface to Resque, the framework running robot jobs in the background.
This allows us to view the state of our robot queues, workers, and errors:

### common-accessioning

Suite of robots that handle the tasks of accessioning digital objects

Most knowledgeable team members: Peter, JCoyne

### preservation_robots

preservation_robots (presbots) execute functions to preserve objects being accessioned via `preservationIngestWF` (formerly known as `sdrIngestWF`).

* The robots have write access to the preservation storage mounts, and are responsible for updating the preservation objects each time an SDR object is versioned. preservation_catalog has _read-only_ access to the preservation storage mounts.
  * This is the main reason they are separated from common-accessioning.

Most knowledgeable team members: Naomi, John

### gis-robot-suite

The GIS robots carry out special processing required for GIS objects via `gisAssemblyWF` and `gisDeliveryWF`

Most knowledgeable team members: anyone... as we are all equally ignorant, more or less; GIS folks may have guidance too, e.g. Kim or Stace

### was_robot_suite

The was_robot_suite carries out special processing required for WAS seed and crawl objects via `was_seed_preassemblyWF`,`was_crawl_preassemblyWF`, `as_dissemination` and `was_crawl_disseminationWF`_

Most knowledgeable team members: Naomi, JLitt

## was-registrar-app

was-registrar-app (WRA) is a Rails-based app that is the primary place for staff to interaction with web archiving functionality.

Most knowledgeable team members: JLitt

# Access Team Services

These are in the Access portfolio but our services interact with them heavily.

## PURL

_SDR's persistent url - a URL and a landing page_

* connected to the "releaseWF" workflow

Most knowledgeable team members: any infrastructure dev

## Digital Stacks

_What we call the location/app where we provide SDR content to end users_

* this can be the same as the preserved content, or different.  For example, large image files like TIFFs are turned into small formats appropriate for the viewer in SearchWorks and elsewhere.

Most knowledgeable team members: John, JCoyne

### Wowza

Wowza is proprietary media streaming software that we use to stream video via PURL, from Stacks. Wowza allows access control via a Java plugin, which was originally written in 2016 as a collaboration between Access and Infra teams. The Infrastructure team owned the plugin for a while, but now Access owns it (maybe?). See https://github.com/sul-dlss/dlss-wowza

Most knowledgeable team members: John, Naomi, Chris
