#!/usr/bin/env bash
set -euo pipefail

for item in $(cat jira-tags.txt); do
  JIRA_VERSION=${item} docker buildx bake jira
done
