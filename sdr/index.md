## The Stanford Digital Repository Service Catalog

### Argo
Argo is the management interface for the SDR.  This site is only available to privileged library affiliated users and gives them an administrators UI. Argo is a frontend to the functions provided by the dor-services-app.

(ask Andrew, JCoyne, John)

## SURI
_Stanford University Repository Identifier service - it mints our identifiers_

(ask JCoyne or Naomi or ...)

* we sometimes call our identifiers druids - Digital Repository Unique IDs
* they have a very specific format -- see https://github.com/sul-dlss/druid-tools and/or https://consul.stanford.edu/pages/viewpage.action?title=SURI+2.0+Specification&spaceKey=chimera
* SURI app is a rails app: https://github.com/sul-dlss/suri-rails

### dor-services-app (DSA)
This is the internal API for managing the SDR.  It has a direct connection to the persistence layer and all other systems write/read from the persisted data through DSA.  It has grown to be a sort of kitchen sink nexus for a great deal of cross-application / cross-service needs.

(ask any infrastructure dev)

* dor-services-client - _Ruby gem for making REST calls to dor-services-app_

### dor-indexing-app
Creates a solr representation of the objects and writes it to Solr. This solr index is used for Argo and for dor-services-app since the Fedora 3 repository has no query capabilities.

(ask JCoyne or Mike)

### Workflow Server
_a Rails App to track the workflows associated with an object, and the state of each step and an error string for failed steps_

(ask JCoyne)

* workflow-server-rails - _the Rails app_
* dor-workflow-client - _Ruby gem for making calls to workflow app_

### SDR-API

This is an external facing API. It is not totally complete as it doesn't produce derivatives for book/image types and it doesn't yet have fined grained authorization.  Currently all of the h2 and GoogleBooks deposits flow through this API.  This in turn communicates with dor-services-app on the back end

(ask JCoyne)

* sdr-client - _Ruby gem for making calls to sdr-api app_

### ETD
Students can deposit thesis and dissertations into the repository

### h2
Stanford affiliated users can self deposit. The previous iteration of this software was called "Hydrus", the newest version is "h2" (nicknamed Happy Heron).

(ask Mike or JCoyne)

infrastructure-integration-test's `create_object_h2_spec.rb` can provide a walkthrough for how to do a self-deposit

### Google Books

Automatically downloads books we have sent off to google for scanning.  This provides a minimal UI for monitoring and is only used by the infrastructure team and Andrew.  Google books are deposited as a single ZIP file with all the images.  They are kept dark, as many of them are not out of copyright. The downloading job uses the SDR-API to deposit the files.

### Pre-assembly

Accessioners go here to create the content metadata for the files they want to accession. https://sul-preassembly-prod.stanford.edu/

### preservation

#### preservation_catalog

* Catalogs all on prem and cloud copies of all preservation objects, including the status determined by the most recent audit of the object
* Runs audits (a variety of presence and integrity checks) regularly on all on prem and cloud archive copies of preservation objects
* has _read-only_ access to the preservation storage mounts, as none of its functionality requires manipulation of preservation storage (the only things pres cat writes to are its Postgres database cataloging the state of all of our preserved objects, the Redis instance backing its queues, and the temp space on the file system used for creating archival zips to send to S3).

(ask John)


#### preservation_robots

see robots section below

### Robot Suites

Different specialized robot codebases perform the individual steps of accessioning, preservation, making available for access, etc.  More about how they hand off to each other and interact with other services [here](concepts_and_interactions#Workflows-and-Robots)

#### robot-console
_Tiny app providing the resque console to view the state of our robot redis queues, activity and errors_
  * e.g. https://robot-console-prod.stanford.edu/overview
  * https://github.com/sul-dlss/robot-console/

#### common-accessioning
_Suite of robots that handle the tasks of accessioning digital objects_

(ask Peter)

Workflows implemented include `assemblyWF`, `accessionWF`, `goobiWF`, `disseminationWF`, `releaseWF`

* https://github.com/sul-dlss/common-accessioning/

#### preservation_robots
_robots to preserve objects being accessioned via `preservationIngestWF` (formerly known as `sdrIngestWF`)_

(ask Naomi, then John)

* https://github.com/sul-dlss/preservation_robots/
* These robots run on a VM with access to the filesystems used by preservation. This is the main reason they are separated from common-accessioning.
  * The robots have write access to the preservation storage mounts, and are responsible for updating the preservation objects each time an SDR object is versioned.  preservation_catalog has _read-only_ access to the preservation storage mounts.

#### gis-robots
_robots to carry out special processing required for GIS objects via `gisAssemblyWF` and `gisDeliveryWF`_

(ask anyone as we are all equally ignorant, more or less; GIS folks may have guidance too, e.g. Kim or Stace)

* https://github.com/sul-dlss/gis-robot-suite/
* `gisDiscoveryWF` has been retired (?)

#### was_robot_suite
_robots to carry out special processing required for WAS seed and crawl objects via `was_seed_preassemblyWF`,`was_crawl_preassemblyWF`, `as_dissemination` and `was_crawl_disseminationWF`_

(ask Naomi or JLitt)

* https://github.com/sul-dlss/was_robot_suite

### WAS

(ask JLitt)

### GIS


## Access Team Projects that Infra Team Projects interact with

## PURL
_SDR's persistent url - a URL and a landing page_

(any infrastructure dev)

* connected to the "releaseWF" workflow

## Digital Stacks
_What we call the location/app where we provide SDR content to end users_

(John or JCoyne or ...)

* this can be the same as the preserved content, or different.  For example, large image files like TIFFs are turned into small formats appropriate for the viewer in SearchWorks and elsewhere.

### Wowza

(ask John or Naomi or Chris)

Wowza is proprietary media streaming software that we use to stream video via PURL, from Stacks.  Wowza allows access control via a Java plugin, which was originally written in 2016 as a collaboration between Access and Infra teams.  Infra team owned the plugin for a while, but now Access owns it (?).  See https://github.com/sul-dlss/dlss-wowza
