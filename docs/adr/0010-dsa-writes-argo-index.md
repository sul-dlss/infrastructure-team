---
status: accepted
---
# DSA builds and writes the Argo Solr index

DSA builds the Solr document for an object and writes it directly to the Argo index (`Indexer.reindex` → `solr.add(..., commitWithin: 5000)`). It does this whenever the object, a workflow step or a release tag changes. The separate indexer (dor-indexing-app) was merged into DSA. There is only one SDR index, `argo_<env>`. It serves Argo and argo-b3 search, and it is not a public discovery index. Indexing in-process removes a service and the network hops for each reindex. Since the workflow merge ([ADR 0008](0008-workflow-engine-in-dsa.md)), DSA reads all of the document's inputs, including workflow state, from its own databases.

## Considered options

- **A separate "DOR index" alongside the Argo index** (EDA 0008). It was never designed and is abandoned.
- **Asynchronous indexing through a queue.** The RabbitMQ queue `dor.indexing-by-druid` still exists but has no consumer. DSA indexes in-process: synchronously for registration, workflow updates and release tags, and through its own Sidekiq `ReindexJob` for object updates and version changes.

## Consequences

- Writes to DSA slow down when Solr is slow. A Solr outage fails registration (`POST /v1/objects` indexes with no rescue, after the object is saved), while workflow updates catch index errors and continue ([`create_object_service.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/services/create_object_service.rb#L49-L51)).
- The Argo index for every environment lives on the prod SolrCloud ([ADR 0025](0025-shared-prod-solrcloud.md)).
- Out-of-order commits have caused stale documents (argo#3817). The mitigation is a one-second delay before indexing the last accessionWF step. Each document also carries a trace id and a `current_as_of` timestamp for diagnosis.
- Cleanup: the `dor.indexing-by-druid` queue and stale `dor_indexing.url` settings.

## Sources

- [DSA `app/services/indexer.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/services/indexer.rb)
- [DSA `app/services/workflow/next_step_service.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/services/workflow/next_step_service.rb#L19-L34)
- [DSA `lib/tasks/rabbitmq.rake`](https://github.com/sul-dlss/dor-services-app/blob/main/lib/tasks/rabbitmq.rake#L24-L26)
- [EDA 0008 (abandoned)](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0008-separate-dor-index-from-argo-index.md)
- [Repository core](../architecture/repository-core.md)

_Verified against default branches on 2026-11-16._
