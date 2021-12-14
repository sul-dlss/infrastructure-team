# Yet Another SDR Handbook

_A combination index, glossary, and high level guided tour for the Stanford Digital Repository_

* Access Rights for digital content
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
* Embargoes -- how are they created, stored, and what processing happens when they expire
  * See integration test for ETD
  * See integration test for H2
  * Expiring - see … cron job for dor-services-app (?)
* Know how SDR APIs are used, generally
  * dor-services-app https://sul-dlss.github.io/dor-services-app/ (https://github.com/sul-dlss/dor-services-app)
    * dor-services-client
  * cocina-models: https://sul-dlss.github.io/cocina-models/ (https://github.com/sul-dlss/cocina-models)
  * sdr-api: https://sul-dlss.github.io/sdr-api/ (https://github.com/sul-dlss/sdr-api)
    * sdr-client
  * preservation-catalog api: https://sul-dlss.github.io/preservation_catalog/ (https://github.com/sul-dlss/preservation_catalog)
    * preservation-client
* Google-books 
  * The goal - To download from Google all scans they have of the books they borrowed from Stanford University Libraries.
  * Will this app ever go away? - Possibly? If we successfully download all scans and accompanying OCRed text, and if Google stops providing better (re-OCRed) text, the app may have then fulfilled its purpose.
  * How much load does it put on our infrastructure? - Sometimes enough to contribute to Fedora performance issues that cascade and cause issues with the rest of SDR, but sometimes that happens even in the absence of Google books activity.  We also suspect that due to storage I/O contention among the virtual machines, it may have contributed to degraded SearchWorks performance for a time (but we think a combination of putting SearchWorks' Solr on faster storage and turning down GBooks concurrency may have solved this?).
* H2 / Happy Heron
  * infrastructure-integration-test's `create_object_h2_spec.rb` can provide a walkthrough for how to do a self-deposit
* ETD app
  * Accession an ETD object from faking original registrar’s post all the way through SDR (stage) - follow steps in infrastructure-integration-test
* Pre-assembly
  * Why do we need it?
  * Who uses it?
  * Run a discovery report on stage and look at the result.
* common-accessioning / "The Robots"
  * what are "The Robots"? - A system for managing the SDR accessioning pipeline, the robots ingest content into the digital repository.  The Robots coordinate and execute updating the SDR metadata store (currently Fedora data streams), generating technial metadata, handing off to the preservation system a copy of each object version, etc.
  * The robots inherit their worker functionality from [the lybercore gem](https://github.com/sul-dlss/lyber-core/).
  * They coordinate using Resque and resque-pool, backed by a Redis instance.
  * Each type of robot has one or more VMs of its own, but all share the same Redis instance.
  * Robot activity and errors can be monitored via robot-console.
  * see also: https://github.com/sul-dlss/common-accessioning/ https://github.com/sul-dlss/gis-robot-suite/ https://github.com/sul-dlss/preservation_robots/ https://github.com/sul-dlss/was_robot_suite
* Preservation
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
* Technical Metadata app
* SDR Tags database
  * A table in dor-services-app's PostgreSQL database.  Used to live in Fedora.  Useful for human administration of repository content in Argo.
* Modsulator
* Bulk jobs/actions in Argo
* Gis-robots (...)
* Web archiving (JLitt)
  * was-registrar-app
  * was_robot_suite
  * SWAP
  * wasapi-downloader
  * ...
* Solr indexing of SDR
  * dor_indexing_app
  * Karaf, Camel, ...
* Events (e.g. in Argo object view)
  * A table in dor-services-app's PostgreSQL database.  Other applications make REST calls to DSA (token authenticated), logging notable activity that might help future with future debugging or provenance determination.
* Goobi - what is it, and how does it relate to SDR
* sul_pub
* DLME
* Sinopia
  * A set of apps for cataloging using linked data (e.g. Bibframe), and for integrating linked data cataloging with the traditional ILS catalog.  The most visible application is the Sinopia Editor, which is a React front end for the Sinopia API, which is backed by a MongoDB instance (well, AWS DocumentDB).  An Airflow application, ils-middleware, handles integration with the ILS.
