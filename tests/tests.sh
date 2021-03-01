#!/usr/bin/env bash
set -euxo pipefail

COMPOSE_PROJECT_NAME=${1:-autoheal-test}
export COMPOSE_PROJECT_NAME

function cleanup()
{
    exit_status=$?
    echo "exit was $exit_status"
    # stop autoheal first, to stop it restarting the test containers while we try to stop them
    docker-compose stop autoheal
    docker-compose -f docker-compose.autoheal.yml -f docker-compose.yml down || true
    exit "$exit_status"
}
trap cleanup EXIT
docker-compose up --build -d
docker-compose -f docker-compose.autoheal.yml up --build --exit-code-from watch-autoheal watch-autoheal

