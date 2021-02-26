#!/usr/bin/env bash
set -euxo pipefail

listenToDockerEvents()
{
docker events --filter 'container=should-keep-restarting' --filter 'container=shouldnt-restart' --filter 'event=restart' | while read LOGLINE
do
  echo "$LOGLINE"
  # may be more elaborate checks here.
   [[ "${LOGLINE}" == *"container restart "*"name=shouldnt-restart"* ]] && echo "ERR: No restarts expected on shouldnt-restart container!" && pkill -9 docker && exit 1
   [[ "${LOGLINE}" == *"container restart "*"name=should-keep-restarting"* ]] && echo "OK: Expected restart on should-keep-restarting container!" && pkill -9 docker && exit 0
done

}

export -f listenToDockerEvents
timeout 60s bash -c listenToDockerEvents
