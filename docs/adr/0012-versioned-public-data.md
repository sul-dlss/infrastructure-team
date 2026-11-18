---
status: accepted
date: 2024-06
---
# Public metadata and files are versioned by user version

Open-access guidelines require a stable, citable URL for each published version of a work. purl-fetcher therefore stores every public *user version* (the citable versions DSA tracks in `user_versions`) in a custom content-addressable layout. Each object has a `versions/` directory (`versions.json`, `meta.json`, `cocina.N.json`, `public.N.xml`) and a `content/<md5>` directory, so a file shared by several versions is stored once. Metadata (formerly `/purl`) and files (formerly `/stacks`) now live in a single tree.

## Considered options

- **OCFL.** It deduplicates and is widely used. Rejected for three reasons: resolving a path needs a manifest lookup, OCFL expects immutable versions while SDR overwrites version 1, and all data would need migrating. OCFL is not used for preservation either ([ADR 0016](0016-moab-and-three-cloud-copies.md)).
- **A directory per version.** Rejected because it duplicates data unless the filesystem deduplicates.
- **A new SDR item per version.** Rejected because it duplicates data and shows every version in discovery and management interfaces.

## Consequences

- Legacy paths (`<druid tree>/<filename>`) and the `/globus` copies of selected druids are **hard links** to `content/<md5>`, not the symbolic links the ADR proposed. As the ADR anticipated, the links and the content-addressed files are two sources of truth that purl-fetcher must keep in sync.
- stacks resolves files only through `content/<md5>`. Withdrawn versions remain on disk but are marked `withdrawn` in `versions.json`.
- Cleanup: purl-fetcher's README still says pre-August-2024 objects use the legacy layout and that readers will switch "in a future workcycle". Readers already use the versioned paths. Whether the legacy hard links can be dropped is an open question.

## History

Rewritten from EDA 0021 (Approved 2024-06-25). Differences: hard links instead of symlinks. Readers use the layout over S3 ([ADR 0013](0013-weka-s3-read-path.md)), not NFS.

## Sources

- [purl-fetcher `app/services/versioned_files_service/paths.rb`](https://github.com/sul-dlss/purl-fetcher/blob/main/app/services/versioned_files_service/paths.rb)
- [purl-fetcher `app/services/versioned_files_service/link_support.rb`](https://github.com/sul-dlss/purl-fetcher/blob/main/app/services/versioned_files_service/link_support.rb)
- [purl-fetcher `README.md` (File layout)](https://github.com/sul-dlss/purl-fetcher/blob/main/README.md#file-layout)
- [stacks `app/models/storage_root.rb`](https://github.com/sul-dlss/stacks/blob/main/app/models/storage_root.rb)
- [EDA 0021](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0021-versioned-data-in-purl-and-stacks.md)
- [Data model](../architecture/data-model.md)

_Verified against default branches on 2026-11-16._
