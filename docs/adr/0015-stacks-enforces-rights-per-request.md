---
status: accepted
---
# Stacks checks rights on every file request against purl's public cocina

Stacks, which serves files, IIIF image access and media tokens, keeps no rights database. On each request it fetches the object's public cocina from purl, caches it for 10 minutes, and evaluates access with `CocinaAbility`. The URL is `https://purl.stanford.edu/<druid>.json`, or `/<druid>/version/<n>.json` for a specific version. Access can be world, Stanford, location-based or none, and can include an embargo. For streaming media, stacks mints a Wowza SecureToken URL only after this check passes. Because purl's public JSON is the only source of rights, a newly published version takes effect without a separate push to stacks.

## Considered options

- **Stacks keeps its own rights store, updated at publish time.** Not built. It would need a second write path from purl-fetcher and a way to keep the two copies consistent.

## Consequences

- purl is a hard runtime dependency of stacks. A purl outage blocks access to every file that is not already cached.
- A change to rights, such as making an item dark or lifting an embargo, can take up to about 10 minutes to reach stacks.
- Stacks does not apply embargo dates itself. It reports embargo status, and DSA performs the release ([ADR 0017](0017-embargo-release-opens-version.md)).
- Stacks has no database, which keeps it simple to scale and deploy.

## Sources

- [stacks `app/models/cocina.rb`](https://github.com/sul-dlss/stacks/blob/main/app/models/cocina.rb#L11)
- [stacks `app/models/cocina_ability.rb`](https://github.com/sul-dlss/stacks/blob/main/app/models/cocina_ability.rb)
- [stacks `app/models/wowza_secure_token.rb`](https://github.com/sul-dlss/stacks/blob/main/app/models/wowza_secure_token.rb)
- [Access and discovery](../architecture/access-and-discovery.md)

_Verified against default branches on 2026-11-16._
