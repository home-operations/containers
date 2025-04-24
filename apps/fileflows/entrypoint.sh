#!/usr/bin/env bash

# Start proper process
if [ "$FFNODE" = "0" ]; then
    cd /app/Server
    echo "Starting Fileflows Server..."
    dotnet /app/Server/FileFlows.Server.dll --urls="http://0.0.0.0:${PORT};http://[::]:${PORT}"
elif [ "$FFNODE" = "1" ]; then
    cd /app/Node
    echo "Starting FileFlows Node..."
    dotnet FileFlows.Node.dll
else
    echo "Unknown FFNODE value: '$FFNODE'"
    echo "To run the node set the FFNODE env to '1'"
    exit 1
fi
