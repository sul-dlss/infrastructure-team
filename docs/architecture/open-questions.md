---
title: Open questions
---

# Open questions

This page collects the questions these docs could not answer from code, configuration or project docs. It merges the "Unverified" items from the subsystem pages with the open questions from the research behind them, removes duplicates, and groups them by subsystem. Each question says what is known and links to the evidence. Questions the maintainer has already answered are left out (they are now stated as facts on the pages), as are ops-team processes such as paging, on-call, alert routing and data refresh, which are out of scope. Cleanup that only needs doing, not deciding, is in the "Known issues and cleanup" section of each page and in [Recommendations](recommendations.md). Terms are defined in the [Glossary](../../GLOSSARY.md).

## Data model

1. **When does a change become a new public (user) version?**
   - Known: DSA's default `user_version_mode` on close is `update_if_existing`. H3 passes `new` when the depositor asks for a new version, and sdr-api passes `none`. No other client sets the mode explicitly, so Argo, Argo-B3, pre-assembly and the embargo-release job get the default.
   - Open: is this the intended policy, and should it be written down?
   - Evidence: [Data model §3.4](data-model.md#34-user-versions); H3 [`app/services/sdr/repository.rb`](https://github.com/sul-dlss/hungry-hungry-hippo/blob/main/app/services/sdr/repository.rb); sdr-api [`app/jobs/ingest_job.rb`](https://github.com/sul-dlss/sdr-api/blob/main/app/jobs/ingest_job.rb).

## Management and deposit

1. **Is it intended that every environment mounts the prod Globus server?**
   - Known: qa, stage and prod mount `/globus` from the prod Globus server, separated by per-environment directories, so test uploads land on the prod server.
   - Evidence: [Management and deposit, file staging](management-and-deposit.md#file-staging-and-mounts); [Environments](environments.md#cross-environment-wiring).
2. **Is sdr-api's local-disk Active Storage on stage and qa by design?**
   - Known: prod stores uploads on a dedicated NFS export. Stage and qa have no such mount (inference: they use local disk).
   - Evidence: [Management and deposit, components](management-and-deposit.md#components).
3. **What is sdr-api's long-term role?**
   - Known: [ADR 0004](../adr/0004-deposit-api-for-external-depositors.md) makes sdr-api the deposit API for external and automated depositors. Known callers are sdr-client users, Google Books, and Argo (for agreements and token issuing).
   - Open: are there other external depositors, and will Argo-B3 keep using it?
   - Evidence: [Management and deposit, sdr-api deposit](management-and-deposit.md#sdr-api-deposit-sdr-client-google-books).
4. **Are the old workflow service DNS names still live?**
   - Known: the workflow service is merged into DSA ([ADR 0008](../adr/0008-workflow-engine-in-dsa.md)). `workflow_url` and `workflow.url` remain in shared_configs for Argo, pre-assembly, H3, sdr-api, WRA, DSA and several robot suites.
   - Open: whether anything still resolves or calls these names. This decides whether the keys can be deleted safely.
   - Evidence: [Management and deposit, known issues](management-and-deposit.md#known-issues-and-cleanup); [Accessioning, known issues](accessioning.md#known-issues-and-cleanup).
5. **Is was-registrar-app the only writer of `/was_unaccessioned_data`?**
   - Known: WRA, pre-assembly and Argo-B3 mount it, and WAS `build-was-crawl-druid-tree` reads it.
   - Evidence: [Accessioning, shared filesystems](accessioning.md#shared-filesystems); [Management and deposit, file staging](management-and-deposit.md#file-staging-and-mounts).

## Repository core

1. **What happens to an embargo whose release date passes while a version is open?**
   - Known: the daily `dsa:embargo_release` job acts only on accessioned, openable objects ([ADR 0017](../adr/0017-embargo-release-opens-version.md)).
   - Open: is a skipped object retried on later runs once it can be opened, and is anyone told?
   - Evidence: [Repository core, DSA responsibilities](repository-core.md#dsa-responsibilities); [Access and discovery, embargo lifting](access-and-discovery.md#embargo-lifting).
2. **Will the DSA GraphQL endpoint outlive Argo?**
   - Known: Argo is its only client ([ADR 0021](../adr/0021-graphql-for-cocina-retrieval.md)), and Argo-B3 will replace Argo ([ADR 0023](../adr/0023-argo-b3-replaces-argo-and-pre-assembly.md)).
   - Open: will Argo-B3 adopt the endpoint, or will it be removed?
3. **Is `techmd-<env>.stanford.edu` an alias for `dor-techmd-<env>-a`?**
   - Known: common-accessioning calls `techmd-{prod,stage}` but `dor-techmd-qa-a` directly.
   - Evidence: [Accessioning, accessionWF](accessioning.md#accessionwf).

## Accessioning

1. **Can the orphaned workflow templates be deleted?**
   - Known: `gisDeliveryWF`, `captionWF` and `wasSeedDisseminationWF` have no robot code. The legacy templates (`digitizationWF`, `dpgImageWF`, `eemsAccessionWF`, `googleScannedBookWF`, `sdrIngestWF`, `sdrMigrationWF`, `sdrRecoveryWF`) have no robots either.
   - Open: does any APO still name one as its `disseminationWorkflow`, and does displaying old objects need the legacy templates?
   - Evidence: [Accessioning, known issues](accessioning.md#known-issues-and-cleanup); [Accessioning, legacy templates](accessioning.md#indexing-only-and-legacy-templates).
2. **Is the `/maps` mount on common-accessioning prod still needed?**
   - Known: no robot code reads the Ceph NFS maps export mounted there. pre-assembly and Argo-B3 prod use `/maps` as a source mount.
   - Evidence: [Accessioning, shared filesystems](accessioning.md#shared-filesystems).

## Preservation

1. **When, and how, will SDR implement OCFL?**
   - Known: SDR states that it plans to implement OCFL ([SDR About](https://sdr.library.stanford.edu/about)). [ocfl-rb](https://github.com/sul-dlss/ocfl-rb) is maintained, but no SDR app depends on it, and preservation is Moab-only ([ADR 0016](../adr/0016-moab-and-three-cloud-copies.md)). No schedule or design is recorded; [R18](recommendations.md#r18-migrate-preservation-storage-from-moab-to-ocfl-in-place-and-without-flag-days) proposes one.
   - Evidence: [Preservation, components](preservation.md#components).
2. **What storage class and lifecycle apply to the AWS buckets, and where are the rules managed?**
   - Known: pres cat writes zip parts to AWS us-west-2 and us-east-1 and GCP us-south1. No lifecycle rules were found in the app repos, and there is no automated cloud restore.
   - Open: the Glacier class and transition age, whether the rules are in Terraform, and how a restore is done.
   - Evidence: [Preservation, replication](preservation.md#replication); [Preservation, restoration](preservation.md#restoration).
3. **Is cloud fixity on the roadmap?**
   - Known: pres cat `AGENTS.md` mentions re-hashing replicated bytes as planned work. Today's replication audit does not re-hash them.
   - Evidence: [Preservation, audits](preservation.md#audits).
4. **How much space do the Moab storage roots have, and which ones are production?**
   - Known: new objects land on the last storage root listed in config.
   - Open: the capacity and free space of the CephFS storage roots, which root receives new Moabs, and whether both Ceph clusters hold production SDR storage.
   - Evidence: [Preservation, Moab layout](preservation.md#moab-layout); [Preservation, storage](preservation.md#storage).
5. **Is qa's `zip_storage` on the stage services disk intentional?**
   - Known: qa's `zip_storage` points at a directory on the stage services disk, although puppet mounts dedicated transfer volumes on `preservation-catalog-worker-qa-01`.
   - Evidence: [Preservation, known issues](preservation.md#known-issues-and-cleanup).
6. **How are `/queues` (Sidekiq Web) and `/dashboard` on the pres cat web hosts protected?**
   - Known: the app itself does not authenticate them ([`routes.rb`](https://github.com/sul-dlss/preservation_catalog/blob/main/config/routes.rb)), so protection depends on web-server and network configuration.
   - Evidence: [Recommendations R12](recommendations.md#r12-close-the-security-gaps-the-evidence-shows).
7. **Why do the preservation_robots hosts mount `/sdr-deposit-staging` read-write?**
   - Known: robot code does not use the mount.
   - Evidence: [Preservation, known issues](preservation.md#known-issues-and-cleanup).
8. **Can the third pres cat qa and stage hosts, and an extra volume mounted on `preservation-catalog-web-prod-01`, be decommissioned?**
   - Known: those qa and stage hosts run only Redis, and no config references them.
   - Evidence: [Preservation, known issues](preservation.md#known-issues-and-cleanup).

## Access and discovery

1. **Which collections, configsets and writers back the SearchWorks indexes?**
   - Known: `searchworks-prod-2025` is written by the prod traject indexers, and SearchWorks prod reads `searchworks-prod` (inference: an alias). No configset matches `sw-preview-*`, `searchworks-bots-prod` or `searchworks-folio-*`.
   - Open: is `searchworks-prod` an alias, which configsets back those collections, and who writes `searchworks-bots-prod` and `searchworks-folio-prod`?
   - Evidence: [Access and discovery, SolrCloud collections](access-and-discovery.md#solrcloud-collections).
2. **Is `sul-purl-test.stanford.edu` an alias of `sul-purl-stage`?**
   - Known: the stage traject indexer reads purl through it.
   - Evidence: [Access and discovery, hosts](access-and-discovery.md#hosts-and-environments).
3. **Are the discovery gaps in purl-fetcher's Kafka routing intended?**
   - Known (from code):
     - `purl_fetcher_*` messages are sent only when an object has ever had a `Searchworks` release tag, so content_search and the SearchWorks preview index miss everything else.
     - A republish without a release-tag change produces no message.
     - Unpublishing sends no tombstone to the sitemap topic.
   - Open: are these intended? Does releaseWF always follow accessioning, apart from migrations that use `skipReleaseWF`?
   - Evidence: [Access and discovery, Kafka topics](access-and-discovery.md#kafka-topics); [Access and discovery, known issues](access-and-discovery.md#known-issues-and-cleanup).
4. **What do the stage Cantaloupe hosts serve, and is `imageserver-prod` a load-balanced name?**
   - Known: stage stacks uses the new IIIF server on `imageserver-test`. purl-fetcher-stage still purges the two stage Cantaloupe hosts. Prod stacks uses `imageserver-prod` for four Cantaloupe hosts.
   - Open: who uses the stage Cantaloupe server, and whether `imageserver-prod` is an F5 VIP or a DNS name.
   - Evidence: [Access and discovery, IIIF image delivery](access-and-discovery.md#iiif-image-delivery).
5. **Is the image-delivery proof-of-concept host active?**
   - Known: a proof-of-concept host has read-only access to stage public files, and its repository is not on GitHub; it looks like an experiment (inference). The other experiment, an experimental Cantaloupe host, was decommissioned on 2026-11-16, leaving its `sul-stacks-cdn` config branch.
   - Evidence: [Access and discovery, components](access-and-discovery.md#components).
6. **What is the Docker setup on `sul-stacks-stage` for?**
   - Known: it is not part of stacks' deployed request path (inference: a pilot).
   - Evidence: [Access and discovery, components](access-and-discovery.md#components).
7. **Who schedules was-pywb CDXJ indexing?**
   - Known: was-pywb's `bin/index.rb` defaults to `/web-archiving-stacks/data/warcs`, and was_robot_suite's `wasCrawlDisseminationWF` generates and merges CDXJ.
   - Open: which of these produces `/web-archiving-stacks/data/indexes/cdxj/` in prod, and whether the was-pywb script runs at all.
   - Evidence: [Access and discovery, web archive replay](access-and-discovery.md#web-archive-replay-swap); [Accessioning, web archiving workflows](accessioning.md#web-archiving-workflows).
8. **What is the extra shared mount on the purl prod hosts for?**
   - Known: puppet mounts an additional NFS volume on `sul-purl-prod-{a,b}`. purl's code does not mention it.
   - Evidence: [Access and discovery, known issues](access-and-discovery.md#known-issues-and-cleanup).
9. **Which purl-fetcher read endpoints and legacy stacks paths are still used?**
   - Known: no current caller of `GET /purls/:druid` or `GET /released/:release_tag` was found. `POST /v1/mods` is used by Argo's metadata preview, according to a controller comment. The legacy unversioned hard links in `/stacks` have no known reader (inference).
   - Open: are these unused? Has every object been migrated to the versioned layout, so the legacy links can go?
   - Evidence: [Access and discovery, HTTP APIs](access-and-discovery.md#http-apis); [Access and discovery, storage](access-and-discovery.md#storage-a-shared-mount-for-the-writer-s3-for-readers); [ADR 0012](../adr/0012-versioned-public-data.md).
10. **Is the cocina → MODS mapping in purl-fetcher permanent?**
    - Known: access systems read cocina, but public XML, `.mods` and `POST /v1/mods` still need MODS, and purl-fetcher holds the mapping ([ADR 0014](../adr/0014-access-systems-consume-cocina.md)).
    - Open: is retiring public MODS still a goal?

## Platform and operations

1. **Are all hosts on supported OS releases?**
   - Known: the OS is not recorded in puppet data, and some package pins are stale.
   - Evidence: [Platform and operations, techstacks and OS](platform-and-operations.md#techstacks-and-os).
2. **Which SDR services have F5 VIPs, and how is a node drained?**
   - Known: the F5 health-checks each pool member through a puppet-installed responder, which a marker file on the host can switch to "down" (inference: that drains the node).
   - Open: the VIP list (for example whether `argo-b3`, `techmd-<env>` and `preservation-catalog-stage` have VIPs or only DNS names) and whether the marker file is the supported drain procedure.
   - Evidence: [Platform and operations, request path](platform-and-operations.md#request-path).
3. **What consumes puppet's descriptive host metadata downstream?**
   - Known: puppet passes some host metadata to the Zabbix agent; how Zabbix acts on it is outside these repos. No puppet code reads the rest of the descriptive metadata.
   - Evidence: [Platform and operations, classification facts](platform-and-operations.md#classification-facts).
4. **Where do the platform services themselves run?**
   - Known: puppetserver, Vault, the Zabbix server and Jenkins (`sul-ci-prod`) are not among the SDR hosts defined in puppet.
   - Open: which hosts run them.
   - Evidence: [Platform and operations, components](platform-and-operations.md#components).
5. **Where should Argo-B3 logs and health checks go before it replaces Argo and pre-assembly?**
   - Known: its log shipping, health checks and host classification need verifying before cutover.
   - Evidence: [Platform and operations, known issues](platform-and-operations.md#known-issues-and-cleanup).
6. **Is the single-node `sul-rabbit-qa` intentional?**
   - Known: prod and stage RabbitMQ are three-node clusters. qa is one node.
   - Evidence: [Platform and operations, shared services](platform-and-operations.md#shared-services-sdr-depends-on).
7. **How does the IdP decide which entitlements to release?**
   - Known: apps receive Workgroup Manager workgroups as `eduPersonEntitlement` values ([ADR 0026](../adr/0026-shibboleth-entitlements-for-authz.md)). The release configuration is not in any SDR repository.
   - Evidence: [Platform and operations, authentication](platform-and-operations.md#users-shibboleth-and-workgroup-manager).

## Sources

- The "Unverified" and "Inference" items and the "Known issues and cleanup" sections of [Data model](data-model.md), [Management and deposit](management-and-deposit.md), [Repository core](repository-core.md), [Accessioning](accessioning.md), [Preservation](preservation.md), [Access and discovery](access-and-discovery.md) and [Platform and operations](platform-and-operations.md)
- [hungry-hungry-hippo `app/services/sdr/repository.rb`](https://github.com/sul-dlss/hungry-hungry-hippo/blob/main/app/services/sdr/repository.rb), [sdr-api `app/jobs/ingest_job.rb`](https://github.com/sul-dlss/sdr-api/blob/main/app/jobs/ingest_job.rb), [sdr-api `app/jobs/update_job.rb`](https://github.com/sul-dlss/sdr-api/blob/main/app/jobs/update_job.rb)
- [argo-b3 `config/deploy.prod.yml`](https://github.com/sul-dlss/argo-b3/blob/main/config/deploy.prod.yml), which settles the deployed Solr collection (`argo_<env>`) and pres cat URL (`preservation-catalog-<env>`), so neither is listed here

_Verified against default branches on 2026-11-16; private-source details redacted 2026-11-17._
