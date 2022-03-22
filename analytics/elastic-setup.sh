#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo "Usage: ./elastic-setup.sh -a \"https://my-deployment:9243\" -b \"elastic:mypassword\" -c \"https://my-deployment:9243\" -d \"elastic:mypassword\""
    exit 1
fi

while [ $# -gt 0 ] ; do
  case $1 in
    -a | --elastic-url) ELASTIC_URL="$2" ;;
    -b | --elastic-creds) ELASTIC_CREDS="$2" ;;
    -c | --kibana-url) KIBANA_URL="$2" ;;
    -d | --kibana-creds) KIBANA_CREDS="$2" ;;
  esac
  shift
done

echo "Install DoS resources to $ELASTIC_CREDS@$ELASTIC_URL"
curl -u "$ELASTIC_CREDS" -XPUT "$ELASTIC_URL/app-protect-dos-logs?pretty" -H "Content-Type: application/json" -d @apdos_index.json
curl -u "$ELASTIC_CREDS" -XPOST "$ELASTIC_URL/app-protect-dos-logs/_mapping" -H "Content-Type: application/json" -d @apdos_geo_mapping.json

echo "Install Kibana resources"
curl -u "$KIBANA_CREDS" -XPOST "$KIBANA_URL/api/saved_objects/_import?overwrite=true" -H "kbn-xsrf: true" --form file=@kibana-8-1-objects.ndjson
