#!/bin/bash

set -e

export BW_PORT=${BW_PORT:=8087}

curl -X POST -s http://127.0.0.1:${BW_PORT}/sync | jq -e '.success == true'
curl -X GET -s http://127.0.0.1:${BW_PORT}/status | jq -e '.data.template.status == "unlocked"'
