---
status: accepted
---
# Staff authorization uses Shibboleth and Workgroup Manager entitlements

SDR web apps do not keep their own user or password store. Apache with Shibboleth authenticates the person, and Stanford Workgroup Manager groups, released as `eduPersonEntitlement`, decide access. Apache gates each app on an entitlement: `sdr:argo-access` for Argo and Argo-B3, `sdr:accessioning` for pre-assembly, and `sdr:administrator-role` for DSA's `/queues`. The app reads the user and groups from the request environment (Argo) or from forwarded headers (`X-Remote-User`, `X-Groups` into the Argo-B3 container). Within an app, roles such as `sdr:administrator-role`, `sdr:manager-role` and `sdr:viewer-role`, together with APO role assignments (`dor-apo-manager`, `dor-apo-depositor`, …, with sunetid or workgroup members), decide what a user may do with each object. Inference on the rationale: group membership is managed in one place, and people join and leave through existing university processes.

## Considered options

- **App-local accounts or role tables.** Not used for authentication. H3 keeps collection-level roles in its own database, but it still authenticates through Shibboleth.
- **An OAuth/OIDC gateway in front of SDR.** Not adopted, and there is no record that it was considered.

## Consequences

- Access depends on the IdP releasing attributes and on workgroups being administered outside any codebase. A user whose entitlement is missing is turned away by Apache before the app sees the request, so the app has no record of the failure to troubleshoot.
- Permissions are partly data: APO roles live in cocina, so who can manage an object is decided when the APO is edited, not by code.
- Admins can impersonate workgroups in Argo-B3 to see what other users see.
- Service-to-service calls use JWTs instead ([ADR 0007](0007-jwt-for-service-auth.md)).

## Sources

- [puppet](https://github.com/sul-dlss/puppet) (Apache entitlement gates for Argo and Argo-B3)
- [argo `app/models/user.rb`](https://github.com/sul-dlss/argo/blob/main/app/models/user.rb)
- [argo-b3 `app/controllers/concerns/authentication.rb`](https://github.com/sul-dlss/argo-b3/blob/main/app/controllers/concerns/authentication.rb)
- [Management and deposit](../architecture/management-and-deposit.md), [Data model](../architecture/data-model.md)

_Verified against default branches on 2026-11-16; private-source details redacted 2026-11-17._
