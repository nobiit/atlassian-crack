#!/usr/bin/env bash
set -euo pipefail

for item in $(cat confluence-tags.txt); do
  CONFLUENCE_VERSION=${item} docker buildx bake confluence
done
