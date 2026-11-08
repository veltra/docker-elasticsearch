---
type: Architecture Decision
title: ADR-0003 Verify the image with a CircleCI build-and-curl smoke test
description: CI builds the image and probes a single-node container's HTTP API with curl instead of running a test framework.
status: accepted
date: unknown
deciders: []
supersedes: []
affects: [docker_elasticsearch, docker_elasticsearch.search_node]
allium: []
evidence: [".circleci/config.yml", "Makefile", "README.md"]
tags: [veltra, adr, generated]
timestamp: 2026-09-11T07:47:05Z
generated_by: claude-opus-5 / layered-docs 2026-09
source_commit: 3f1e63efae6af225d91c11f0a705be3c7de60293
source_branch: docs/layered-2026-09
generated_at: 2026-09-11T07:47:05Z
confidence: medium
review_status: draft-needs-review
---

# ADR-0003 Verify the image with a CircleCI build-and-curl smoke test

## Context
The repository has no application code to unit-test: it tracks only a `Dockerfile`, a `Makefile`,
the CircleCI config, a README, `.env` and `.gitignore`.

> Not recorded in the repository; presumed: the failures worth checking are a base image or plugin
> install that breaks the build and an image that does not start a responding node. Confidence: low.

A check is run in CircleCI, as the CI badge in `README.md:1` and the config show (`.circleci/config.yml:1-25`).

## Decision
Keep verification in the `Makefile` as two targets and have CircleCI call them: `build` runs
`docker build`, and `test` depends on `build`, starts the image detached with
`discovery.type=single-node` and port 9200 published, sleeps, then runs an `appropriate/curl`
container joined to the Elasticsearch container's network namespace with
`--retry 10 --retry-connrefused` and basic-auth credentials, so a node that never accepts connections
fails the job (`Makefile`, `.circleci/config.yml`). CI uses the `docker:17.07.0-ce-git` image with
`setup_remote_docker` and installs `bash curl make` at job start. The config declares a single `build`
job with no `workflows`, branch or tag filters, so the CircleCI default trigger applies
(`.circleci/config.yml:1-25`).

## Consequences
- The curl call has no `-f`/`--fail` flag (`Makefile:10`), so an HTTP error response from the node (for example 401 on rejected credentials) still exits successfully: the check proves the port answers, not that the request succeeds.
- The same command verifies the image locally and in CI — no CI-only test path (`Makefile`).
- Verification depends on a fixed `sleep 20` plus curl retries rather than a readiness check, so it is timing-sensitive on slow runners (`Makefile`).
- The smoke test needs credentials from the `Makefile`'s included environment file, which couples CI to that file being present (`Makefile`).
- CircleCI configuration is version 2 and pins an old Docker executor image, so CI is as frozen as the Elasticsearch pin (`.circleci/config.yml`).
- Both the smoke-test curl image (`appropriate/curl`, `Makefile:10`) and the CI executor image (`docker:17.07.0-ce-git`, `.circleci/config.yml:6`) are unqualified public registry images, so the check depends on that registry as well as on the Elastic registry.
- The job's steps are checkout, `make build` and `make test` only: no push or deploy step exists, so CI verifies the image and does not ship it (`.circleci/config.yml:1-25`, `Makefile:5-10`).
