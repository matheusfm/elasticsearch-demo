#!/bin/sh
echo "Creating shakespeare index ..."

curl -X PUT \
  'http://localhost:9200/shakespeare?pretty' \
  -H 'Content-Type: application/json' \
  -d '{
       "settings": {
        "number_of_shards" : 2,
        "number_of_replicas" : 1
       },
       "mappings": {
        "doc": {
         "properties": {
          "speaker": {"type": "keyword"},
          "play_name": {"type": "keyword"},
          "line_id": {"type": "integer"},
          "speech_number": {"type": "integer"}
         }
        }
       }
      }'

echo "Loading data set ..."

curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/shakespeare/doc/_bulk?pretty' --data-binary @shakespeare_6.0.json

echo "Data set loaded"
echo "$(curl localhost:9200/_cat/count/shakespeare?h=count) documents indexed"