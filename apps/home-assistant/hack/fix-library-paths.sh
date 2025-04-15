#!/usr/bin/env bash

for f in /usr/lib/*; do
    if [ -d "${f}" ]; then
        continue
    fi

    if [[ "${f}" =~ \.so\.[0-9]+(\.[0-9]+)*$ ]]; then
        filename="${f%%.so.*}.so"
        if [ ! -e "${filename}" ]; then
            echo "Creating symlink: ${filename} -> ${f}"
            ln -s "${f}" "${filename}"
        fi
    fi
done
