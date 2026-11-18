---
status: accepted
date: 2026-11
---
# Record SDR architecture decisions here

SDR architecture decisions are recorded in this directory as short Markdown ADRs, one decision per file, numbered in sequence. The engineering-design-adrs (EDA) repository is kept as a historical record and receives no new ADRs. EDA had stopped matching the running system: statuses were never updated after work shipped, numbers collided, and most of the large decisions were never written down.

## Considered options

- **Revive EDA (MADR template).** Rejected. Its long template encouraged empty placeholders: EDA 0005, 0007, 0008 and 0009 are unfilled templates. Several hand-assigned numbers collide with open or closed drafts (PRs #37, #47 and #54).
- **Per-repository ADRs only.** Rejected. Most SDR decisions span several repositories, for example publish (DSA plus purl-fetcher) and preservation (DSA plus preservation_catalog).

## Consequences

- Each ADR records what was actually built, not only what was proposed. An ADR rewritten from EDA says so in its History section and lists how the built system differs from the proposal.
- When a decision is reversed, write a new ADR and set the old one's status to `superseded by ADR-NNNN`. Do not edit the old decision text.
- Keep ADRs to decisions that are hard to reverse, surprising without context, and involve a real trade-off. Conventions and runbooks belong in repository READMEs.
- Three EDA drafts are still open and have no decision: PR #33 (0014 cocina tweaks), PR #47 (indexing status) and PR #54 (cocina titles). If they are adopted, write them up here under new numbers.

## History

Rewritten from EDA 0000 (decided 2020-01-28). Differences: the format is a short front-matter ADR instead of MADR, and the record lives in infrastructure-team instead of EDA.

## Sources

- [EDA 0000 Use MADR](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0000-use-madr-as-record-format.md)
- [engineering-design-adrs](https://github.com/sul-dlss-labs/engineering-design-adrs)
- [Disregarded EDA ADRs](README.md#disregarded-eda-adrs)

_Verified against default branches on 2026-11-16._
