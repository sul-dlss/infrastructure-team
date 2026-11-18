# Stanford Digital Repository

The Stanford Digital Repository (SDR) is Stanford Libraries' system for depositing, preserving and publishing digital content. These are the terms used across SDR's apps, docs and tickets.

## Language

### Objects and identity

**Object**:
Anything SDR manages under its own druid: a DRO, a collection or an APO.
_Avoid_: record, resource, digital object

**Druid**:
The unique, permanent identifier of an object, such as `druid:bc123df4567`. Where space is limited it is shown without the `druid:` prefix (a bare druid).
_Avoid_: PID, object ID

**Cocina**:
SDR's shared data model, which every SDR and access system uses to describe objects.
_Avoid_: MODS (for SDR's own model), DOR metadata

**Cocina object**:
The complete cocina description of one object at one version: its identification, description, access, administrative, and structural metadata.
_Avoid_: Fedora object, datastream

**DRO**:
A digital repository object: a describable, versioned work with files, access rights and structural metadata. There are three kinds: items, agreements and virtual objects.
_Avoid_: work (outside H3), digital object

**Item**:
A DRO that is neither an agreement nor a virtual object. Most deposited content is an item.

**Virtual object**:
A DRO whose structure is made from the constituents of other DROs, not from files of its own.
_Avoid_: compound object, parent object

**Agreement**:
A DRO that holds the terms under which content is deposited. An APO refers to one, and an agreement is always dark.
_Avoid_: deposit agreement object

**Collection**:
A curatorial grouping of DROs. Membership is one level deep: a collection cannot belong to another collection.
_Avoid_: set, series (for the grouping itself)

**APO**:
An admin policy: an object that governs other objects, supplying their access template, registration defaults and permission roles.
_Avoid_: AdminPolicy, admin policy object, policy

**Governing APO**:
The single APO that governs an object. Every object has one, including APOs themselves.

**Content type**:
The kind of a DRO, such as book, image, map, geo, media, document or web archive, which decides how it is processed and displayed.
_Avoid_: object type (for DROs)

**Source ID**:
The depositor's own identifier for an item, unique within SDR, written as `namespace:value`.
_Avoid_: local ID, source identifier

**Catalog link**:
A link from an object to its record in the library catalog, which can make the catalog record the source of the object's description.
_Avoid_: catkey link

**FOLIO HRID**:
The human-readable identifier of the FOLIO catalog record that a catalog link points to.
_Avoid_: catkey, ckey (both legacy Symphony terms)

**Barcode**:
The identifier of the physical library item that a digitized object was made from.

**DOI**:
A persistent, citable identifier registered with DataCite for an object.

**Description**:
The descriptive metadata of an object: titles, contributors, subjects, dates and similar.
_Avoid_: MODS (for SDR's stored description)

**Structural metadata**:
The ordered file sets and files of a DRO, together with the collections it belongs to and, for a virtual object, its constituents.
_Avoid_: content metadata

**File set**:
An ordered group of files that represent one part of a DRO, such as a page, an image or a recording. Staff tools show a file set to users as a "resource".

**Technical metadata**:
Facts about each file derived by examining it, such as its format, size, dimensions or duration.
_Avoid_: techmd (in prose)

**Derivative**:
A file SDR generates from deposited files, such as an image service copy, OCR text or a speech-to-text transcript.

**Tag**:
An administrative, non-public label on an object, made of terms separated by ` : ` (for example `Project : Maps : 2024`), used to find and group objects. Project and Ticket tags are tags whose first term is `Project` or `Ticket`.
_Avoid_: administrative tag (in UI copy), label

**Event**:
A recorded fact about something that happened to an object, such as its registration, a version being released from embargo or a copy being replicated. Events are the object's provenance.
_Avoid_: log entry, history entry

### Versions and lifecycle

**Version**:
A numbered state of an object. A new version is opened to make changes and closed when they are deposited.
_Avoid_: revision, system version (unless contrasting with user version)

**User version**:
A version made publicly available at PURL and numbered separately from versions. Only the latest user version is shown at the object's PURL, and earlier ones stay at their own versioned addresses.
_Avoid_: public version

**Open version**:
The one version of an object that can currently be changed. An object has at most one open version.

**Opening a version**:
Starting a new version from the last closed one so the object can be changed.
_Avoid_: checking out, unlocking

**Closing a version**:
Ending changes to the open version and submitting it for accessioning.
_Avoid_: committing, versioning

**Withdrawn version**:
A user version other than the latest that has been removed from PURL. It can be restored unless it was permanently withdrawn because the object was made dark.

**Registration**:
Creating a new object in SDR: assigning its druid and recording its first, open version.
_Avoid_: creation, ingest

**Assembly**:
Preparing a version's files before accessioning, for example by generating derivatives and checksums.
_Avoid_: pre-assembly (which is the name of a legacy app)

**Accessioning**:
The processing that turns a closed version into a published, preserved version of the object.
_Avoid_: ingest (for the whole pipeline), processing

**Accessioned**:
The milestone an object version reaches when accessioning has finished.
_Avoid_: deposited (which is the earlier milestone when preservation confirms the version)

**Workflow**:
A named, ordered set of processes that an object version goes through, such as accessioning, assembly or release.
_Avoid_: pipeline, job

**Process**:
One step of a workflow for one version of an object, such as `shelve` in accessioning. A process in error can be retried. "Workflow step" (or "step") is an accepted alias.
_Avoid_: robot step

**Lane**:
The priority at which an object's workflow runs: high, default or low.
_Avoid_: priority, queue

**Robot**:
The worker that performs one kind of process.
_Avoid_: job, worker (for the domain concept)

### Rights and access

**Object access**:
Who may view and download a DRO as a whole, and where. It applies until an embargo, if any, is released.
_Avoid_: rights (alone), rights metadata

**File access**:
Who may view and download an individual file. It can differ from the object access, but a file cannot be citation-only.

**Access template**:
The default access that an APO gives to the new objects it governs.
_Avoid_: default rights, default object rights

**Dark**:
Access under which nothing about an object is public: it has no PURL and none of its files are delivered.
_Avoid_: private, hidden, suppressed

**Citation-only**:
Object access under which only the description is public, and no files are available.
_Avoid_: metadata-only

**Location-based access**:
Access limited to users on the network of a particular Stanford library location.
_Avoid_: on-site only, reading-room access

**Embargo**:
A release date before which an object keeps its current, more restricted access, together with the access that will apply afterwards.

**Embargo release**:
Applying an embargo's access to an object and its files once the release date has passed, which creates a new version of the object.
_Avoid_: embargo lift

### Preservation

**Preservation**:
SDR's archival store of every preserved file of each accessioned version, kept regardless of file access.
_Avoid_: backup, archive

**Preserve flag**:
The per-file choice of whether a file is kept in preservation. Files are preserved unless marked otherwise.
_Avoid_: sdrPreserve (outside code)

**Moab**:
The preserved form of an object on SDR's own storage: one directory per version holding only the new and changed files, with manifests and checksums that describe every version.
_Avoid_: bag (which is only the package handed to preservation)

**Preservation catalog**:
The authoritative inventory of every preserved object version and the state of each of its copies.
_Avoid_: pres cat, PresCat (in prose)

**Replication**:
Copying each preserved version from on-premises storage to the cloud endpoints.
_Avoid_: backup, sync

**Cloud endpoint**:
A cloud storage location that receives a copy of every preserved version.
_Avoid_: zip endpoint (outside code), mirror

**Zip part**:
One piece of a preserved version packaged for a cloud endpoint. A large version is split into several zip parts.
_Avoid_: chunk, segment

**Audit**:
A scheduled check that a preserved copy still exists and matches what the preservation catalog records, including its version and checksums.
_Avoid_: fixity check (for the whole audit), validation

### Publication and discovery

**Publish**:
Making the public parts of an object's latest user version available at PURL and through stacks.
_Avoid_: push, deploy

**Unpublish**:
Removing an object from PURL, stacks and discovery, as happens when it is made dark.
_Avoid_: takedown, delete

**Publish flag**:
The per-file choice of whether a file is listed in the object's public metadata.
_Avoid_: published bit

**Shelve**:
Putting a file in stacks so it can be delivered, subject to its file access.
_Avoid_: stack, upload

**Shelve flag**:
The per-file choice of whether a file is shelved. A dark object's files are never shelved.

**Stacks**:
Where shelved files are served from, for download, image viewing and streaming, subject to their file access.
_Avoid_: digital stacks, file server

**PURL**:
The persistent public web address and landing page of an object, showing its latest user version. Dark objects and objects never published have no PURL page.
_Avoid_: permalink, landing page (alone)

**Public cocina**:
The public subset of an object's cocina, published with each user version and used by every access and discovery system.
_Avoid_: public JSON, public metadata (when cocina is meant)

**Discovery target**:
A discovery system an object can be released to: SearchWorks, EarthWorks, or search engines through the PURL sitemap.
_Avoid_: release target, destination

**Release**:
Making an object discoverable in a discovery target, or withholding it from one.
_Avoid_: publish (for discovery), index

**Release tag**:
An instruction to release an object to, or withhold it from, a discovery target. Release tags are only added, never removed, and an item's latest tag for a target overrides its collections' tags.
_Avoid_: release flag

**Web archive crawl**:
A DRO holding the archived web content captured by one crawl.
_Avoid_: WARC object

**Web archive seed**:
A DRO representing one archived website address, used to find and display its captures.
_Avoid_: seed URL object

### Deposit and management

**Deposit**:
Submitting an object's open version for accessioning, with or without new files.
_Avoid_: ingest, submit (alone), upload

**Draft**:
The changes in an object's open version that have not yet been deposited. Discarding a draft returns the object to its last closed version.
_Avoid_: work in progress, unsaved version

**Self-deposit**:
Deposit by members of the Stanford community through SDR's self-service deposit site, without staff involvement.
_Avoid_: Hydrus deposit, H2 deposit, user deposit

**ETD**:
An electronic thesis or dissertation, submitted by a student and deposited once it has been approved.
_Avoid_: thesis object, dissertation deposit

**Multi-Item Deposit**:
A single staff-run deposit of many items whose files are on a mount, described by a manifest. Do not shorten it to "MID" on its own.
_Avoid_: batch deposit, pre-assembly job, MID

**Bulk action**:
An operation run in the background on many objects at once, chosen from a search or a list of druids, that produces a log of its results.
_Avoid_: batch job, batch operation

**Workgroup**:
A named group of users, such as `sdr:map-staff`, managed outside SDR, to which staff permissions are granted.
_Avoid_: group, role (for the group itself)
