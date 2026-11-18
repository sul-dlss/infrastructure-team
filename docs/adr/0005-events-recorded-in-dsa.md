---
status: accepted
---
# Object events are recorded in DSA

Provenance and processing events for every object are stored in DSA's `events` table, not in a separate provenance service. Producers either send events asynchronously through dor-event-client, which publishes to the RabbitMQ exchange `sdr.objects.event` that DSA consumes from the queue `dsa.create-event`, or call `POST /v1/objects/:id/events`. Keeping events next to the objects avoids running another service and another database, and lets Argo show an object's history with a single DSA call.

## Considered options

- **Separate provenance service** (EDA 0009, GitHub issue #7). It was never designed or built.

## Consequences

- Robots and apps can report events without waiting on DSA, because events are fire-and-forget over RabbitMQ. If the consumer is down, events queue up in the broker instead of being lost.
- DSA emits its own event types itself, for example `version_open`, `publishing_complete` and `embargo_released` (`Event::EVENT_TYPES`).
- The events table grows with every workflow step and lives in the main DSA database.

## History

Rewritten from EDA 0009 (drafted 2019-10-31, never filled in). Differences: the EDA record proposed a provenance service. What was built is a DSA table and API, plus a RabbitMQ intake.

## Sources

- [DSA `app/models/event.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/models/event.rb)
- [DSA `lib/tasks/rabbitmq.rake`](https://github.com/sul-dlss/dor-services-app/blob/main/lib/tasks/rabbitmq.rake#L17-L19)
- [DSA `app/jobs/create_event_job.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/jobs/create_event_job.rb)
- [DSA `config/routes.rb` (events)](https://github.com/sul-dlss/dor-services-app/blob/main/config/routes.rb#L66)
- [dor-event-client](https://github.com/sul-dlss/dor-event-client)
- [EDA 0009](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0009-create-provenance-service.md)

_Verified against default branches on 2026-11-16._
