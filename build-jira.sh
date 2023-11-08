#!/usr/bin/env bash
set -euo pipefail

for item in $(cat jira-tags.txt); do
  JIRA_VERSION=${item} docker buildx bake jira
  if [[ ${item} =~ ^([0-9]+\.[0-9]+)\.[0-9]+$ ]]; then
    for image in $(JIRA_VERSION=${item} docker buildx bake jira --print | jq -r '.target.jira.tags[]'); do
      new_image="$(echo "${image}" | sed "s/${item}$/${BASH_REMATCH[1]}/")"
      docker tag ${image} ${new_image}
      docker push ${new_image}
    done
  fi
done
