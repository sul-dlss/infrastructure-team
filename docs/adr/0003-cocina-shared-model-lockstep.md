---
status: accepted
---
# Cocina is the shared data model, upgraded in lockstep

Cocina, implemented by the `cocina-models` gem, is the single data model for SDR objects. Every app that creates, validates or transforms objects depends on the same gem version. A cocina-models release is therefore deployed to all of those apps together, as a coordinated release, and no app tolerates an older or newer schema. This keeps validation strict and identical everywhere, at the cost of a coordinated multi-app deploy for every model change.

## Considered options

- **Versioned or tolerant schema between services.** Each service would accept older or newer cocina. Not adopted: it would need version negotiation and compatibility code in every client, and validation would drift between apps.

## Consequences

- sdr-deploy marks the repositories that need lockstep upgrades (`cocina_models_update: true`). These are argo, argo-b3, common-accessioning, dor-services-app, gis-robot-suite, google-books, heracles-etd, hungry-hungry-hippo, pre-assembly, sdr-api, was-registrar-app and was_robot_suite.
- `bin/sdr check_cocina` halts a deploy when the major or minor versions diverge. Release tags are created with `-c` so that only cocina-dependent repos are included.
- The release checklist turns Google Books off in prod before a cocina-models deploy, so that deposits do not fail against a half-upgraded fleet.
- purl-fetcher also depends on cocina-models but is tagged and deployed separately (see [Platform and operations](../architecture/platform-and-operations.md)).
- The gem also carries the MARC → MODS → cocina ingest mapping, so changes to that mapping go through the same lockstep release.

## Sources

- [sdr-deploy `config/settings.yml`](https://github.com/sul-dlss/sdr-deploy/blob/main/config/settings.yml)
- [sdr-deploy `README.md` (check_cocina, tag create `-c`)](https://github.com/sul-dlss/sdr-deploy/blob/main/README.md)
- [cocina-models](https://github.com/sul-dlss/cocina-models)
- [Data model](../architecture/data-model.md)

_Verified against default branches on 2026-11-16._
