---
type: System
title: Elasticsearch image (Japanese search)
description: Dockerfile and CI for the organisation Elasticsearch container image — Elastic OSS 6.2.4 with the ICU and Kuromoji analysis plugins.
resource: likec4://veltra/docker_elasticsearch
tags: [veltra, search, infrastructure, generated]
status: maintenance
owners: []
timestamp: 2026-09-11T07:47:05Z
generated_by: claude-opus-5 / layered-docs 2026-09
source_commit: 3f1e63efae6af225d91c11f0a705be3c7de60293
source_branch: docs/layered-2026-09
generated_at: 2026-09-11T07:47:05Z
confidence: low
review_status: draft-needs-review
links:
  repository: https://github.com/veltra/docker-elasticsearch
  architecture: ../architecture/docker_elasticsearch.c4
---

# Elasticsearch image (Japanese search)

## Purpose
This repository is a three-line image definition: it takes the official Elastic OSS Elasticsearch
6.2.4 image and installs the `analysis-icu` and `analysis-kuromoji` plugins (`Dockerfile`), producing
an Elasticsearch image with Japanese and Unicode text analysis available by default. The image is
tagged locally as an organisation-namespaced `elasticsearch` image by the build target (`Makefile`).

No consumer of the image is named inside this repository, and the repository contains no index
templates, mappings, analyzer settings or cluster configuration — only the image build and a smoke
test. Who runs the resulting image, and where, is not evidenced here (see Open questions).

## Capabilities
- Build an Elasticsearch image with ICU and Kuromoji analysis plugins preinstalled — evidence: `Dockerfile`
- Build the image locally under an organisation image tag — evidence: `Makefile` (`build` target)
- Smoke-test the built image: run a single-node container with the HTTP API on port 9200 and probe it with curl over basic auth — evidence: `Makefile` (`test` target)
- Run that build and smoke test in CircleCI as a single `build` job — no workflows, branch or tag filters are declared, so the CircleCI default trigger applies — evidence: `.circleci/config.yml:1-25`, CI badge (`README.md:1`)

## Interfaces
**Inbound:** the Elasticsearch HTTP API on port 9200, published by the smoke-test container run
(`Makefile`); no application code, routes or CLI of this repository's own.
**Outbound:** none at runtime in this repository. At build time it pulls the
`docker.elastic.co/elasticsearch/elasticsearch-oss:6.2.4` base image (`Dockerfile:1`) and runs two
`elasticsearch-plugin install` commands (`Dockerfile:2-3`); those commands carry no host, so where the
plugin artefacts are fetched from is not evidenced here.

## Dependencies
- Elastic Docker registry (`docker.elastic.co`) — source of the pinned base image only — evidence `Dockerfile:1`
- Docker Hub (public image registry) — source of the unqualified `appropriate/curl` smoke-test image and the `docker:17.07.0-ce-git` CI executor image; the smoke test cannot run without it — evidence `Makefile:10`, `.circleci/config.yml:6`
- CircleCI — builds and smoke-tests the image — evidence `.circleci/config.yml:1-25`
- Docker CLI and GNU make — the only build tooling — evidence `Makefile`, `.circleci/config.yml` (`apk add bash curl make`)

## Data & storage
The image itself holds no data. A container started from it is an Elasticsearch node with its
default on-container data path; the smoke test starts it with `discovery.type=single-node` and keeps
no volume, so the data is discarded with the container (`Makefile`). No index or mapping definitions
exist in the repository.

## Operations
Built with `make build` (`docker build`) and verified with `make test`, which starts the container
detached on port 9200, waits, then runs a curl container on the same network namespace with
`--retry 10 --retry-connrefused` and basic-auth credentials supplied as make variables
(`Makefile`). CircleCI runs both targets on a remote Docker executor (`.circleci/config.yml`).
The credentials for the smoke test are read from a tracked `.env` file included by the `Makefile`;
its contents were deliberately not read for this document.
No registry push, deployment manifest, compose file, Kubernetes manifest or Terraform exists in the
repository, so how the image reaches a running environment is not evidenced. Nothing in the
repository evidences a deployment: the CI job's only steps are checkout, `make build` and `make test`
(`.circleci/config.yml:1-25`), and `Makefile:6` is a local `docker build -t` with no `docker push`.

> Unverified: the frontmatter `status: maintenance` is not stated anywhere in the repository. The
> clone holds a single commit (`3f1e63e`), and there is no CHANGELOG, release note, deprecation note
> or README prose beyond the title and CI badge (`README.md:1`), so no lifecycle state is evidenced;
> the value is inferred from the 6.2.4 pin and the CircleCI v2 configuration. Confidence: low.

## Behaviour (Allium)
none — no accepted Allium specification exists for this repository (no `.allium` files tracked at `3f1e63e`).

## Decisions
- [ADR-0001 Pin the Elastic OSS 6.2.4 base image](decisions/ADR-0001-pin-elasticsearch-oss-6-2-4.md)
- [ADR-0002 Bake the ICU and Kuromoji analysis plugins into the image](decisions/ADR-0002-bake-japanese-analysis-plugins.md)
- [ADR-0003 Verify the image with a CircleCI build-and-curl smoke test](decisions/ADR-0003-circleci-build-and-smoke-test.md)

## Evidence
- `Dockerfile` — base image and the two plugin installs
- `Makefile` — build target, smoke-test target, port 9200, basic-auth probe, `.env` include
- `.circleci/config.yml` — CI job: checkout, remote Docker, `make build`, `make test`
- `README.md` — repository title and CircleCI status badge
- `git log` at `3f1e63e` — merge of pull request #2 from branch `es-6.2.4`
- `git ls-files` at `3f1e63e` — the repository tracks six files in total: `.circleci/config.yml`, `.env`, `.gitignore`, `Dockerfile`, `Makefile` and `README.md`

## Open questions
- Which services consume this image, and in which environment it runs, is not evidenced in this repository — confidence: low.
- Whether the image is pushed to a registry (and to which one) is not evidenced; only a local `docker build -t` is present — confidence: low.
- Index templates, mappings and analyzer definitions live elsewhere; their location is not evidenced here — confidence: low.
- The pinned Elasticsearch version 6.2.4 is long out of support upstream; whether this is intentional or the repository is dormant is not evidenced (single commit visible in the clone) — confidence: low.
- A `.env` file is tracked in the repository and supplies the smoke-test credentials; whether those are real credentials should be reviewed by a human — not inspected here.
- `README.md:1` embeds a CircleCI status token as a query parameter in the badge URL, committed to the repository; a human should confirm whether it needs rotating — value not inspected or reproduced here.
- Where `elasticsearch-plugin` fetches `analysis-icu` and `analysis-kuromoji` from is not evidenced: `Dockerfile:2-3` name no host — confidence: low.
- The lifecycle status in the frontmatter is inferred, not evidenced (see Operations) — confidence: low.
- The external ids used in the architecture model for the Elastic Docker registry and Docker Hub are newly coined for this repository; they may need reconciling with the ids other repositories use for the same systems — confidence: low.
