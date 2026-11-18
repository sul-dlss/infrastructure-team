---
status: accepted
date: 2023-09
---
# DSA offers a GraphQL endpoint for partial cocina retrieval

DSA exposes `POST /graphql` (graphql-ruby) so that a client can fetch only part of a cocina object, for example without its file list. It was added for Argo: an item with 5,000 files took about 12 seconds to render, because Argo fetched, validated and transferred the full object several times per page. With partial retrieval, rendering takes under a second. The client method is `Dor::Services::Client::Object#find_lite`.

## Considered options

- **Extend the REST endpoints with partial retrieval.** Rejected because GraphQL provides partial retrieval natively and graphql-ruby made it cheap to add. Either form of partial retrieval needed cocina-models changes so that objects could omit required attributes, such as the structural metadata.
- **Cache cocina objects in Argo** to cut the number of fetches. Not chosen.

## Consequences

- Argo is the only consumer. argo-b3 does not call `find_lite`. When Argo is retired ([ADR 0023](0023-argo-b3-replaces-argo-and-pre-assembly.md)), the endpoint will have no users and can be removed unless another client adopts it.
- It adds a second API style to an already large DSA codebase.

## History

Rewritten from EDA 0018 (accepted 2023-09-01). Differences: none in the design. The prospect of reuse by other clients did not happen.

## Sources

- [DSA `config/routes.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/config/routes.rb#L11)
- [DSA `app/graphql/`](https://github.com/sul-dlss/dor-services-app/tree/main/app/graphql)
- [dor-services-client `lib/dor/services/client/object.rb`](https://github.com/sul-dlss/dor-services-client/blob/main/lib/dor/services/client/object.rb)
- [argo `app/models/repository.rb`](https://github.com/sul-dlss/argo/blob/main/app/models/repository.rb)
- [EDA 0018](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0018-graphql.md)

_Verified against default branches on 2026-11-16._
