# Helm Charts

Repository home for multiple Helm charts.

## Structure

```text
charts/
  CHART_NAME/
    Chart.yaml
    values.yaml
    templates/
scripts/
  test.sh
  build.sh
dist/
```

Charts live under `charts/CHART_NAME/`. Packaged charts are written to `dist/` by `scripts/build.sh`.

## Prerequisites

- Bash
- Helm 3

Optional local validators:

- `shellcheck` for shell scripts
- `yamllint` for repository YAML files

## Local Testing

Run all chart checks:

```sh
scripts/test.sh
```

The test script finds every `charts/*/Chart.yaml` and runs:

- `helm dependency update`
- `helm lint`
- `helm template --debug`
- `helm install --dry-run --debug`

No cluster-changing operations are performed.

## Local Build

Package all charts into `dist/`:

```sh
scripts/build.sh
```

The build script refreshes dependencies and runs `helm package` for each chart. It does not publish, upload, or push chart packages anywhere.

## GitHub Actions

Workflows run on pull requests and pushes to `main`:

- `.github/workflows/test.yaml` installs Helm and runs `scripts/test.sh`.
- `.github/workflows/build.yaml` installs Helm, runs `scripts/build.sh`, and uploads `dist/*.tgz` as workflow artifacts for convenience.

No external publishing is configured yet. There is no GitHub Pages Helm repository, GHCR OCI push, release asset upload, or automatic publish step.

## Adding Charts

Add each chart as a normal Helm chart under `charts/CHART_NAME/` with its own `Chart.yaml`, `values.yaml`, and `templates/` directory. Update the chart `version` in `Chart.yaml` before building a new package version.
