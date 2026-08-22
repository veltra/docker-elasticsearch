---
type: Architecture Decision
title: ADR-0002 Upgrade to Elasticsearch 6.2.4 on the OSS distribution
description: Move the base image from elasticsearch 5.5.1 to docker.elastic.co/elasticsearch/elasticsearch-oss 6.2.4.
status: accepted
date: 2018-05-22
deciders: []
supersedes: [decisions/ADR-0003-config-sync-plugin-adopted-then-dropped]
affects: [docker_elasticsearch.elasticsearch]
allium: []
evidence: [Dockerfile, Makefile, "git log (commit 99a907d 'Update es 6.2.4', merge 3f1e63e PR #2 branch es-6.2.4, commit dbc74b4 'Update Makefile')"]
tags: [veltra, adr, generated]
timestamp: 2026-08-21T21:20:48+00:00
generated_by: claude-fable-5 / layered-docs 2026-08
source_commit: 3f1e63efae6af225d91c11f0a705be3c7de60293
source_branch: allium/layered-docs-2026-08
generated_at: 2026-08-21T21:20:48+00:00
confidence: high
review_status: draft-needs-review
---

# ADR-0002 Upgrade to Elasticsearch 6.2.4 on the OSS distribution

## Context
The image was based on `elasticsearch:5.5.1` and additionally carried the Config Sync plugin (git history, commits fddb7ae and f80688a). Elasticsearch 6.x was current in 2018, and Elastic publishes an Apache-licensed `elasticsearch-oss` variant without the commercial X-Pack features.

## Decision
Base the image on `docker.elastic.co/elasticsearch/elasticsearch-oss:6.2.4` (`Dockerfile` FROM line; commit 99a907d "Update es 6.2.4", merged via PR #2 from branch `es-6.2.4`, merge commit 3f1e63e).

> Unverified: the reason for choosing the OSS variant specifically (licensing, X-Pack avoidance) is not stated in the repo; the choice itself is fully evidenced.

## Consequences
- The image tracks Elasticsearch 6.2.4; the ICU and Kuromoji plugins are installed against that version (`Dockerfile`).
- The Config Sync plugin and its `configsync.flush_interval` setting were dropped in the same commit (99a907d) — see ADR-0003.
- The test target gained `discovery.type=single-node`, required by ES 6.x to start a single node (`Makefile`, commit dbc74b4 "Update Makefile", 2018-05-23). Basic-auth credentials from `.env` predate this change (commits f3b25f7 "Add Makefile" and 284e99c "Add dotenv", both 2017-07-28) and are not a consequence of the upgrade.
