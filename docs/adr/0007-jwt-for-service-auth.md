---
status: accepted
date: 2020-04
---
# JWTs authenticate inter-service API calls

SDR service APIs authenticate callers with JSON Web Tokens. Each service holds an HMAC secret and mints tokens for its clients, and the clients send a token as a bearer token on every request. Network restrictions still apply, but they are no longer the only control. Industry practice and Stanford UIT had both moved away from relying on IP allow-listing alone.

## Consequences

- Most services verify HS256: DSA, purl-fetcher, technical-metadata-service, sdr-api, and stacks' service tokens. preservation_catalog verifies HS512. Tokens minted for one service do not work for another.
- There is no central issuer. Each service's secret signs all of its tokens, so revoking one client means rotating that service's secret and re-issuing tokens to all of its other clients.
- Some read endpoints are deliberately unauthenticated, for example purl-fetcher `GET /v1/purls/:druid`.
- People authenticate differently, through Shibboleth ([ADR 0026](0026-shibboleth-entitlements-for-authz.md)). sdr-api bridges the two with `/v1/auth/proxy`.

## History

Rewritten from EDA 0011 (drafted 2020-04, team consensus; status left as "drafted"). Differences: none in substance. preservation_catalog's HS512 variant and the unauthenticated read endpoints are not mentioned in EDA.

## Sources

- [DSA `app/controllers/application_controller.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/controllers/application_controller.rb#L65)
- [purl-fetcher `app/controllers/concerns/authenticated.rb`](https://github.com/sul-dlss/purl-fetcher/blob/main/app/controllers/concerns/authenticated.rb#L22)
- [preservation_catalog `app/controllers/api_controller.rb`](https://github.com/sul-dlss/preservation_catalog/blob/main/app/controllers/api_controller.rb#L41)
- [sdr-api `app/models/json_web_token.rb`](https://github.com/sul-dlss/sdr-api/blob/main/app/models/json_web_token.rb)
- [EDA 0011](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0011-use-api-tokens.md)

_Verified against default branches on 2026-11-16._
