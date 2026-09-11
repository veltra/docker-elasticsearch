# Elasticsearch image (Japanese search) — knowledge bundle (OKF)

Generated draft (layered-docs 2026-09) — review required. Concept id = path without `.md`.

- [system](system.md) — System: Dockerfile and CI for the Elasticsearch OSS 6.2.4 image with ICU and Kuromoji analysis plugins.
- [decisions/ADR-0001-pin-elasticsearch-oss-6-2-4](decisions/ADR-0001-pin-elasticsearch-oss-6-2-4.md) — Architecture Decision: the base image is pinned to the OSS 6.2.4 tag.
- [decisions/ADR-0002-bake-japanese-analysis-plugins](decisions/ADR-0002-bake-japanese-analysis-plugins.md) — Architecture Decision: ICU and Kuromoji are installed at image build time.
- [decisions/ADR-0003-circleci-build-and-smoke-test](decisions/ADR-0003-circleci-build-and-smoke-test.md) — Architecture Decision: CI builds the image and curls a single-node container.
