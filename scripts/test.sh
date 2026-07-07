#!/usr/bin/env bash
set -euo pipefail

chart_dirs=()

for chart_yaml in charts/*/Chart.yaml; do
  if [ -f "$chart_yaml" ]; then
    chart_dirs+=("${chart_yaml%/Chart.yaml}")
  fi
done

if [ "${#chart_dirs[@]}" -eq 0 ]; then
  printf 'No Helm charts found under charts/* containing Chart.yaml.\n' >&2
  exit 1
fi

for chart_dir in "${chart_dirs[@]}"; do
  printf 'Testing chart: %s\n' "$chart_dir"
  helm dependency update "$chart_dir"
  helm unittest "$chart_dir"
done
