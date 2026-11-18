---
status: accepted
---
# SDR QA publishes to stage access systems and shares stage storage

Access systems have no QA environment. These include purl-fetcher, purl, stacks, the image servers, SearchWorks and sul-embed. SDR QA therefore publishes into the **stage** access stack: DSA-qa and common-accessioning-qa point at `purl-fetcher-stage` and `sul-purl-stage`, and DSA-qa stages files on the same `/access-transfer-stage` mount as DSA-stage. QA and stage also share the `/dor` workspace export and the stage Goobi (`goobi-stage-a`). The maintainers confirm this is deliberate: access systems have no QA level, and pointing QA at stage still gives QA a full path from deposit to PURL. Inference: it also saves the access team from running a third environment.

## Considered options

- **A full QA access stack** (QA instances of purl-fetcher, purl, stacks and discovery). Not built.
- **QA that does not publish.** Not adopted, because QA could then not test publishing or the integration specs that check PURLs.

## Consequences

- QA and stage objects mix in stage purl, stacks (`stacks-test`) and stage discovery. QA tests can change what stage users and testers see, and the reverse is also true.
- A change to purl-fetcher or another access system cannot be tested against QA SDR alone. Stage is the first shared environment where it can be tested.
- Each level has its own SURI, and each SURI checks uniqueness only in its own database. Inference: druids stay distinct across QA and stage in the shared stores only because the druid space is very large.
- Because the workspaces under `/dor` are shared, QA and stage robots can see each other's files.

**Reconsider when:**
- QA and stage testing start to collide, for example over concurrent releases, data cleanup, or conflicting cocina-models versions during a lockstep upgrade ([ADR 0003](0003-cocina-shared-model-lockstep.md)).
- Access systems need a pre-stage environment of their own, for example for the planned purl-fetcher S3 writes ([ADR 0013](0013-weka-s3-read-path.md)).
- Stage access is refreshed or rebuilt, and QA's objects would be lost or orphaned.
- Infrastructure costs change, for example if containerization makes extra environments cheap ([ADR 0022](0022-argo-b3-containers-with-kamal.md)).

## Sources

- [shared_configs `dor-services-app-qa`](https://github.com/sul-dlss/shared_configs/blob/dor-services-app-qa/config/settings/production.yml)
- [shared_configs `common-accessioning-qa`](https://github.com/sul-dlss/shared_configs/blob/common-accessioning-qa/config/settings/production.yml)
- [puppet](https://github.com/sul-dlss/puppet) node data (private; DSA, common-accessioning and purl-fetcher-stage mounts)
- [suri-rails `app/models/identifier.rb`](https://github.com/sul-dlss/suri-rails/blob/main/app/models/identifier.rb)
- [Environments](../architecture/environments.md)

_Verified against default branches on 2026-11-16; private-source details redacted 2026-11-17._
