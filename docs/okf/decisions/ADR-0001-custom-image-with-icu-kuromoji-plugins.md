---
type: Architecture Decision
title: ADR-0001 Custom Elasticsearch image with ICU and Kuromoji analysis plugins
description: Maintain an in-house Docker image that extends the official Elasticsearch image with analysis-icu and analysis-kuromoji.
status: accepted
date: 2017-07-27   # earliest plugin-install evidence in git history; exact origin unknown
deciders: []
supersedes: []
affects: [docker_elasticsearch.elasticsearch]
allium: []
evidence: [Dockerfile, Makefile, "git log (commits 72ec66b, 8637242 and earlier 2017 history)"]
tags: [veltra, adr, generated]
timestamp: 2026-08-21T21:20:48+00:00
generated_by: claude-fable-5 / layered-docs 2026-08
source_commit: 3f1e63efae6af225d91c11f0a705be3c7de60293
source_branch: allium/layered-docs-2026-08
generated_at: 2026-08-21T21:20:48+00:00
confidence: medium
review_status: draft-needs-review
---

# ADR-0001 Custom Elasticsearch image with ICU and Kuromoji analysis plugins

## Context
The stock Elasticsearch image ships without the `analysis-icu` (Unicode/ICU) and `analysis-kuromoji` (Japanese morphological analysis) plugins. Every Dockerfile revision in this repo's history installs both plugins (`Dockerfile`, git history from 2017 onward), indicating a standing need for Unicode-aware and Japanese text analysis.

## Decision
Maintain a dedicated repository that builds `veltra/elasticsearch` (`Makefile`): the official Elasticsearch image plus `RUN elasticsearch-plugin install analysis-icu` and `RUN elasticsearch-plugin install analysis-kuromoji` (`Dockerfile`).

> Unverified: the rationale (Japanese-language search) is inferred from what the plugins do; no document in the repo states it. Hence confidence: medium.

## Consequences
- Downstream users get Japanese/ICU analysis without per-deployment plugin installs (`Dockerfile`).
- The image must be rebuilt to track upstream Elasticsearch releases; version bumps appear as Dockerfile FROM changes in git history (e.g. commits 8637242, 99a907d).
- CI smoke-tests the built image on every commit (`.circleci/config.yml`, `Makefile`).
