---
status: proposed
---
# Adopt OCFL for preservation storage by converting Moabs in place

SDR preserves every object as a Moab ([ADR 0016](0016-moab-and-three-cloud-copies.md)), a Stanford-only format read and written by Stanford-only code, and states that it plans to implement OCFL ([SDR About](https://sdr.library.stanford.edu/about)). We propose to adopt OCFL 1.1 by **converting each existing Moab in place**, as the specification's Moab section describes: add an OCFL inventory at the object root, with `contentDirectory` set to `data`, and make new versions OCFL-native. No preserved bitstream is moved, copied or rewritten ([OCFL 1.1 §5.5](https://ocfl.io/1.1/spec/#example-moab-in-ocfl)). Inventories use **sha256**, which Moab already records, and preservation_catalog stays the only owner of preservation storage. The staged plan is [Recommendations R18](../architecture/recommendations.md#r18-migrate-preservation-storage-from-moab-to-ocfl-in-place-and-without-flag-days).

## Considered options

- **Stay on Moab.** It works, and the team knows it. But the format and moab-versioning are maintained only here, Moab is read directly by several codebases, and the 2022 outage exposed assumptions tied to the format and its NFS behaviour ([History, lesson 6](../architecture/history-and-lessons.md#6-storage-assumptions-outlive-the-storage)).
- **Copy every object into new OCFL storage roots.** This gives clean objects with no legacy `manifests` directories, but rewrites about 2.2 PB, around 5 million objects and 530 million files ([Code4Lib Journal 56](https://journal.code4lib.org/articles/17290)). It also needs temporary capacity, and puts sustained write load on Ceph. In-place conversion avoids all of that.
- **Wrap each whole Moab inside an OCFL object.** Rejected: the specification's Moab path tracks only the preserved bitstreams (`data/`), not the Moab manifests, so OCFL tools see SDR content rather than a nested format.
- **sha512, OCFL's default digest.** Rejected for conversion: it would mean re-hashing every preserved file. sha256 is permitted.

## Consequences

- Before any object is converted, every Moab consumer must read through preservation_catalog: technical-metadata-service, DSA's bag building and Argo-B3's stacks staging via preservation-client. moab-versioning's validators and preservation_robots must also handle the mixed Moab/OCFL state. Otherwise conversion would mark objects invalid, and invalid objects aren't replicated.
- Each object goes through format states (`moab`, `moab+ocfl`, `ocfl`) recorded by preservation_catalog. Until new versions are OCFL-only, conversion can be undone by deleting the added files. Moving to OCFL-only versions is one-way, so it is done last, one storage root at a time.
- Converted objects keep their legacy `manifests` directories, which OCFL tolerates with a warning, and Moab's four-digit version names, which cap an object at 9,999 versions.
- Cloud replication keeps one zip per version directory. Root inventories of converted objects are not in any zip, but they can be regenerated from the Moab manifests, which are.
- ocfl-rb needs hardening, and an independent OCFL validator is needed, before production use.
- If accepted, this ADR supersedes ADR 0016's Moab format decision; the three cloud copies are unchanged.

## Sources

- [OCFL 1.1 specification](https://ocfl.io/1.1/spec/), §5.5 "Moab in an OCFL Object", E025 (digests) and W002 (extra directories)
- Littman et al., "Strategies for Digital Library Migration", [*Code4Lib Journal* 56 (2023)](https://journal.code4lib.org/articles/17290)
- [SDR About](https://sdr.library.stanford.edu/about)
- [moab-versioning `storage_object_validator.rb`](https://github.com/sul-dlss/moab-versioning/blob/main/lib/moab/storage_object_validator.rb), [`file_signature.rb`](https://github.com/sul-dlss/moab-versioning/blob/main/lib/moab/file_signature.rb)
- [preservation_catalog `zip_creator.rb`](https://github.com/sul-dlss/preservation_catalog/blob/main/app/services/replication/zip_creator.rb), [`replicate_version_service.rb`](https://github.com/sul-dlss/preservation_catalog/blob/main/app/services/replication/replicate_version_service.rb)
- [ocfl-rb](https://github.com/sul-dlss/ocfl-rb)
- [Recommendations R18](../architecture/recommendations.md#r18-migrate-preservation-storage-from-moab-to-ocfl-in-place-and-without-flag-days)

_Verified against default branches on 2026-11-17._
