---
title: DLSS Infrastructure
---

# DLSS Infrastructure

Documentation for the Stanford Digital Repository (SDR), maintained by the DLSS Infrastructure team, and for the access and discovery systems that consume it.

- [SDR architecture](docs/architecture/index.md): overview, then one page per subsystem, with diagrams.
- [Data model](docs/architecture/data-model.md): cocina, identifiers, versions, and how an object's data moves from deposit to discovery.
- [Environments](docs/architecture/environments.md).
- [Architecture decision records](docs/adr/README.md).
- [History and lessons learned](docs/architecture/history-and-lessons.md).
- [Recommendations](docs/architecture/recommendations.md): suggested architectural changes and opportunities to improve.
- [Open questions](docs/architecture/open-questions.md).
- [Glossary](GLOSSARY.md).

End-to-end behavior is exercised by [infrastructure-integration-test](https://github.com/sul-dlss/infrastructure-integration-test), which developers run against a deployed environment.
