# infrastructure-team

Architecture documentation for the Stanford Digital Repository (SDR) and the systems that consume it. Published via GitHub Pages at https://sul-dlss.github.io/infrastructure-team/. Start at [`index.md`](index.md).

## Layout

- `docs/architecture/`: architecture pages.
- `docs/adr/`: architecture decision records, indexed in `docs/adr/README.md`.
- `docs/diagrams/`: Mermaid sources (`.mmd`) and the SVGs rendered from them.
- `GLOSSARY.md`: SDR terms.
- `scripts/`: the diagram renderer.

## Updating diagrams

Edit a `.mmd` file, then render it to the `.svg` beside it and commit both:

```sh
npm install
npm run diagrams                               # all diagrams
npm run diagrams docs/diagrams/core-rabbitmq.mmd   # one diagram
```

Rendering uses a local Chrome or Chromium if puppeteer's own browser isn't installed; set `PUPPETEER_EXECUTABLE_PATH` to choose one.

## Conventions

- Cite sources as links to default-branch files in GitHub, and record the date the page was verified.
- This repository is public. Information that is only in private repositories (puppet, shared_configs, operations-tasks, DevOpsDocs and others) needs explicit approval before it is published here, item by item. Linking to a private repository by name is fine.
  - Approved: shared_configs branch names, setting and environment variable *names*, and hostnames or URLs that already appear in a public repository.
  - Not published: other hostnames, storage export and mount details (describe storage only at a high level), puppet classes, hiera keys and facts, config values, cloud bucket names, Kafka topic names, network names, puppet access groups, and Weka details beyond what public repositories show.
- Never include secrets, credentials, tokens, IP addresses, or personal usernames.
- Record decisions that are hard to reverse, surprising without context, and the result of a real trade-off as ADRs. Update an ADR's status when what's built changes.
