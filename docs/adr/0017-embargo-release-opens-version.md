---
status: accepted
---
# Embargo release opens a new object version

DSA lifts embargoes by editing the object. A nightly cron job (`rake dsa:embargo_release`) finds objects whose head version has an `access.embargo.releaseDate` in the past. For each one, it opens a new version ("embargo released"), copies the embargo's post-release access onto the object and its files, and closes the version. Closing the version runs accessionWF, which republishes and re-preserves the object. Access systems therefore only ever see the current rights in the published cocina, and never have to evaluate embargo dates themselves ([ADR 0015](0015-stacks-enforces-rights-per-request.md)).

## Considered options

- **Evaluate embargo dates at access time** in stacks, purl and the indexers. Not adopted. Every reader would need date logic, and discovery indexes would go stale when an embargo passed.

## Consequences

- Each lift creates a new object version and runs a full accessioning, including preservation and publishing, so many lifts on the same date cause a burst of load.
- The job skips an object that is not fully accessioned or cannot be opened, for example because a version is already open. It does not report the skip. Inference: the object is picked up again on a later nightly run once it can be opened.
- Each lift records an `embargo_released` event and publishes `sdr.objects.embargo_lifted` on RabbitMQ. That message has no known consumer ([ADR 0006](0006-rabbitmq-for-events-kafka-for-discovery.md)).

## Sources

- [DSA `app/services/embargo_release_service.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/services/embargo_release_service.rb)
- [DSA `config/schedule.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/config/schedule.rb)
- [Repository core](../architecture/repository-core.md)

_Verified against default branches on 2026-11-16._
