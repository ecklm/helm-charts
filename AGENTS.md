# AGENTS.md

## Repo Shape

- Helm charts live under `charts/*/`; scripts discover charts only by `charts/*/Chart.yaml`.
- `dist/`, `*.tgz`, `*.prov`, and `charts/*/charts/` are generated/ignored; do not hand-edit or commit them unless explicitly asked.

## Commands

- Run all CI-equivalent checks from repo root: `scripts/test.sh`.
- `scripts/test.sh` runs `helm dependency update` and `helm unittest` for each chart.
- Build packages from repo root: `scripts/build.sh`; this deletes/recreates `dist/` first.
- `scripts/build.sh` runs `helm dependency update` and `helm package` for each chart.
- Focus one chart manually: `helm dependency update charts/<chart> && helm unittest charts/<chart>`.
- Validate shell scripts with `shellcheck scripts/*.sh` when shell changes.
- Validate non-template YAML with `yamllint .`; `.yamllint` intentionally ignores `charts/*/templates/**` because Helm templates are Go-templated YAML.
- Validate JSON edits with `jq empty <file>`.

## Chart Gotchas

- Keep each chart's `values.yaml`, `values.schema.json`, templates, and dependencies in sync when adding or renaming values.
- When packaging a chart change for release, bump that chart's `version` in `Chart.yaml`.

## Style

- In YAML and JSON files, write lists multiline, even when short.
- Preserve existing two-space indentation in YAML and JSON.
