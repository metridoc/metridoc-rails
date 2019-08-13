#!/bin/sh -e

echo "node_meta{node_id=\"$NODE_ID\", node_name=\"$NODE_NAME\"} 1" > /home/node_meta.prom

set -- /bin/node_exporter "$@"
exec "$@"
