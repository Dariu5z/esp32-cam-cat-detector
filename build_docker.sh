#!/bin/bash

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR=$(mktemp -d -p "$DIR")

if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
    echo "Could not create temp dir"
    exit 1
fi

cleanup() {
    rm -rf "$WORK_DIR"
    echo "Deleted temp working directory \"$WORK_DIR\""
}

trap cleanup EXIT

MY_USER_LOWERCASE=$(echo "$USER" | tr '[:upper:]' '[:lower:]')
MY_UID=$(id -u "$MY_USER_LOWERCASE")

docker build \
    -f "$DIR/Dockerfile" \
    -t "cat_detector_$MY_USER_LOWERCASE:latest" \
    --build-arg USERNAME="$MY_USER_LOWERCASE" \
    --build-arg USER_UID="$MY_UID" \
    --build-arg USER_GID="$MY_UID" \
    "$WORK_DIR"
