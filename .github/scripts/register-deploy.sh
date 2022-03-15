#!/usr/bin/env bash

# send deployment event to Elasticsearch
timestamp=`date "+%Y-%m-%dT%T%z"`
url="${ELASTIC_URL}/app-deployment-logs/_doc"
data="{ \"@timestamp\": \"${timestamp}\", \"success\": true, \"applicationName\": \"${APPLICATION_NAME}\", \"environmentName\": \"${ENVIRONMENT_NAME\" }"
echo sending "$data to $url"
curl -u "$ELASTIC_USERNAME:$ELASTIC_PASSWORD" --location --request POST "$url" \
--header 'Content-Type: application/json' \
--data-raw "$data"
