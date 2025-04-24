#!/usr/bin/env bash

# Start proper process
if [ "$FFNODE" = "0" ]; then
    echo "Starting Fileflows Server..."
    dotnet /app/Server/FileFlows.Server.dll --urls="http://0.0.0.0:${PORT};http://[::]:${PORT}" --docker true
elif [ "$FFNODE" = "1" ]; then
    if [ -z "$ServerUrl" ]; then
        echo "Error: Running as a node but 'ServerUrl' environment variable is not set."
        exit 1
    fi

    cd /app/Node
    echo "Starting FileFlows Node..."
    dotnet /app/Server/FileFlows.Node.dll --docker true
else
    echo "Unknown FFNODE value: '$FFNODE'"
    echo "To run the node set the FFNODE env to '1'"
    exit 1
fi
