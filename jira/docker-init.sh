#!/usr/bin/env bash
set -euo pipefail

for item in $(find ${1}/jira/atlassian-jira/WEB-INF/lib -maxdepth 1 -type f -name "atlassian-extras-key-manager-*.jar"); do
  hash=$(echo "${item}" | openssl dgst -md5 -binary | hexdump -v -e '/1 "%02x"')
  disassemble -out /dist/${hash} -roundtrip ${item} >>/dev/null
  cat ${2} | jq -r '.[] | tojson' | while read -r line; do
    from=$(echo "${line}" | jq -r .from)
    to=$(echo "${line}" | jq -r .to)
    count=0
    for file in $(grep "${from}" -r /dist/${hash} -l); do
      sed -i "s|${from}|${to}|g" ${file}
      if [ $(grep "${from}" ${file} -c) != 0 ]; then
        exit 1
      fi
      ((count++)) || true
      echo "${item} ${file} ${from}" | tee -a /dist/result.txt
    done
    if [ ${count} == 0 ]; then
      exit 1
    fi
    assemble -out ${item} -r /dist/${hash} >>/dev/null
    hash_content=$(openssl dgst -md5 -binary ${item} | hexdump -v -e '/1 "%02x"')
    sed -i -E "s|(/$(basename ${item}))=.+|\1=${hash_content}|" /opt/atlassian/jira/atlassian-jira/WEB-INF/classes/hash-registry.properties
  done
done

if ! [ -f /dist/result.txt ]; then
  exit 1
fi
