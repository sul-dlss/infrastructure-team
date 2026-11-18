---
status: accepted
date: 2025-05
---
# The workflow engine lives in DSA

The workflow service (workflow-server-rails) was merged into DSA. DSA now holds the workflow templates (`config/workflows/*WF.xml`), the step-state API (`/v1/objects/:druid/workflows/...`, `/lifecycles`) and the logic that enqueues the next steps. The existing workflow database stays as a second Rails database (`workflow`). Before the merge, most calls to the workflow service came from DSA's indexing, and most RabbitMQ messages existed only to trigger indexing. Merging removed those calls and messages, and it needed no data migration.

## Considered options

- **Keep the standalone workflow service**, or **rewrite the workflow system more substantially.** EDA 0023 rejected both in favour of the smaller merge.

## Consequences

- workflow-server-rails (archived 2025-09) and dor-workflow-client (archived 2025-08) are gone. Clients use the workflow methods in dor-services-client.
- After every step update, DSA synchronously reindexes the object in Solr ([ADR 0010](0010-dsa-writes-argo-index.md)). This slows each step but avoids a flood of reindex jobs. The last accessionWF step also sleeps one second to reduce out-of-order Solr commits.
- DSA pushes robot jobs straight onto the robots' Sidekiq queues ([ADR 0009](0009-robots-as-sidekiq-workers.md)), and it publishes `sdr.workflow` messages for errors and for the end of accessioning.
- Workflow availability is now DSA availability ([ADR 0002](0002-dsa-postgres-system-of-record.md)). EDA 0023 accepted that workflow operations are less visible inside a larger monolith.
- Stale `workflow.url` settings remain in some shared_configs branches and should be removed.

## History

Rewritten from EDA 0023 (proposed 2025-05-16, status left as "proposed"). Differences: none in substance; it was built as proposed. The EDA front matter's `title: Template` mislabels it in that site's navigation.

## Sources

- [DSA `config/database.yml`](https://github.com/sul-dlss/dor-services-app/blob/main/config/database.yml)
- [DSA `config/routes.rb` (workflows)](https://github.com/sul-dlss/dor-services-app/blob/main/config/routes.rb#L90-L102)
- [DSA `app/services/workflow/next_step_service.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/services/workflow/next_step_service.rb)
- [DSA `config/workflows/`](https://github.com/sul-dlss/dor-services-app/tree/main/config/workflows)
- [EDA 0023](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0023-merge-workflow-service.md)
- [Accessioning](../architecture/accessioning.md)

_Verified against default branches on 2026-11-16._
