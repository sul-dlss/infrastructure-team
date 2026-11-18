---
status: accepted
---
# Preservation uses Moab on-prem plus three cloud copies

Every accessioned version of an SDR object is preserved as a Moab, a versioned, manifest-based directory layout written by `moab-versioning` and the preservation_robots. Moabs live on on-prem CephFS storage roots (four in prod). preservation_catalog then zips each Moab version without compression, splits it into 10 GB parts (`zip -r0X -s 10g`), and replicates the parts to three cloud endpoints in different regions and providers: AWS S3 us-west-2, AWS S3 us-east-1 and Google Cloud Storage us-south1. It audits both the on-prem and the cloud copies on a schedule.

## Considered options

- **OCFL** for the on-prem copy. Not adopted yet: `ocfl-rb` exists in the org but preservation_catalog does not use it. SDR states that it plans to implement OCFL ([SDR About](https://sdr.library.stanford.edu/about)); [Recommendations R18](../architecture/recommendations.md#r18-migrate-preservation-storage-from-moab-to-ocfl-in-place-and-without-flag-days) sketches an in-place migration that would supersede this ADR. (OCFL was separately rejected for the access layout; [ADR 0012](0012-versioned-public-data.md).)
- **Fewer or single-provider cloud copies.** The endpoint set has changed over time: IBM us-south was added in 2019 and dropped in 2026-04, and GCP was added in 2025-05. Two providers have been kept throughout.

## Consequences

- The Moab layout is fixed for every preserved object, and technical-metadata-service also reads Moabs directly. Moving to another format would mean migrating all preserved content.
- New objects land on the *last* configured storage root, so the order of storage roots in configuration matters.
- AWS copies move to Glacier after upload, so a restore or deep fixity check from AWS needs a Glacier restore first. GCP copies can be read immediately. There is no automated restore from the cloud.
- Removing an endpoint requires `rake decommission_endpoint`, which purges that endpoint's zip parts and database rows.
- Zip parts are versioned per Moab version. A new object version adds parts and never rewrites old ones.

## Sources

- [preservation_catalog `app/services/replication/zip_creator.rb`](https://github.com/sul-dlss/preservation_catalog/blob/main/app/services/replication/zip_creator.rb)
- [shared_configs `preservation-catalog-prod`](https://github.com/sul-dlss/shared_configs/blob/preservation-catalog-prod/config/settings/production.yml)
- [moab-versioning](https://github.com/sul-dlss/moab-versioning)
- [preservation_robots](https://github.com/sul-dlss/preservation_robots)
- [Preservation](../architecture/preservation.md)

_Verified against default branches on 2026-11-16; private-source details redacted 2026-11-17._
