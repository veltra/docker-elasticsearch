# Elasticsearch Docker Image — knowledge bundle (OKF)

Generated draft (layered-docs 2026-08) — review required. Concept id = path without `.md`.

- [system](system.md) — System: custom Elasticsearch 6.2.4 OSS Docker image with ICU and Kuromoji analysis plugins.
- [decisions/ADR-0001-custom-image-with-icu-kuromoji-plugins](decisions/ADR-0001-custom-image-with-icu-kuromoji-plugins.md) — Architecture Decision: maintain an in-house image that pre-installs analysis-icu and analysis-kuromoji.
- [decisions/ADR-0002-upgrade-to-elasticsearch-6-2-4-oss](decisions/ADR-0002-upgrade-to-elasticsearch-6-2-4-oss.md) — Architecture Decision: move the base image to elasticsearch-oss 6.2.4.
- [decisions/ADR-0003-config-sync-plugin-adopted-then-dropped](decisions/ADR-0003-config-sync-plugin-adopted-then-dropped.md) — Architecture Decision: Config Sync plugin added in 2017, removed at the 6.2.4 upgrade (superseded).
