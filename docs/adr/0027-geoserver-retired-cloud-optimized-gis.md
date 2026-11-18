---
status: accepted
date: 2026-04
---
# GeoServer is retired; GIS data is served as cloud-native files from stacks

SDR no longer loads GIS data into GeoServer and PostGIS or serves it over WMS/WFS. gisDerivativeWF instead generates static, cloud-native derivatives: Cloud-Optimized GeoTIFF (COG) for rasters, PMTiles and FlatGeobuf for vectors, plus JP2. These are shelved to stacks like any other file. EarthWorks maps SDR records to purl, IIIF and stacks file references, and viewers fetch the derivative files from stacks. GeoServer needed a separate server tier, a PostGIS database, a delivery workflow for every object, and a stacks geo proxy for restricted layers. Serving files from stacks removes all of that and reuses the existing access path and its rights checks ([ADR 0015](0015-stacks-enforces-rights-per-request.md)).

## Considered options

- **Keep GeoServer (WMS/WFS) for SDR layers.** Retired between 2024-04 and 2026-08. reload-geoserver was removed (2024-04), gisDeliveryWF robots were removed (2026-04), the geoserver hosts were decommissioned (2026-06), and the stacks geo proxy was removed (2026-07).

## Consequences

- SDR no longer offers OGC services for its GIS layers. EarthWorks' WMS/WFS code snippets apply only to harvested OpenGeoMetadata records that carry other institutions' endpoints.
- Cleanup remains:
  - DSA still ships `config/workflows/gisDeliveryWF.xml`.
  - puppet still provisions PostGIS and a `geoserver` database on the two prod EarthWorks database hosts, and `postgis` on the robots hosts.
  - shared_configs earthworks-stage still has `proxy_url` and `restricted_url` keys pointing at a decommissioned geoserver host.
  - The `sw-indexing-*` `processes:` block still names the two decommissioned stage geoserver hosts.

## Sources

- [gis-robot-suite `lib/robots/dor_repo/gis_derivative/create_derivatives.rb`](https://github.com/sul-dlss/gis-robot-suite/blob/main/lib/robots/dor_repo/gis_derivative/create_derivatives.rb)
- [gis-robot-suite PR #1052 "Remove the gisDeliveryWF"](https://github.com/sul-dlss/gis-robot-suite/pull/1052)
- [earthworks `app/services/cocina_to_solr_mapper.rb`](https://github.com/sul-dlss/earthworks/blob/main/app/services/cocina_to_solr_mapper.rb)
- [stacks PR #1597 "Remove the geo proxy"](https://github.com/sul-dlss/stacks/pull/1597)
- [DSA `config/workflows/gisDeliveryWF.xml`](https://github.com/sul-dlss/dor-services-app/blob/main/config/workflows/gisDeliveryWF.xml)
- [Access and discovery](../architecture/access-and-discovery.md)

_Verified against default branches on 2026-11-16; private-source details redacted 2026-11-17._
