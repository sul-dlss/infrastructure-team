---
status: accepted
date: 2020-03
---
# RabbitMQ for SDR events, Kafka for discovery indexing

SDR uses two message brokers, each for a different purpose. RabbitMQ (vhost `workflow`; a three-node cluster each for prod and stage, a single node for qa) carries SDR events and workflow notifications between SDR apps. Kafka (`sul-kafka-{prod,stage}-a`) carries only access-side indexing streams. Discovery indexers need a replayable, compacted log per object so they can rebuild an index from scratch. RabbitMQ queues do not provide that, so Kafka was added for discovery instead of extending RabbitMQ.

| Broker | Producers | Key exchanges/topics | Consumers |
| --- | --- | --- | --- |
| RabbitMQ (Sneakers) | DSA, dor-event-client users | `sdr.objects.event`, `sdr.workflow` (routing key `<process>.<status>`) | DSA (`dsa.create-event`), pre-assembly, H3 |
| Kafka (Racecar) | purl-fetcher, FOLIO extractor | `purl_fetcher_*`, an EarthWorks release topic, `sitemap_release_*`, `marc_folio_*` | searchworks_traject_indexer, EarthWorks, content_search, sitemap |

## Considered options

- **RabbitMQ for all asynchronous messaging.** This was EDA 0010's scope. It covered SDR, but discovery reindexing needs replay and per-key compaction.
- **Discovery systems poll purl or DSA.** Rejected in [ADR 0018](0018-release-tags-drive-discovery.md).

## Consequences

- Operations runs two broker technologies. Kafka is a single broker per environment with ZooKeeper on the same host, so it has no high availability.
- Dead RabbitMQ wiring needs cleanup. The queue `dor.indexing-by-druid` is still declared but has no consumer. The exchanges `sdr.objects.created` and `sdr.objects.embargo_lifted` are published by DSA but have no known consumer.

## History

Rewritten from EDA 0010 (drafted 2020-02; technology selection added 2020-03; outcome recorded as "TBD"). Differences: RabbitMQ was adopted as recommended, but only for SDR-internal messaging. Kafka was added later for discovery, and no ADR recorded that.

## Sources

- [DSA `lib/tasks/rabbitmq.rake`](https://github.com/sul-dlss/dor-services-app/blob/main/lib/tasks/rabbitmq.rake)
- [DSA `app/services/notifications/`](https://github.com/sul-dlss/dor-services-app/tree/main/app/services/notifications)
- [purl-fetcher `app/models/indexer_log_writer.rb`](https://github.com/sul-dlss/purl-fetcher/blob/main/app/models/indexer_log_writer.rb)
- [puppet](https://github.com/sul-dlss/puppet) (RabbitMQ cluster configuration)
- [EDA 0010](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0010-message-broker.md)
- [Repository core](../architecture/repository-core.md), [Access and discovery](../architecture/access-and-discovery.md)

_Verified against default branches on 2026-11-16; private-source details redacted 2026-11-17._
