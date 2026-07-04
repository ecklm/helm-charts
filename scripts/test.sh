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
  chart_name="$(basename "$chart_dir")"
  release_suffix="$(printf '%s' "$chart_name" | tr '[:upper:]_' '[:lower:]-' | tr -cd '[:lower:][:digit:]-')"
  release_suffix="${release_suffix:0:48}"
  while [[ "$release_suffix" == -* ]]; do
    release_suffix="${release_suffix#-}"
  done
  while [[ "$release_suffix" == *- ]]; do
    release_suffix="${release_suffix%-}"
  done
  release_suffix="${release_suffix:-chart}"
  release_name="test-${release_suffix}"

  printf 'Testing chart: %s\n' "$chart_dir"
  helm dependency update "$chart_dir"
  helm lint "$chart_dir"
  helm template "$release_name" "$chart_dir" --debug
  helm install "$release_name" "$chart_dir" --dry-run --debug
done
