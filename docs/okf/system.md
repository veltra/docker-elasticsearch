---
type: System
title: Elasticsearch Docker Image
description: Custom Elasticsearch 6.2.4 OSS Docker image with ICU and Kuromoji analysis plugins pre-installed, for Veltra services that need full-text (incl. Japanese) search.
resource: likec4://veltra/docker_elasticsearch
tags: [veltra, infrastructure, search, docker, generated]
status: maintenance   # last commit on the default branch 2018-05-23 (3f1e63e); one unmerged branch origin/add-readme dated 2025-07-25 (cffb90e) — see Open questions
owners: []            # no CODEOWNERS or owner statement in the repo
timestamp: 2026-08-21T21:20:48+00:00
generated_by: claude-fable-5 / layered-docs 2026-08
source_commit: 3f1e63efae6af225d91c11f0a705be3c7de60293
source_branch: allium/layered-docs-2026-08
generated_at: 2026-08-21T21:20:48+00:00
confidence: high
review_status: draft-needs-review
links:
  repository: https://github.com/veltra/docker-elasticsearch
  architecture: ../architecture/docker_elasticsearch.c4
---

# Elasticsearch Docker Image

## Purpose
Provides a single custom Docker image, built as `veltra/elasticsearch` (`Makefile` build target), that extends the official Elasticsearch 6.2.4 OSS image with the `analysis-icu` and `analysis-kuromoji` plugins (`Dockerfile`). Kuromoji is Elasticsearch's Japanese morphological analyzer and ICU adds Unicode-aware text handling, so the image exists to give downstream services an Elasticsearch node ready for Japanese/Unicode full-text search out of the box.

> Unverified: which services consume this image is not stated anywhere in the repository.

## Capabilities
- Builds an Elasticsearch 6.2.4 OSS server image — evidence: `Dockerfile`
- Ships the `analysis-icu` plugin (Unicode/ICU text analysis) — evidence: `Dockerfile`
- Ships the `analysis-kuromoji` plugin (Japanese morphological analysis) — evidence: `Dockerfile`
- Smoke-testable as a single node on port 9200 — evidence: `Makefile` (test target: `discovery.type=single-node`, curl against `http://localhost:9200`)

## Interfaces
**Inbound:** Elasticsearch HTTP API on port 9200 when a container is run (the `Makefile` test target maps 9200 and curls it with basic auth). No other interfaces are defined in this repo.
**Outbound:** none at runtime evidenced in this repo. At build time the image pulls its base image from the Elastic Docker registry (`Dockerfile` FROM line) and plugins via `elasticsearch-plugin install`.

## Dependencies
- `docker.elastic.co/elasticsearch/elasticsearch-oss:6.2.4` base image — foundation of the image — evidence `Dockerfile`
- `analysis-icu`, `analysis-kuromoji` Elasticsearch plugins — text analysis — evidence `Dockerfile`
- CircleCI — builds and smoke-tests on each commit — evidence `.circleci/config.yml`, `README.md` badge
- `appropriate/curl` image — runs the smoke-test curl against the started node — evidence `Makefile` line 10
- `docker:17.07.0-ce-git` image — CircleCI executor for the build/test job — evidence `.circleci/config.yml` line 6
- `.env` file (git-tracked) supplying `ELASTICSEARCH_USERNAME` / `ELASTICSEARCH_PASSWORD` used by the Makefile test curl — evidence `Makefile` (contents of `.env` intentionally not inspected here)

## Data & storage
No datastore configuration beyond Elasticsearch's own defaults is present; the repo defines no volumes, index templates or snapshots. One historical config tweak (`configsync.flush_interval`) was removed with the 6.2.4 upgrade (git history, commit 99a907d).

## Operations
- Build: `make build` → `docker build -t veltra/elasticsearch .` — evidence `Makefile`
- Test: `make test` runs the image single-node and curls port 9200 with retries — evidence `Makefile`
- CI: CircleCI runs `make build` then `make test` inside a `docker:17.07.0-ce-git` executor with remote Docker — evidence `.circleci/config.yml`
- Publishing: no `docker push` step exists in the Makefile or CI config; how the image reaches a registry is not evidenced.

## Behaviour (Allium)
none — no `.allium` specs exist in this repository (`git ls-files` shows only Dockerfile, Makefile, CI config, README, .env, .gitignore).

## Decisions
- [ADR-0001 Custom Elasticsearch image with ICU and Kuromoji analysis plugins](decisions/ADR-0001-custom-image-with-icu-kuromoji-plugins.md)
- [ADR-0002 Upgrade to Elasticsearch 6.2.4 on the OSS distribution](decisions/ADR-0002-upgrade-to-elasticsearch-6-2-4-oss.md)
- [ADR-0003 Config Sync plugin adopted, then dropped at the 6.2.4 upgrade](decisions/ADR-0003-config-sync-plugin-adopted-then-dropped.md)

## Evidence
- `Dockerfile` — base image and plugin installs
- `Makefile` — build/test commands, image name, port, env-var names
- `.circleci/config.yml` — CI pipeline
- `README.md` — project name and CircleCI badge
- git history (`git log`, e.g. commits 99a907d, fddb7ae, f80688a, 72ec66b) — decision trail

## Open questions
- Unverified: which Veltra services consume this image, and via which registry it is distributed (no push step in repo).
- Unverified: whether the image is still in active use. `status: maintenance` is an inference from git history, not a stated fact: the default branch (`master`) last moved on 2018-05-23 (`3f1e63e`), while `git log --all` shows one unmerged branch `origin/add-readme` with a 2025-07-25 commit (`cffb90e`, "Add README generated by AI"). Whether that branch signals renewed use of the image is not evidenced.
- Unverified: the host from which `elasticsearch-plugin install` fetches `analysis-icu` and `analysis-kuromoji` at build time — the command names no registry (`Dockerfile` lines 2-3), so the plugin artifact source is modelled as an unnamed external.
- Unverified: owners/maintainers — nothing stated in the repo.
