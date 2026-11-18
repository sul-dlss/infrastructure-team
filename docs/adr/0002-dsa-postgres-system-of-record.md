---
status: accepted
---
# DSA on PostgreSQL is the system of record for cocina objects

DOR Services App (DSA) is the system of record for every SDR object. It stores each object's cocina metadata and version history in PostgreSQL, and it is a repository, not a registry that points at Fedora. Fedora 3 has been removed. Every other SDR app reads and writes objects through the DSA API, and no app keeps its own copy of the authoritative metadata.

## Considered options

- **MongoDB.** EDA 0012 considered it as a document store for cocina JSON. PostgreSQL was chosen instead: it stores each cocina section as a `jsonb` column and still supports relational tables for versions, user versions, events and release tags.
- **Keep Fedora 3 behind cocina.** Rejected because Fedora 3 is unsupported (EDA 0001).

## Consequences

- The schema is `repository_objects` → `repository_object_versions`, which has one `jsonb` column per cocina section (`access`, `administrative`, `description`, `identification`, `structural`, `geographic`). Public, citable versions are tracked in `user_versions`.
- DSA holds more than objects. It is also the workflow engine ([ADR 0008](0008-workflow-engine-in-dsa.md)), a robot host ([ADR 0009](0009-robots-as-sidekiq-workers.md)), the Argo indexer ([ADR 0010](0010-dsa-writes-argo-index.md)) and the event store ([ADR 0005](0005-events-recorded-in-dsa.md)). A DSA outage stops deposit, accessioning, indexing and the robots that DSA hosts.
- Preserved content (Moab, [ADR 0016](0016-moab-and-three-cloud-copies.md)) is the durable copy. The DSA database is the operational record. Prod runs a hot standby with a WAL archive, described in [Platform and operations](../architecture/platform-and-operations.md).

## History

Rewritten from EDA 0012 (drafted 2021-01, decision outcome recorded as "NOT YET"). It also absorbs EDA 0001 (superseded by 0012) and EDA 0007 (an empty template). Differences: the EDA record never states the outcome. The outcome is PostgreSQL, with cocina stored as `jsonb` sections in DSA itself rather than in a separate datastore service.

## Sources

- [DSA `config/database.yml`](https://github.com/sul-dlss/dor-services-app/blob/main/config/database.yml)
- [DSA `db/structure.sql` (repository_object_versions)](https://github.com/sul-dlss/dor-services-app/blob/main/db/structure.sql#L226-L238)
- [EDA 0012](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0012-dor-datastore.md), [EDA 0001](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0001-migrate-off-fedora-3.md), [EDA 0007](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0007-change-dor-from-registry-to-repository.md)
- [Repository core](../architecture/repository-core.md), [Data model](../architecture/data-model.md)

_Verified against default branches on 2026-11-16._
