#!/usr/bin/env bash

 exec \
     /app/bin/Lidarr \
         --nobrowser \
         --data=/config \
         "$@"
