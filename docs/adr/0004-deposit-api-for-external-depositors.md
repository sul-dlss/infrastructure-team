---
status: accepted
date: 2020-02
---
# sdr-api is the deposit API for external and automated depositors

sdr-api (`POST /v1/resources`, `/v1/direct_uploads`, `/v1/auth/login|proxy`) is the deposit API for depositors outside the core SDR apps. These are google-books, Argo's Agreement uploads, the integration tests, and command-line users of sdr-client. Internal deposit front ends call DSA directly through dor-services-client: H3 (hungry-hungry-hippo), heracles-etd, pre-assembly and argo-b3. They need versioning, staging and workflow control that sdr-api does not expose, so they do not go through sdr-api.

## Considered options

- **Every deposit goes through sdr-api.** This was EDA 0006's intent: one validating "face" of SDR, which would also decouple apps such as ETD from SDR internals (EDA 0005). Not followed. The front ends that were rebuilt later (H3, heracles-etd, argo-b3) talk to DSA directly.

## Consequences

- Each internal front end re-implements file staging, version open/close and accession start against the DSA API. Changes to that orchestration must be made in several codebases.
- Validation happens in DSA (cocina-models), not at a separate API edge.
- sdr-api has few clients. When Argo is retired ([ADR 0023](0023-argo-b3-replaces-argo-and-pre-assembly.md)), the Agreement upload path disappears unless argo-b3 adopts it. The long-term role of sdr-api is an open question.

## History

Rewritten from EDA 0006 (Decided 2020-02-04, for the Google Books work cycle). Differences: the API was built and Google Books uses it, but it did not become the single entry point. EDA 0005 (ETD uses the deposit API) was never written, and the current ETD app calls DSA directly.

## Sources

- [sdr-api `config/routes.rb`](https://github.com/sul-dlss/sdr-api/blob/main/config/routes.rb)
- [hungry-hungry-hippo `app/jobs/deposit_work_job.rb`](https://github.com/sul-dlss/hungry-hungry-hippo/blob/main/app/jobs/deposit_work_job.rb)
- [heracles-etd `app/services/register_service.rb`](https://github.com/sul-dlss/heracles-etd/blob/main/app/services/register_service.rb)
- [EDA 0006](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0006-replace-assembly-wf-with-deposit-api.md), [EDA 0005](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0005-use-deposit-api-in-etd-application.md)
- [Management and deposit](../architecture/management-and-deposit.md)

_Verified against default branches on 2026-11-16._
