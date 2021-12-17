# Concepts, inter-service interactions, gems

_A bit more focused on how the services fit together and why._

## types of Digital Objects
_We started with more, but we're kinda down to three_

(ask Andrew)

* APO - _administrative (or admin) policy object_
* Collection - _a collection of items, belonging to an APO_
* Item - _an item can have files; it belongs to a (one or more?) collection_

## Object Registration and Accessioning

How people get objects get into SDR

### Argo

* E.g. "Use Argo to create an object without any files" - https://github.com/sul-dlss/infrastructure-integration-test/blob/main/spec/features/create_object_no_files_spec.rb
* E.g. Create an object, version it, confirm it was preserved - https://github.com/sul-dlss/infrastructure-integration-test/blob/main/spec/features/create_preassembly_image_spec.rb
  * touches on accessioning, preservation, and the event log

### H2

Use H2 to create an object - https://github.com/sul-dlss/infrastructure-integration-test/blob/main/spec/features/create_object_h2_spec.rb

## cocina-models
_SDR data model written as syntactically validatable with dry-struct, dry-types and openapi_

(ask JCoyne or JLitt)

## Workflows and Robots

Robots are what we call our individual accessioning processing steps which are grouped into "workflows", coordinated by the workflow server (and Resque and resque-pool).  They do things like updating the SDR metadata store (currently Fedora data streams), generating technical metadata, handing off to the preservation system a copy of each object version, etc.  

Together, workflow server and the robots provide a system for managing the SDR accessioning pipeline: the robots ingest content into the SDR; workflow server coordinates by queuing tasks to a shared Redis instance.

The robots inherit their worker functionality from [the lybercore gem](https://github.com/sul-dlss/lyber-core/).

Each type of robot has one or more VMs of its own, but all share the same Redis instance, and all are managed on their respective VMs by resque-pool.

This architecture was chosen before open source workflow automation tools like Airflow were available/mature.

Another thing that adds indirection/confusion: sometimes the robots will perform the heavy lifting of a task, but sometimes even they call out to other services.  For example, in the `preservationIngestWF`, the `validate-moab` step in the preservation_robots actually makes a REST call to preservation_catalog to do the validation asynchronously (because that service will do all auditing and cloud replication after the robot finishes updating the content).  And then preservation_catalog tells workflow service when it's done and workflow service tells the preservation_robots to do the next step.

(ask anyone and hand waving will occur.  Perhaps Peter? Andrew? Naomi? JCoyne? - we can re-figure out the layers of legacy code as a team)


## Access Rights for digital content

(ask JCoyne, John)

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

## ETD app
_Electronic Theses and Disserations_

(ask Naomi or Mike)

* Used by students submitting ETDs, by the Registrar's office, and caught up in the flow of cataloging ETDs as well.
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
  * preservation-client is a ruby gem for interating with pres cat's REST API
* Once preservation_catalog has been made aware that new object has been preserved or a new version has been preserved for an existing object, assuming the object passes structural and checksum validation, preservation catalog will replicate the new object version to the cloud.
  * It creates a zip file (uncompressed) of the new Moab version, and sends that to each of the S3 endpoints (there are currently 3, 2 AWS and 1 IBM).
* How is redis used in preservation
  * there is a Redis instance that coordinates all of the regular accessioning "robots" (including preservation_robots)
  * there is a Redis instance that coordinates all of the preservation_catalog workers (for replicating copies to the cloud and for auditing all preserved content both on prem in in the cloud)
* The preservation catalog codebase contains a database README with an ER diagram for the schema as well as a number of useful example queries, and a diagram and README for its replication worker pipeline.

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
_How we currently index SDR content for searching; the index is mostly used by Argo._

(ask JCoyne)

* dor_indexing_app - receives a REST call when an object changes
* Karaf, Camel, ... - the REST call to dor_indexing_app is currently queued in our ActiveMQ instance e.g. when Fedora emits a message indicating that an object was modified.

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
