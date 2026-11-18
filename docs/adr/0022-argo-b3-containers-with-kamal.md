---
status: accepted
---
# Argo-B3 runs in Docker with Kamal; other SDR apps stay on VMs

Argo-B3 is the only SDR application that runs as containers in deployed environments. Kamal deploys a `web` role (Rails behind kamal-proxy on port 3000, fronted by the host's Apache and Shibboleth) and a `job` role (Solid Queue) onto Puppet-managed VMs where puppet installs Docker. The image is built on argo-b3-stage-a and pushed through Kamal's local registry over SSH, so no external registry is used. Every other SDR app is still deployed with Capistrano onto Puppet-managed VMs, running Passenger for web and systemd for Sidekiq, Sneakers and Racecar workers. Their Dockerfiles are used only for development and CI.

## Considered options

- **Kubernetes.** Not adopted. No SDR service runs on Kubernetes.
- **Containerize every SDR app now.** Not done. EDA 0016 suggested an incremental path, and so far Argo-B3, a new application, is the only step taken.
- **Images from a public registry (Docker Hub).** Not used. The image stays on SUL hosts.

## Consequences

- Two deployment models coexist. sdr-deploy handles both: `deployment_strategy: kamal` is set for argo-b3 only.
- Argo-B3 gets its settings from Kamal `config/deploy.*.yml` env plus Vault-backed secrets. It does not use a shared_configs branch, although the hosts' puppet node data still names an `argo-b3` shared_configs branch, which no longer exists. Shibboleth attributes reach the container as request headers (`X-Remote-User`, `X-Groups`).
- Puppet still manages the host, Apache and the NFS mounts. Containers bind-mount those paths, so the VMs are not disposable.

## History

Narrowed from EDA 0016 (drafted 2022-08, outcome "To be determined"). Differences: EDA framed containerization for all SDR apps and left the outcome open. What exists is a single app on Docker and Kamal on Puppet-managed hosts, a variant of EDA's "Docker on Puppet servers" option.

## Sources

- [argo-b3 `config/deploy.yml`](https://github.com/sul-dlss/argo-b3/blob/main/config/deploy.yml)
- [sdr-deploy `config/settings.yml`](https://github.com/sul-dlss/sdr-deploy/blob/main/config/settings.yml)
- [puppet](https://github.com/sul-dlss/puppet) (argo-b3 host node data)
- [EDA 0016](https://github.com/sul-dlss-labs/engineering-design-adrs/blob/main/0016-containerization.md)
- [Platform and operations](../architecture/platform-and-operations.md)

_Verified against default branches on 2026-11-16; private-source details redacted 2026-11-17._
