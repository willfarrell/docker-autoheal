#!/usr/bin/env bash
set -euxo pipefail

COMPOSE_PROJECT_NAME=autoheal-test

function cleanup()
{
    exit_status=$?
    echo "exit was $exit_status"
    docker-compose -f docker-compose.autoheal.yml -f docker-compose.yml rm -f || true
    exit "$exit_status"
}
trap cleanup EXIT
docker-compose up --build -d
docker-compose -f docker-compose.autoheal.yml up --build --exit-code-from watch-autoheal watch-autoheal

