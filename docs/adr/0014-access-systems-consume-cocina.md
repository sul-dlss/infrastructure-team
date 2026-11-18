---
status: accepted
---
# Access systems read cocina, not MODS

Access and discovery systems take descriptive metadata from the public cocina JSON, using the shared `cocina_display` gem. They do not use MODS. That gem is used by purl, SearchWorks, searchworks_traject_indexer, exhibits, EarthWorks, sul-embed, purl-fetcher, DSA, Argo and argo-b3, and none of them depend on `mods_display` or `stanford-mods`. MODS is still produced, but only as an output format: purl-fetcher holds the cocina → MODS mapping (`ToMods::Description`) and uses it to write the MODS inside the public XML.

## Considered options

- **Access systems keep extracting description from MODS**, or **use a mix of cocina and MODS.** These were the alternatives in EDA 0019. They were rejected because description extraction was duplicated across codebases, and the cocina → MODS hop made it hard to trace how a field ended up rendered.

## Consequences

- MODS remains a public contract: purl serves `/:druid.mods`, the public XML embeds MODS, and purl-fetcher exposes `POST /v1/mods` for conversions. Retiring MODS output would be a separate decision with external consumers to consider.
- cocina-models now holds only the *from*-MODS mappings (MARC → MODS → cocina at ingest). The *to*-MODS mapping moved to purl-fetcher.
- Display and indexing logic for description is shared in one gem, so changes to that gem ship to many apps at once.

## History

Rewritten from EDA 0019 (proposed 2023-11, "drafted without decision"). Differences: the description abstraction was built as `cocina_display`, and the access-side half is complete. The proposal to remove the cocina → MODS mapping was not done. The mapping moved to purl-fetcher instead.

## Sources

- [cocina_display](https://github.com/sul-dlss/cocina_display)
- [purl-fetcher `app/services/publish/public_desc_metadata_service.rb`](https://github.com/sul-dlss/purl-fetcher/blob/main/app/services/publish/public_desc_metadata_service.rb#L20)
- [purl-fetcher `app/services/to_mods/`](https://github.com/sul-dlss/purl-fetcher/tree/main/app/services/to_mods)
- [purl `app/controllers/purl_controller.rb`](https://github.com/sul-dlss/purl/blob/main/app/controllers/purl_controller.rb)
- [EDA 0019](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0019-description.md)

_Verified against default branches on 2026-11-16._
