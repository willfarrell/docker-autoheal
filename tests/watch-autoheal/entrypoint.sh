#!/usr/bin/env bash
set -euxo pipefail

listenToDockerEvents()
{
  local expected_restarts
  local LOGLINE
  expected_restarts=0
  docker events --filter 'com.docker.compose.service=should-keep-restarting' --filter 'com.docker.compose.service=shouldnt-restart-*' --filter 'event=restart' | while read -r LOGLINE
  do
    echo "$LOGLINE"
    # may be more elaborate checks here.
    [[ $LOGLINE == *"container restart "*"com.docker.compose.service=shouldnt-restart-"* && $LOGLINE == *"com.docker.compose.project=$COMPOSE_PROJECT_NAME"* ]] && echo "ERR: No restarts expected on shouldnt-restart-* containers!" 1>&2 && pkill -9 docker && exit 1
    [[ $LOGLINE == *"container restart "*"com.docker.compose.service=should-keep-restarting"* && $LOGLINE == *"com.docker.compose.project=$COMPOSE_PROJECT_NAME"* ]] && echo "OK: Expected restart on should-keep-restarting container!" && pkill -9 docker && expected_restarts=$((expected_restarts + 1))
    [[ $expected_restarts == 1 ]] && echo "OK: All expected restarts happened" && exit 0
  done
}

export -f listenToDockerEvents
timeout 60s bash -c listenToDockerEvents
