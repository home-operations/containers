#!/usr/bin/env bash
set -euo pipefail

# i18n hack
cp -r /var/tmp/i18n/* /app/Server/wwwroot/i18n/

# Start proper process
if [ "$FFNODE" = "0" ]; then
    echo "Starting Fileflows Server..."
    cd /app/Server
    exec dotnet FileFlows.Server.dll --urls="http://0.0.0.0:${PORT};http://[::]:${PORT}" --docker
elif [ "$FFNODE" = "1" ]; then
    if [ -z "$ServerUrl" ]; then
        echo "Error: Running as a node but 'ServerUrl' environment variable is not set."
        exit 1
    fi

    echo "Starting FileFlows Node..."
    cd /app/Node
    exec dotnet FileFlows.Node.dll --docker
else
    echo "Unknown FFNODE value: '$FFNODE'"
    echo "To run the node set the FFNODE env to '1'"
    exit 1
fi
