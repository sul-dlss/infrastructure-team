---
status: accepted
date: 2022-05
---
# pywb replaces OpenWayback for web archive replay

The Stanford Web Archive Portal (swap.stanford.edu) replays WARCs with pywb (the was-pywb repository, deployed under uWSGI). It reads CDXJ indexes from `/web-archiving-stacks/data/indexes/cdxj/`, built with cdxj-indexer. SUL's OpenWayback fork failed to replay dynamic content (JavaScript, video), could not be updated from upstream, and used non-standard 10-column CDX files.

## Considered options

- **pywb with OutbackCDX** as the index server. Rejected to keep the service simple, with fewer moving parts. The ADR made this choice subject to index and search performance tests on a multi-terabyte subset.
- **Upstream OpenWayback.** Rejected: it does not solve the replay problems.

## Consequences

- The indexes are flat CDXJ files on the shared web-archiving mount, so index size and lookup speed depend on that filesystem. Adding OutbackCDX later remains an option if they become a problem.
- pywb is AGPL-licensed, which matters if the code is modified and served.
- Web-archive content is shelved by DSA onto `/web-archiving-stacks` directly, not through purl-fetcher ([ADR 0011](0011-purl-fetcher-publish-api.md)).

## History

Rewritten from EDA 0015 (proposed 2022-05-17; consensus on 2022-05-19; status left as "drafted"). Differences: none. It was built as decided, and no OutbackCDX or OpenWayback remains in SDR.

## Sources

- [was-pywb `pywb/config.yaml`](https://github.com/sul-dlss/was-pywb/blob/main/pywb/config.yaml)
- [was-pywb `README.md`](https://github.com/sul-dlss/was-pywb/blob/main/README.md)
- [EDA 0015](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0015-change-swap-from-openwayback.md)
- [Access and discovery](../architecture/access-and-discovery.md)

_Verified against default branches on 2026-11-16._
