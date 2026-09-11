---
type: Architecture Decision
title: ADR-0002 Bake the ICU and Kuromoji analysis plugins into the image
description: analysis-icu and analysis-kuromoji are installed at image build time rather than configured per cluster.
status: accepted
date: unknown
deciders: []
supersedes: []
affects: [docker_elasticsearch.search_node]
allium: []
evidence: ["Dockerfile"]
tags: [veltra, adr, generated]
timestamp: 2026-09-11T07:47:05Z
generated_by: claude-opus-5 / layered-docs 2026-09
source_commit: 3f1e63efae6af225d91c11f0a705be3c7de60293
source_branch: docs/layered-2026-09
generated_at: 2026-09-11T07:47:05Z
confidence: medium
review_status: draft-needs-review
---

# ADR-0002 Bake the ICU and Kuromoji analysis plugins into the image

## Context
The `Dockerfile` installs both analysis plugins at image build time rather than leaving them to be
installed or configured per container (`Dockerfile:2-3`). Nothing in the repository records why.

> Unverified: the usual reasoning — that analysis plugins must be present on a node before an index
> referencing their analyzers can be opened, that installing them at container start adds network
> dependency and start-up time, and that Japanese text analysis needs a morphological analyzer absent
> from the default distribution — is general Elasticsearch behaviour and is not evidenced in this
> repository. Confidence: low.

## Decision
Install `analysis-icu` and `analysis-kuromoji` as separate `RUN elasticsearch-plugin install` layers
in the image (`Dockerfile`), so every container started from the image already has them. This is the
entire reason the repository exists rather than using the upstream image directly.

## Consequences
- Any index mapping in consuming systems may rely on ICU and Kuromoji analyzers being available — evidence: `Dockerfile`.
- The plugin set is tied to the image: adding an analyzer requires editing the `Dockerfile` and rebuilding the image (`Dockerfile:2-3`). How a rebuilt image reaches consumers is not evidenced in the repository.
- Two `RUN` layers mean each plugin install is cached separately on rebuild (`Dockerfile`).
> Unverified: which indices or services depend on these analyzers is not evidenced in this repository. Confidence: low.
