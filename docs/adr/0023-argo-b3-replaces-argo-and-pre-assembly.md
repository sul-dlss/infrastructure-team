---
status: accepted (in progress)
---
# Argo-B3 replaces Argo and pre-assembly

Argo-B3 ("Argo – Build Back Better") will replace both Argo, the staff management app, and pre-assembly, the batch deposit app from mounts, over the coming months. Batch deposit becomes Argo-B3's Multi-Item Deposit, so one staff application handles registration, management, file structuring and deposit. Argo-B3 is a new codebase rather than a modernization of Argo. It keeps structural metadata in its own Active Record `Content*` tables until deposit, and it talks to DSA directly through dor-services-client ([ADR 0004](0004-deposit-api-for-external-depositors.md)).

## Considered options

- **Incrementally modernize Argo and keep pre-assembly separate.** Not chosen.

## Consequences

- Until the transition ends, all three apps run in prod against the same DSA, Solr index and mounts. Staff and integration tests use both the old and new paths.
- Argo-only dependencies lose their last consumer when Argo retires: DSA GraphQL `find_lite` ([ADR 0021](0021-graphql-for-cocina-retrieval.md)) and sdr-client for Agreement uploads. pre-assembly's RabbitMQ consumer (`preassembly.accession_complete`) and the `sdr:accessioning` Shibboleth entitlement also go away.
- End-to-end coverage moves to the `argo_b3_*` specs in infrastructure-integration-test.
- Argo-B3 is the first containerized SDR app ([ADR 0022](0022-argo-b3-containers-with-kamal.md)). Each environment currently has a single, non-load-balanced host.

## Sources

- [argo-b3 `README.md`](https://github.com/sul-dlss/argo-b3/blob/main/README.md), [`GLOSSARY.md`](https://github.com/sul-dlss/argo-b3/blob/main/GLOSSARY.md)
- [argo](https://github.com/sul-dlss/argo), [pre-assembly](https://github.com/sul-dlss/pre-assembly)
- [infrastructure-integration-test](https://github.com/sul-dlss/infrastructure-integration-test)
- [Management and deposit](../architecture/management-and-deposit.md)

_Verified against default branches on 2026-11-16._
