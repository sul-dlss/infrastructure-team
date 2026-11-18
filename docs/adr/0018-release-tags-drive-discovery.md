---
status: accepted
date: 2025-08
---
# Release tags drive discovery indexing through Kafka

Release tags, stored in DSA's `release_tags` table, decide which discovery systems show an object: SearchWorks, EarthWorks and the sitemap. When a tag changes, releaseWF's `release-publish` step sends the tags to purl-fetcher (`PUT /v1/purls/:druid/release_tags`). purl-fetcher records them in `meta.json` and produces a message to the Kafka topic of every target the object was *ever* released to, whether the current tag is true or false. Unpublish produces tombstones. Each discovery system consumes its own topic and indexes itself. EarthWorks does this in its own codebase (a Racecar `SdrConsumer` on earthworks-worker) and no longer through searchworks_traject_indexer.

## Considered options

- **Discovery systems poll purl-fetcher or DSA for changes.** EDA 0024 offered polling as option 2 for EarthWorks and rejected it in favour of streaming.
- **DSA produces to discovery directly.** Not adopted. Producing from purl-fetcher means a message is sent only after the public cocina the indexers read has been written.
- **Keep EarthWorks indexing in searchworks_traject_indexer.** Removed in 2026-06/07. EarthWorks' indexing was simpler (cocina only, no FOLIO), it was being broken by SearchWorks changes, and it was split across two places.

## Consequences

- "Ever released" semantics mean that a target set to `false` still receives a message, and the consumer then deletes the record (for example in EarthWorks' `SdrConsumer#delete?`). Without that message, records would linger in the index.
- Every discovery index depends on purl-fetcher's topics. Replaying a topic rebuilds an index.
- The sitemap gets no tombstone on unpublish (inference from the access notes). Check this before relying on the sitemap for deletions.
- OpenGeoMetadata harvesting for EarthWorks (`geocombine:pull earthworks:index`) is a separate daily cron, not part of this flow.

## History

Partly rewritten from EDA 0024 (proposed 2025-08-14, status left as "proposed"). Differences: none for EarthWorks, which uses option 1 (streaming from purl-fetcher's Kafka). The release-tag fan-out itself predates EDA and was never recorded.

## Sources

- [DSA `app/jobs/robots/dor_repo/release/release_publish.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/jobs/robots/dor_repo/release/release_publish.rb)
- [purl-fetcher `app/models/indexer_log_writer.rb`](https://github.com/sul-dlss/purl-fetcher/blob/main/app/models/indexer_log_writer.rb)
- [earthworks `app/consumers/sdr_consumer.rb`](https://github.com/sul-dlss/earthworks/blob/main/app/consumers/sdr_consumer.rb)
- [searchworks_traject_indexer `lib/traject/config/`](https://github.com/sul-dlss/searchworks_traject_indexer/tree/main/lib/traject/config)
- [EDA 0024](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0024-earthworks-indexing.md)
- [Access and discovery](../architecture/access-and-discovery.md)

_Verified against default branches on 2026-11-16._
