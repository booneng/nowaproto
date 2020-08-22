#!/usr/bin/env bash

ROOT="$(cd "$(dirname "$0")/.." &>/dev/null; pwd -P)"

PROTOC_GO_CONTAINER_IMAGE="booneng/protoc-go"

PROTOC_DART_CONTAINER_IMAGE="booneng/protoc-dart"

PROTOC_SWIFT_CONTAINER_IMAGE="booneng/protoc-swift"

docker run \
    --interactive \
    --rm \
    --volume "${ROOT}:${ROOT}" \
    --workdir "${ROOT}" \
    "${PROTOC_GO_CONTAINER_IMAGE}" \
        --proto_path=${ROOT}/proto \
        --go_out=plugins=grpc,paths=source_relative:./proto/gen \
        ${ROOT}/proto/*.proto

docker run \
    --interactive \
    --rm \
    --volume "${ROOT}:${ROOT}" \
    --workdir "${ROOT}" \
    "${PROTOC_DART_CONTAINER_IMAGE}" \
        --proto_path=${ROOT}/proto \
        --dart_out=grpc:./proto/gen \
        ${ROOT}/proto/*.proto

docker run \
    --interactive \
    --rm \
    --volume "${ROOT}:${ROOT}" \
    --workdir "${ROOT}" \
    "${PROTOC_SWIFT_CONTAINER_IMAGE}" \
        --proto_path=${ROOT}/proto \
        --swift_opt=Visibility=Public \
        --swift_out=./proto/gen \
        --grpc-swift_opt=Visibility=Public \
        --grpc-swift_out=./proto/gen \
        ${ROOT}/proto/*.proto

echo "Protos regenerated (OK)"
