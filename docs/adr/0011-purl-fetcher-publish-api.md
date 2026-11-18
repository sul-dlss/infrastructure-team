---
status: accepted
date: 2024-04
---
# purl-fetcher is the single publish and shelve API

purl-fetcher owns everything that becomes public. DSA publishes an object with one call, `PUT /v1/purls/:druid`, sending the public cocina, the version, and a map of files to shelve. purl-fetcher writes the files and public metadata into the stacks filesystem, and updates its own database. Publishing emits no discovery messages; the separate release-tags call (from releaseWF) and unpublish do ([ADR 0018](0018-release-tags-drive-discovery.md)). Unpublish, release tags and withdraw/restore of a version are also purl-fetcher endpoints. DSA no longer knows the `/stacks` or `/purl` layout. That decoupling is what made the versioned layout ([ADR 0012](0012-versioned-public-data.md)) possible without changing DSA.

## Considered options

- **Upload file bytes over HTTP, as in sdr-api** (EDA 0020's preferred shape). Not built. Instead, DSA copies the files to be shelved to a shared NFS transfer stage under UUID names (DSA's `stacks.transfer_stage_root`, purl-fetcher's `filesystems.transfer`; stage and qa share one), and purl-fetcher moves them into place.
- **Keep the three-step publish** (DSA writes `/stacks` and `/purl`, then notifies purl-fetcher). Replaced.

## Consequences

- purl-fetcher is the only writer of public files and metadata. It is the only host with the stacks filesystem mounted read-write; readers use S3 ([ADR 0013](0013-weka-s3-read-path.md)).
- DSA and purl-fetcher must share the transfer mount, which ties both to the same shared filesystem. If publish fails, DSA deletes the staged copies, so a retry recopies the files.
- Each environment has one purl-fetcher host, and it is not load-balanced. It is a single point of failure for publishing and for discovery indexing ([ADR 0018](0018-release-tags-drive-discovery.md)).
- DSA still mounts `/web-archiving-stacks` and shelves web-archive content itself. That path does not go through purl-fetcher.

## History

Rewritten from EDA 0020 (Approved 2024-04-28). Differences: file transfer uses a shared NFS stage instead of HTTP uploads. The API also took on release tags and version withdraw/restore.

## Sources

- [DSA `app/services/publish/metadata_transfer_service.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/services/publish/metadata_transfer_service.rb#L61-L75)
- [purl-fetcher `config/routes.rb`](https://github.com/sul-dlss/purl-fetcher/blob/main/config/routes.rb)
- [purl_fetcher-client](https://github.com/sul-dlss/purl_fetcher-client)
- [shared_configs `dor-services-app-prod`](https://github.com/sul-dlss/shared_configs/blob/dor-services-app-prod/config/settings/production.yml)
- [EDA 0020](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0020-purl-fetcher-api.md)
- [Access and discovery](../architecture/access-and-discovery.md)

_Verified against default branches on 2026-11-16; private-source details redacted 2026-11-17._
