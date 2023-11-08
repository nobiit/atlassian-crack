#!/usr/bin/env bash
set -euo pipefail

for item in $(cat confluence-tags.txt); do
  CONFLUENCE_VERSION=${item} docker buildx bake confluence
  if [[ ${item} =~ ^([0-9]+\.[0-9]+)\.[0-9]+$ ]]; then
    for image in $(CONFLUENCE_VERSION=${item} docker buildx bake confluence --print | jq -r '.target.confluence.tags[]'); do
      new_image="$(echo "${image}" | sed "s/${item}$/${BASH_REMATCH[1]}/")"
      docker tag ${image} ${new_image}
      docker push ${new_image}
    done
  fi
done
