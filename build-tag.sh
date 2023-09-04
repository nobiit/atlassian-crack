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
  list_tags ${1} | while read -r line; do
    name=$(echo "${line}" | jq -r '.name')
    if [[ "${name}" =~ ^[0-9]+\.[0-9]+$ ]]; then
      echo "${name}"
    fi
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

list_tags_releases_sorted jira-software 8.18 > jira-tags.txt
list_tags_releases_sorted confluence 8.0 > confluence-tags.txt
