---
status: accepted
date: 2023-02
---
# Robots are Sidekiq workers built on lyber-core

Workflow steps ("robots") are Sidekiq Pro jobs. `LyberCore::Robot` includes `Sidekiq::Job`, and each robot class maps to one step. DSA's workflow engine pushes a job for each ready step onto a named queue, `<workflow>[_<process>]_<lane>[_dsa]`, for example `accessionWF_shelve_default_dsa` or `assemblyWF_low`. Resque was replaced because the robots were its last user in the portfolio, few people knew it well, and it had no retries.

## Considered options

- **Consolidate all robots into one repository.** This was EDA 0017's original proposal. Rejected at the time: robots stayed in common-accessioning, preservation_robots, gis-robot-suite and was_robot_suite.

## Consequences

- Robots were later partly consolidated anyway, into DSA rather than into a single robots repository. Steps that only need DSA's own data run inside DSA as `Robots::Robot < LyberCore::Robot`: publish, shelve, reset-workspace, sdr-ingest-transfer, update-doi, update-orcid-work, goobi-notify and the releaseWF steps. Their queues end in `_dsa`.
- Queue names encode the workflow, the process (accessionWF only) and the lane. Some steps are special-cased to throttle them: `assemblyWF_jp2` and `releaseWF_update-marc_dsa`. Operators scale or pause work per queue.
- Robots can retry through Sidekiq, but only for the exceptions each robot declares as `retriable_exceptions`. When those retries are exhausted, the step is set to `error`. Any other failure errors the step immediately.

## History

Rewritten from EDA 0017 (accepted 2023-02-01). Differences: the decision to keep robots in separate repositories was later partly reversed by moving DSA-centric steps into DSA, which was never recorded.

## Sources

- [lyber-core `lib/lyber_core/robot.rb`](https://github.com/sul-dlss/lyber-core/blob/main/lib/lyber_core/robot.rb)
- [DSA `app/services/queue_service.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/services/queue_service.rb)
- [DSA `app/jobs/robots/robot.rb`](https://github.com/sul-dlss/dor-services-app/blob/main/app/jobs/robots/robot.rb)
- [EDA 0017](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0017-robots-sidekiq.md)
- [Accessioning](../architecture/accessioning.md)

_Verified against default branches on 2026-11-16._
