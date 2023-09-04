#!/usr/bin/env bash
set -euo pipefail

for item in $(find ${1} -name "*.jar"); do
  hash=$(echo "${item}" | openssl dgst -md5 -binary | hexdump -v -e '/1 "%02x"')
  mkdir -p /dist/${hash}/
  echo "${item} ${hash}" | tee /dist/${hash}/log.txt
  disassemble -out /dist/${hash} ${item} | tee -a /dist/${hash}/log.txt
done
