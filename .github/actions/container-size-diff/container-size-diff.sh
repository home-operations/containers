#!/usr/bin/env bash

FROM_CONTAINER=${1:?}
TO_CONTAINER=${2:?}

get_sizes_from_manifest() {
    local CONTAINER=${1:?}
    declare -Ag ${2:?}
    local -n SIZE_MAP=${2}

    for MANIFEST in $(docker manifest inspect -v ${CONTAINER} | jq -c 'if type == "array" then .[] else . end' | jq -r '[ ( .Descriptor.platform | [ .os, .architecture, .variant, ."os.version" ] | del(..|nulls) | join("/") ), ( [ .OCIManifest.layers[].size ] | add ) ] | join(":")');
    do
        PLATFORM="${MANIFEST%%:*}"
        SIZE="${MANIFEST#*:}"

        if [[ ${PLATFORM} != "unknown/unknown" ]];
        then
            SIZE_MAP[${PLATFORM}]=${SIZE}
        fi
    done
}

get_sizes_from_manifest ${FROM_CONTAINER} FROM_CONTAINER_SIZES
get_sizes_from_manifest ${TO_CONTAINER} TO_CONTAINER_SIZES

echo "## Compressed layer size comparison"
echo
echo "Comparing \`${FROM_CONTAINER}\` to \`${TO_CONTAINER}\`"
echo
echo "| OS/Platform | Previous Size | Current Size | Delta |"
echo "|-------------|---------------|--------------|-------|"
for PLATFORM in "${!FROM_CONTAINER_SIZES[@]}";
do
    BASE_SIZE=${FROM_CONTAINER_SIZES[${PLATFORM}]}
    HEAD_SIZE=${TO_CONTAINER_SIZES[${PLATFORM}]}

    echo "| ${PLATFORM} | $(numfmt --to iec --format '%.2f' ${BASE_SIZE}) | $(numfmt --to iec --format '%.2f' ${HEAD_SIZE}) | $(numfmt --to iec --format '%.2f' -- $((${HEAD_SIZE} - ${BASE_SIZE}))) $(python -c "print('({:+0.2f}%)'.format(((${HEAD_SIZE} - ${BASE_SIZE}) / ${BASE_SIZE}) * 100))") |";
done
