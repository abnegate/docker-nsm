#!/usr/bin/env sh

kibana-docker &

sleep 120

git clone https://github.com/StamusNetworks/KTS7.git

for file in KTS7/*.ndjson; do
  echo "Importing $file"
    curl -X POST "http://host.docker.internal:5601/api/saved_objects/_import?overwrite=true" \
        -H 'kbn-xsrf: true' \
        --form file=@"$file"
done

service kibana restart

tail -f /dev/null


