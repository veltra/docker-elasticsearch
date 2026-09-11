---
type: Architecture Decision
title: ADR-0001 Pin the Elastic OSS 6.2.4 base image
description: The image is built from docker.elastic.co/elasticsearch/elasticsearch-oss:6.2.4, an exactly pinned OSS-distribution tag.
status: accepted
date: unknown
deciders: []
supersedes: []
affects: [docker_elasticsearch, docker_elasticsearch.search_node]
allium: []
evidence: ["Dockerfile", "git log 3f1e63e — Merge pull request #2 from veltra/es-6.2.4"]
tags: [veltra, adr, generated]
timestamp: 2026-09-11T07:47:05Z
generated_by: claude-opus-5 / layered-docs 2026-09
source_commit: 3f1e63efae6af225d91c11f0a705be3c7de60293
source_branch: docs/layered-2026-09
generated_at: 2026-09-11T07:47:05Z
confidence: medium
review_status: draft-needs-review
---

# ADR-0001 Pin the Elastic OSS 6.2.4 base image

## Context
The repository exists to produce one Elasticsearch image. The base image choice fixes both the
engine version and the licensing distribution. The only commit reachable in the clone at
`3f1e63e` is the merge of pull request #2 from the branch `es-6.2.4`, whose name states that the
change was the move to that version.

## Decision
Build from `docker.elastic.co/elasticsearch/elasticsearch-oss:6.2.4` — the Apache-licensed OSS
distribution, at an exact patch tag rather than a floating `6.x` or `latest` tag (`Dockerfile`).

## Consequences
- The two plugin installs in the same `Dockerfile` are unversioned (`Dockerfile:2-3`): no plugin version or resolution setting is recorded in the repository.
> Unverified: that `elasticsearch-plugin` resolves version-matched artefacts for the pinned 6.2.4 base is upstream tool behaviour, not evidenced in this repository. Confidence: low.
- Rebuilds are reproducible as far as the upstream tag is stable; a version bump is an explicit edit, as the `es-6.2.4` branch name shows.
- The OSS distribution excludes the Elastic commercial features (including X-Pack security), yet the smoke test authenticates with basic auth against the node (`Makefile`), which is not explained anywhere in the repository.
> Unverified: the reason for choosing 6.2.4 specifically, and whether the pin is still intended, are not recorded. Confidence: low.
