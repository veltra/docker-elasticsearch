---
type: Architecture Decision
title: ADR-0003 Config Sync plugin adopted, then dropped at the 6.2.4 upgrade
description: The codelibs elasticsearch-configsync plugin was added in 2017 (PR #1) and removed when the base moved to 6.2.4.
status: superseded
date: 2017-09-25   # adoption commit fddb7ae; merged 2017-10-02 (7880ecc); removed 2018-05-22 by the change recorded in ADR-0002
deciders: []
supersedes: []
superseded_by: [decisions/ADR-0002-upgrade-to-elasticsearch-6-2-4-oss]
affects: [docker_elasticsearch.elasticsearch]
allium: []
evidence: ["git log (commits fddb7ae 'Add Config Sync plugin', f80688a 'Set configsync.flush_interval', merge 7880ecc PR #1 branch feature/17843_configsync, removal in 99a907d)"]
tags: [veltra, adr, generated]
timestamp: 2026-08-21T21:20:48+00:00
generated_by: claude-fable-5 / layered-docs 2026-08
source_commit: 3f1e63efae6af225d91c11f0a705be3c7de60293
source_branch: allium/layered-docs-2026-08
generated_at: 2026-08-21T21:20:48+00:00
confidence: medium
review_status: draft-needs-review
---

# ADR-0003 Config Sync plugin adopted, then dropped at the 6.2.4 upgrade

## Context
In September 2017 the image gained `org.codelibs:elasticsearch-configsync:5.5.0`, a plugin that synchronises configuration files across cluster nodes, (commit fddb7ae "Add Config Sync plugin", 2017-09-25), followed the next day by `configsync.flush_interval: 1s` appended to `elasticsearch.yml` (commit f80688a, 2017-09-26); both merged 2017-10-02 as PR #1 from branch `feature/17843_configsync` (merge 7880ecc). The branch name references ticket 17843, suggesting a concrete feature need, but the ticket content is not in this repo.

## Decision
Adopt the Config Sync plugin (2017). This decision was later superseded: the plugin and its setting were removed in commit 99a907d together with the move to `elasticsearch-oss:6.2.4` (ADR-0002), and the current `Dockerfile` no longer installs it.

> Unverified: why it was removed (no 6.x-compatible build, no longer needed, or replaced by something else) is not recorded in the repo. Hence confidence: medium.

## Consequences
- The current image has no configuration-sync mechanism; only the two analysis plugins remain (`Dockerfile`).
- Any consumer that relied on configsync behaviour would have lost it at the 6.2.4 upgrade — no evidence in this repo of such a consumer.
