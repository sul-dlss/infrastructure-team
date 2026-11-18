---
status: accepted
date: 2025-11
---
# Public readers use S3; purl-fetcher writes through a shared mount

purl-fetcher, the only writer of public stacks data, writes through a shared filesystem mount (`filesystems.stacks_root`, `/stacks` in its settings). purl and stacks do not mount that filesystem: they read stacks content over S3 from `https://sul-weka-s3.stanford.edu` (their in-repo default bucket is `stacks-test`; each deployed environment sets its own bucket). stacks' Wowza streaming URLs carry a `weka/` path prefix. Moving purl and stacks to S3 removed the filesystem mounts from their web hosts and lets them use an HTTP object API with read-only credentials.

## Considered options

- **Readers mount the stacks filesystem.** This was the previous design and is still what older DevOpsDocs describe. stacks and purl moved to S3 reads in 2025-11 (stacks PR #1517, purl PR #1677) and then dropped their `/stacks` mount checks (stacks PR #1540, purl PR #1693).
- **purl-fetcher also writes through S3.** Not done; purl-fetcher still writes through its mount.

## Consequences

- Readers and the writer use different access paths: purl and stacks depend on the S3 endpoint, the writer on its filesystem mount. An S3 outage breaks public access while publishing keeps working, and the reverse is also possible.
- Globus access to selected druids (`/stacks/globus`, purl-fetcher's `globus_root`) still goes through the filesystem, not S3.

## Sources

- [purl-fetcher `config/settings.yml`](https://github.com/sul-dlss/purl-fetcher/blob/main/config/settings.yml)
- [purl `config/settings.yml`](https://github.com/sul-dlss/purl/blob/main/config/settings.yml)
- [stacks `config/settings.yml`](https://github.com/sul-dlss/stacks/blob/main/config/settings.yml)
- [stacks `app/models/s3_client_factory.rb`](https://github.com/sul-dlss/stacks/blob/main/app/models/s3_client_factory.rb)
- [stacks `app/models/stacks_file.rb`](https://github.com/sul-dlss/stacks/blob/main/app/models/stacks_file.rb)
- stacks PRs [#1517](https://github.com/sul-dlss/stacks/pull/1517), [#1540](https://github.com/sul-dlss/stacks/pull/1540); purl PRs [#1677](https://github.com/sul-dlss/purl/pull/1677), [#1693](https://github.com/sul-dlss/purl/pull/1693)
- [Access and discovery](../architecture/access-and-discovery.md)

_Verified against default branches on 2026-11-16; private-source details redacted 2026-11-17._
