---
title: Architecture decision records
---

# Architecture decision records

These ADRs record the decisions that shape the Stanford Digital Repository (SDR) and the access systems that consume it. They are written from what is built today, not only from what was proposed. An ADR rewritten from the historical [engineering-design-adrs](https://github.com/sul-dlss-labs/engineering-design-adrs) (EDA) repository says so in its History section and lists how the built system differs. The process is described in [ADR 0001](0001-record-architecture-decisions.md). Terms are defined in the [Glossary](../../GLOSSARY.md).

"Date" is when the decision was made or approved, where EDA or PR history shows it. "—" means unknown.

| No. | Title | Status | Date | Source EDA ADR | Summary |
| --- | --- | --- | --- | --- | --- |
| [0001](0001-record-architecture-decisions.md) | Record SDR architecture decisions here | accepted | 2026-11 | [0000](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0000-use-madr-as-record-format.md) | Short ADRs live in this repo; EDA is historical. |
| [0002](0002-dsa-postgres-system-of-record.md) | DSA on PostgreSQL is the system of record | accepted | — | [0012](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0012-dor-datastore.md) (+[0001](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0001-migrate-off-fedora-3.md), [0007](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0007-change-dor-from-registry-to-repository.md)) | Cocina objects and versions are stored as `jsonb` in DSA; Fedora is gone. |
| [0003](0003-cocina-shared-model-lockstep.md) | Cocina is the shared data model, upgraded in lockstep | accepted | — | new | One cocina-models version across all apps, deployed together. |
| [0004](0004-deposit-api-for-external-depositors.md) | sdr-api is for external and automated depositors | accepted | 2020-02 | [0006](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0006-replace-assembly-wf-with-deposit-api.md) | Google Books and CLI users use sdr-api; internal front ends call DSA directly. |
| [0005](0005-events-recorded-in-dsa.md) | Object events are recorded in DSA | accepted | — | [0009](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0009-create-provenance-service.md) | DSA `events` table fed over RabbitMQ; no provenance service. |
| [0006](0006-rabbitmq-for-events-kafka-for-discovery.md) | RabbitMQ for SDR events, Kafka for discovery | accepted | 2020-03 | [0010](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0010-message-broker.md) | Two brokers; Kafka only for release and unpublish indexing streams. |
| [0007](0007-jwt-for-service-auth.md) | JWTs authenticate inter-service API calls | accepted | 2020-04 | [0011](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0011-use-api-tokens.md) | HMAC-signed bearer tokens, one secret per service. |
| [0008](0008-workflow-engine-in-dsa.md) | The workflow engine lives in DSA | accepted | 2025-05 | [0023](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0023-merge-workflow-service.md) | Workflow service merged into DSA, which keeps a second `workflow` database. |
| [0009](0009-robots-as-sidekiq-workers.md) | Robots are Sidekiq workers built on lyber-core | accepted | 2023-02 | [0017](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0017-robots-sidekiq.md) | One queue per workflow, step and lane; some robots now run in DSA. |
| [0010](0010-dsa-writes-argo-index.md) | DSA builds and writes the Argo Solr index | accepted | — | new (abandons [0008](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0008-separate-dor-index-from-argo-index.md)) | Synchronous in-process indexing; no separate indexer or DOR index. |
| [0011](0011-purl-fetcher-publish-api.md) | purl-fetcher is the single publish and shelve API | accepted | 2024-04 | [0020](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0020-purl-fetcher-api.md) | One API call to publish; file bytes go through a shared NFS transfer stage. |
| [0012](0012-versioned-public-data.md) | Public metadata and files are versioned by user version | accepted | 2024-06 | [0021](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0021-versioned-data-in-purl-and-stacks.md) | Content-addressable layout with hard links for legacy paths. |
| [0013](0013-weka-s3-read-path.md) | Public readers use S3; purl-fetcher writes through a shared mount | accepted | 2025-11 | new | Readers use S3 with read-only credentials; the single writer uses a filesystem mount. |
| [0014](0014-access-systems-consume-cocina.md) | Access systems read cocina, not MODS | accepted | — | [0019](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0019-description.md) | `cocina_display` everywhere; cocina → MODS remains only for public XML. |
| [0015](0015-stacks-enforces-rights-per-request.md) | Stacks checks rights on every request against purl's public cocina | accepted | — | new | No rights database; public JSON cached for 10 minutes. |
| [0016](0016-moab-and-three-cloud-copies.md) | Preservation uses Moab on-prem plus three cloud copies | accepted | — | new | Moab on CephFS; 10 GB zip parts to AWS ×2 and GCP. |
| [0017](0017-embargo-release-opens-version.md) | Embargo release opens a new object version | accepted | — | new | Nightly DSA job rewrites access and re-accessions the object. |
| [0018](0018-release-tags-drive-discovery.md) | Release tags drive discovery indexing through Kafka | accepted | 2025-08 | [0024](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0024-earthworks-indexing.md) | purl-fetcher fans out to "ever released" topics; EarthWorks indexes itself. |
| [0019](0019-pywb-for-web-archive-replay.md) | pywb replaces OpenWayback for web archive replay | accepted | 2022-05 | [0015](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0015-change-swap-from-openwayback.md) | pywb with flat CDXJ indexes; no OutbackCDX. |
| [0020](0020-derivative-generation-in-accessioning.md) | OCR and speech-to-text run as follow-on workflows | accepted | 2024-04 | [0022](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0022-derivative-generation.md) | ocrWF (ABBYY) and speechToTextWF (Whisper on AWS Batch; off in prod). |
| [0021](0021-graphql-for-cocina-retrieval.md) | DSA offers GraphQL for partial cocina retrieval | accepted | 2023-09 | [0018](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0018-graphql.md) | Built for Argo, which is its only client. |
| [0022](0022-argo-b3-containers-with-kamal.md) | Argo-B3 runs in Docker with Kamal; others stay on VMs | accepted | — | [0016](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0016-containerization.md) (narrowed) | Kamal on Puppet-managed hosts for one app; Capistrano for the rest. |
| [0023](0023-argo-b3-replaces-argo-and-pre-assembly.md) | Argo-B3 replaces Argo and pre-assembly | accepted (in progress) | — | new | One staff app for management and batch deposit; all three run today. |
| [0024](0024-qa-shares-stage-access-systems.md) | SDR QA publishes to stage access systems and shares stage storage | accepted | — | new | Deliberate: access systems have no QA level. |
| [0025](0025-shared-prod-solrcloud.md) | All environments' Argo indexes live on the prod SolrCloud | accepted | — | new | Deliberate: `argo_{qa,stage,prod}` on `sul-solr`. |
| [0026](0026-shibboleth-entitlements-for-authz.md) | Staff authorization uses Shibboleth and Workgroup Manager entitlements | accepted | — | new | Apache gates on `eduPersonEntitlement`; APO roles give per-object rights. |
| [0027](0027-geoserver-retired-cloud-optimized-gis.md) | GeoServer is retired; GIS data is served as cloud-native files | accepted | 2026-04 | new | COG, PMTiles and FlatGeobuf from stacks; no WMS/WFS. |

## Disregarded EDA ADRs

These EDA records are not carried forward. They are kept in EDA as history.

| EDA | Title | Reason |
| --- | --- | --- |
| [0001](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0001-migrate-off-fedora-3.md) | Replace Fedora 3 with alternative metadata store | Superseded by EDA 0012. The outcome is recorded in [ADR 0002](0002-dsa-postgres-system-of-record.md). |
| [0002](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0002-extract-only-useful-technical-metadata.md) | Extract only useful technical metadata | Implemented as technical-metadata-service. A design detail of one service, documented in its README. |
| [0003](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0003-extract-technical-metadata-on-per-file-basis.md) | Extract technical metadata per file | Outcome was never decided. techmd runs one job per object and skips unchanged files. A service detail. |
| [0004](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0004-remove-workflow-datastream.md) | Remove workflow datastream from Fedora | Moot: Fedora and the dor-services gem are gone. |
| [0005](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0005-use-deposit-api-in-etd-application.md) | Use Deposit API in ETD application | Never written (empty template). The ETD app calls DSA directly; see [ADR 0004](0004-deposit-api-for-external-depositors.md). |
| [0007](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0007-change-dor-from-registry-to-repository.md) | Change DOR from registry to repository | Empty template. Done in effect; covered by [ADR 0002](0002-dsa-postgres-system-of-record.md). |
| [0008](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0008-separate-dor-index-from-argo-index.md) | Separate DOR index from Argo index | Empty template and never started. Only the Argo index exists; see [ADR 0010](0010-dsa-writes-argo-index.md). |
| 0013 ([PR #31](https://github.com/sul-dlss-labs/engineering-design-adrs/pull/31)) | Secure GitHub automation | Never merged: the draft was closed in 2022-08. |
| 0014 ([PR #33](https://github.com/sul-dlss-labs/engineering-design-adrs/pull/33)) | Cocina model tweaks | Never merged: the PR has been on hold since 2022-03. |

Other open EDA drafts have no decision yet: PR #47 (indexing status in workflows) and PR #54 (moving cocina title logic out of cocina-models). Both reuse numbers that EDA had already assigned. If they are adopted, record them here under new numbers.

_Verified against default branches on 2026-11-16; private-source details redacted 2026-11-17._
