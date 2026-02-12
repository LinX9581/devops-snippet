#!/bin/bash

PASSWORD="password"
INDEX_PREFIX="index_prefix_nginx-access-"

# Calculate cutoff date (30 days ago)
cutoff_date=$(date -u -d "30 days ago" "+%Y.%m.%d")

# Loop through indices and delete if older than cutoff date
for index in $(curl -s -u "elastic:${PASSWORD}" "localhost:9200/_cat/indices/${INDEX_PREFIX}*?h=index" | sort -r); do
    index_date=$(echo "${index}" | awk -F '-' '{print $NF}')
    if [[ "${index_date}" < "${cutoff_date}" ]]; then
        curl -s -u "elastic:${PASSWORD}" -X DELETE "localhost:9200/${index}?pretty"
        echo "Deleted index: ${index}"
    fi
done