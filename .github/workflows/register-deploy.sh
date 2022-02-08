#!/usr/bin/env bash

#send deployment event to Elasticsearch
timestamp=`printf "%(%Y-%m-%dT%T)T" -1`
hostname=`hostname`
curl --location --request POST 'http://172.19.0.4:9200/app-deployment-logs/_doc' \
--header 'Content-Type: application/json' \
--data-raw "{ \"@timestamp\": \"${timestamp}\", \"success\": true, \"applicationName\": \"dotnetcorewebapp\", \"environmentName\": \"${PROXY_NAME}\", \"targetHost\": \"${hostname}\" }"
