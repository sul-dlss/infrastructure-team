---
status: accepted
---
# All environments' Argo indexes live on the prod SolrCloud

The Argo index for every SDR level is a collection on the production SolrCloud behind `https://sul-solr.stanford.edu`: `argo_qa`, `argo_stage` and `argo_prod`. That cloud is Solr 9 on nine nodes, with a three-node ZooKeeper ensemble. DSA writes the collections ([ADR 0010](0010-dsa-writes-argo-index.md)), and Argo and Argo-B3 read them. The maintainers confirm this is deliberate. Inferred rationale: one well-provisioned SolrCloud costs less to run than one per level, and QA and stage get search performance close to production.

## Considered options

- **Put QA and stage indexes on the test SolrCloud** (`sul-solr-test`). That cluster exists, but SDR does not use it.
- **A Solr instance for each environment.** Not adopted. Inference: the extra hosts and operations work were not judged worth it.

## Consequences

- Load from QA and stage, such as bulk reindexes, load tests and runaway queries, shares capacity with prod Argo. A cluster outage takes down Argo search at every level at once.
- Solr upgrades and schema or config changes cannot first be tested on a separate SDR cluster. The test SolrCloud has to stand in.
- The access team manages the cluster (puppet classifies its hosts as the access team's). It also hosts discovery collections, for example `searchworks-prod`. SDR's prod index therefore depends on another team's change process, and discovery load and SDR load affect each other.

**Reconsider when:**
- QA or stage activity measurably affects prod Argo search or indexing latency.
- A Solr major upgrade or a significant Argo schema change needs a safe rehearsal.
- The test SolrCloud is retired or rebuilt, or the access team changes the SolrCloud's ownership or capacity.
- Argo-B3 search changes (for example new facets or Solr features) need testing in isolation before prod.

## Sources

- [shared_configs `dor-services-app-qa`](https://github.com/sul-dlss/shared_configs/blob/dor-services-app-qa/config/settings/production.yml), [`-stage`](https://github.com/sul-dlss/shared_configs/blob/dor-services-app-stage/config/settings/production.yml), [`-prod`](https://github.com/sul-dlss/shared_configs/blob/dor-services-app-prod/config/settings/production.yml)
- [argo-b3 `config/deploy.qa.yml`](https://github.com/sul-dlss/argo-b3/blob/main/config/deploy.qa.yml)
- [puppet](https://github.com/sul-dlss/puppet) node data for the SolrCloud hosts (private)
- [Environments](../architecture/environments.md), [Platform and operations](../architecture/platform-and-operations.md)

_Verified against default branches on 2026-11-16; private-source details redacted 2026-11-17._
