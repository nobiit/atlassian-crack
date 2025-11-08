#!/usr/bin/env bash
set -e

function list_tags {
  url="hub.docker.com/v2/repositories/atlassian/${1}/tags?page_size=500&page=1"
  while [ "${url}" != null ]; do
    result="$(curl -sLf "${url}")"
    echo "${result}" | jq -r '.results[] | tojson'
    url="$(echo "${result}" | jq -r '.next')"
  done
}

function list_tags_releases {
  declare -A versions
  for line in $(list_tags ${1}); do
    name=$(echo "${line}" | jq -r '.name')
    if [[ "${name}" =~ ^([0-9]+\.[0-9]+)\.([0-9]+)$ ]]; then
      if [ -z ${versions[${BASH_REMATCH[1]}]} ] || [ ${BASH_REMATCH[2]} -gt ${versions[${BASH_REMATCH[1]}]} ]; then
        versions[${BASH_REMATCH[1]}]=${BASH_REMATCH[2]}
      fi
    fi
  done
  for key in ${!versions[@]}; do
    echo "${key}.${versions[${key}]}"
  done
}

function list_tags_releases_sorted {
  list_tags_releases ${1} | sort -V | while read -r line; do
    if [ $(echo ${line} ${2} | xargs -n 1 | sort -V | head -n 1) == ${2} ]; then
      echo ${line}
    fi
  done
  echo latest
}

# list_tags_releases_sorted jira-software 9.11 > jira-tags.txt
list_tags_releases_sorted confluence 8.6 > confluence-tags.txt
