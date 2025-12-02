#!/bin/bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MY_USER_LOWERCASE=$(echo "$USER" | tr '[:upper:]' '[:lower:]')
MY_UID=$(id -u "$MY_USER_LOWERCASE")

docker build \
    --no-cache \
    -f "$DIR/Dockerfile" \
    -t "cat_detector_$MY_USER_LOWERCASE:latest" \
    --build-arg USERNAME="$MY_USER_LOWERCASE" \
    --build-arg USER_UID="$MY_UID" \
    --build-arg USER_GID="$MY_UID" \
    "$DIR"
