# Yet Another SDR Handbook

_A combination index, glossary, and high level guided tour for the Stanford Digital Repository_

Intended Audience: infrastructure team developers

## Argo
_The administrative discovery interface for Stanford's Digital Object Registry_

(ask Andrew, John, JCoyne)

  * Specially chosen staff users (many of them accessioneers)

## infrastructure-integration-test
_A collection of Capybara integration tests for the SDR_

(ask any infrastructure dev)

  * https://github.com/sul-dlss/infrastructure-integration-test

## types of Digital Objects
_We started with more, but we're kinda down to three_

(ask Andrew)

  * APO - _administrative (or admin) policy object_
  * Collection - _a collection of items, belonging to an APO_
  * Item - _an item can have files; it belongs to a (one or more?) collection_

## cocina-models
_SDR data model written as syntactically validatable with dry-struct, dry-types and openapi_

(ask JCoyne or JLitt)

## dor-services-app
_In an effort to isolate our code that directly depends on Fedora3, the DSA was created.  It has grown to be a sort of kitchen sink nexus of a great deal of cross-application / cross-service needs, exposed as API calls._

(ask any infrastructure dev)

  * dor-services-client - _Ruby gem for making calls to dor-services-app_

## sdr-api
_A pure API to interact with the SDR._

(ask JCoyne)

  * sdr-client - _Ruby gem for making calls to sdr-api app_

## Workflows

### Workflow Server
_a Rails App to track the workflows associated with an object, and the state of each step and an error string for failed steps_

(ask JCoyne)

  * workflow-server-rails - _the Rails app_
  * dor-workflow-client - _Ruby gem for making calls to workflow app_

## Robots
_what we call our individual accessioning processing steps which are grouped into "workflows" and were engineering before messaging queues were mature._

(ask anyone and hand waving will occur.  Perhaps Peter?  Andrew?  Naomi? JCoyne?)

### Robot Suites

#### what are "The Robots"?
A system for managing the SDR accessioning pipeline: the robots ingest content into the SDR. The Robots coordinate and execute updating the SDR metadata store (currently Fedora data streams), generating technical metadata, handing off to the preservation system a copy of each object version, etc.

The robots inherit their worker functionality from [the lybercore gem](https://github.com/sul-dlss/lyber-core/).

They coordinate processes using Resque and resque-pool, backed by a Redis instance.

Each type of robot has one or more VMs of its own, but all share the same Redis instance.


#### robot-console
_Tiny app providing the resque console to view the state of our robot redis queues, activity and errors_
  * e.g. https://robot-console-prod.stanford.edu/overview
  * https://github.com/sul-dlss/robot-console/

#### common-accessioning
_Suite of robots that handle the tasks of accessioning digital objects_
Workflows implemented include `assemblyWF`, `accessionWF`, `goobiWF`, `disseminationWF`, `releaseWF`
  * https://github.com/sul-dlss/common-accessioning/

#### preservation_robots
_robots to preserve objects being accessioned via `preservationIngestWF` formerly known as `sdrIngestWF`_

(ask Naomi)

* https://github.com/sul-dlss/preservation_robots/

#### gis-robots
_robots to carry out special processing required for GIS objects via `gisAssemblyWF` and `gisDeliveryWF`_

(ask anyone as we are all equally ignorant, more or less)

* https://github.com/sul-dlss/gis-robot-suite/
* `gisDiscoveryWF` has been retired (?)

#### was_robot_suite
_robots to carry out special processing required for WAS seed and crawl objects via `was_seed_preassemblyWF`,`was_crawl_preassemblyWF`, `as_dissemination` and `was_crawl_disseminationWF`_

(ask Naomi or JLitt)

* https://github.com/sul-dlss/was_robot_suite

## SURI
_Stanford University Repository Identifier service - it mints our identifiers_

(ask JCoyne or Naomi or ...)

  * we sometimes call our identifiers druids - Digital Repository Unique IDs
  * they have a very specific format -- see https://github.com/sul-dlss/druid-tools and/or https://consul.stanford.edu/pages/viewpage.action?title=SURI+2.0+Specification&spaceKey=chimera
  * SURI app is a rails app: https://github.com/sul-dlss/suri-rails


## Puppet
_SUL DLSS uses Puppet for its lower level IT infrastructure, such as loading software onto VMs for our apps_

## PURL
_SDR's persistent url - a URL and a landing page_

(any infrastructure dev)

  * connected to the "releaseWF" workflow

## Digital Stacks
_What we call the location/app where we provide SDR content to end users_

(John or JCoyne or ...)

  * this can be the same as the preserved content, or different.  For example, large image files like TIFFs are turned into small formats appropriate for the viewer in SearchWorks and elsewhere.

## Access Rights for digital content

(ask JCoyne)

  * What's an APO?
  * Where are access restrictions computed when interacting with a specific object? - various codebases use the logic provided by the dor-rights-auth gem:  https://github.com/sul-dlss/dor-rights-auth
  * How are they stored? - Currently, in the `rightsMetadata` datastream for an object (an XML datstream stored in Fedora for a druid).  Will be migrated to the Cocina data model and its JSON serialization format.
  * How do they work to restrict access?
    * Defaults are applied based on the item's parent APO
    * An item can have multiple files, and those files may each have different rights specified from each other as well as from the parent item.  If they don't have rights specified individually, they inherit from the parent item.
  * See also
    * [Rights metadata and public access to SDR objects](https://consul.stanford.edu/display/SDRdocs/Rights+metadata+and+public+access+to+SDR+objects)
    * [Rights metadata -- the rightsMetadata datastream](https://consul.stanford.edu/display/chimera/Rights+metadata+--+the+rightsMetadata+datastream)
    * [Argo - Editing the license and rights statements for a set of objects](https://consul.stanford.edu/display/DLSSDOCS/Argo+-+Editing+the+license+and+rights+statements+for+a+set+of+objects)

## Embargoes

(ask JCoyne)

how are they created, stored, and what processing happens when they expire
  * See integration test for ETD
  * See integration test for H2
  * Expiring - see … cron job for dor-services-app (?)

## SDR APIs
  * dor-services-app https://sul-dlss.github.io/dor-services-app/ (https://github.com/sul-dlss/dor-services-app)
    * dor-services-client
  * cocina-models: https://sul-dlss.github.io/cocina-models/ (https://github.com/sul-dlss/cocina-models)
  * sdr-api: https://sul-dlss.github.io/sdr-api/ (https://github.com/sul-dlss/sdr-api)
    * sdr-client
  * preservation-catalog api: https://sul-dlss.github.io/preservation_catalog/ (https://github.com/sul-dlss/preservation_catalog)
    * preservation-client

## Google-books
_A github repository, a deployed app and so much more_

(ask JLitt, JCoyne or Mike)

  * The goal - To download from Google all scans they have of the books they borrowed from Stanford University Libraries.
  * Will this app ever go away? - Possibly? If we successfully download all scans and accompanying OCRed text, and if Google stops providing better (re-OCRed) text, the app may have then fulfilled its purpose.
  * How much load does it put on our infrastructure? - Sometimes enough to contribute to Fedora performance issues that cascade and cause issues with the rest of SDR, but sometimes that happens even in the absence of Google books activity.  We also suspect that due to storage I/O contention among the virtual machines, it may have contributed to degraded SearchWorks performance for a time (but we think a combination of putting SearchWorks' Solr on faster storage and turning down GBooks concurrency may have solved this?).

## H2 / Happy Heron
_Self-deposit app for the SDR_

(ask Mike or JCoyne)

  * infrastructure-integration-test's `create_object_h2_spec.rb` can provide a walkthrough for how to do a self-deposit

## ETD app
_Electronic Theses and Disserations_

(ask Naomi or Mike)

Used by students submitting ETDs, by the Registrar's office, and caught up in the flow of cataloging ETDs as well.
  * Accession an ETD object from faking original registrar’s post all the way through SDR (stage) - follow steps in infrastructure-integration-test

## Pre-assembly
_When you have complex objects or objects of certain characteristics, this app will organize the files appropriate for getting them into the SDR_

(ask Peter or Naomi)

  * Why do we need it?
  * Who uses it?
  * Run a discovery report on stage and look at the result.

## Preservation
_Used to keep digital content safe, both on prem and also in the cloud_

(ask John)

  * Objects are preserved in the [Moab format](https://journal.code4lib.org/articles/8482), a forward-delta versioning scheme inspired by BagIt and software version control systems such as Git.
    * Moab manipultion and comparison code mostly lives in the [moab-versioning gem](https://github.com/sul-dlss/moab-versioning/), but also some in preservation_robots and preservation_catalog.
  * How things go in
    * a [preservation_robots](https://github.com/sul-dlss/preservation_robots/) worker takes a BagIt bag containing data and metadata for a new object version, and uses that to create a new Moab (if v1 of the object) or add a new version to an existing Moab (if v2+ of the object).
    * a preservation_robots worker will also ask preservation_catalog to queue an integrity check of the new Moab version.
  * Moabs are stored on "storage roots".  There are currently 3 in production.
    * new content goes to the latest storage root (as configured in the storage root list given to the moab-versioning gem)
    * updates to existing content go to the Moab directory on its current storage root (which may no longer be the last storage root)
    * Moabs are stored in "druid tree" paths, which are similar to pair tree paths (e.g. druid `bc123df4567` would be `bc/123/df/4567/bc123df4567`)
  * What are the APIs to interact with preservation
  * How is redis used in preservation
    * there is a Redis instance that coordinates all of the regular accessioning "robots" (including preservation_robots)
    * there is a Redis instance that coordinates all of the preservation_catalog workers (for replicating copies to the cloud and for auditing all preserved content both on prem in in the cloud)

## Technical Metadata app
_Service to extract and record technical metadata for files deposited into SDR_

(ask JLitt)

* technical metadata: for each file, its file type, characteristics of image, PDF, A/V files and so on

## SDR Tags database
_Accessioneers and Argo users and some of our apps "tag" digital objects in the SDR_

(ask Mike)

  * A table in dor-services-app's PostgreSQL database.  Used to live in Fedora.  Useful for human administration of repository content in Argo.

## Modsulator
_A gem and an app that can turn spreadsheets into MODS in a single bound ... or something_

## Bulk jobs/actions in Argo
_When making changes to objects one at a time is the wrong approach_

## Web archiving
_yes, Virginia, DLSS does crawl or download to get WARCs and ingest them into SDR and serve them out_

(ask JLitt or Naomi)

  * was-registrar-app
  * was_robot_suite
  _robots to carry out special processing required for WAS seed and crawl objects_
  * SWAP
  * wasapi-downloader
  * ...

## Solr indexing of SDR
_How we currently index SDR content for searching; the index is mostly used by Argo_

(ask JCoyne)

  * dor_indexing_app
  * Karaf, Camel, ...

## Events (e.g. in Argo object view)
_A way to capture an objects changes over time_

(ask JCoyne)

  * A table in dor-services-app's PostgreSQL database.  Other applications make REST calls to DSA (token authenticated), logging notable activity that might help future with future debugging or provenance determination.

## Goobi
_A workflow tool used by DLSS digitization staff and then hooking into common-accessioning_

(ask Peter)

- what is it, and how does it relate to SDR

## sul_pub
_system for harvest and managing publications for Stanford academic profiles, with controlled API access_

(ask Peter)

## DLME
_Digital Library for the Middle East - a grant funded project to eventually be turned over to a Qatar library_

(ask Aaron)

## Sinopia
_linked data apps; part of the LD4P grants_

(ask JLitt)

  * A set of apps for cataloging using linked data (e.g. Bibframe), and for integrating linked data cataloging with the traditional ILS catalog.  The most visible application is the Sinopia Editor, which is a React front end for the Sinopia API, which is backed by a MongoDB instance (well, AWS DocumentDB).  An Airflow application, ils-middleware, handles integration with the ILS.
  * heading for Library Systems team

## dlss-capistrano
_Ruby gem to facilitate deployment of apps to SUL VMs_

(ask Mike)

## shared_configs
_where we keep secrets.  Working on migrating them to Vault_
