#!/bin/bash ...
[[ -z "${GIT_COMMIT}" ]] && Tag='local' || Tag="${GIT_COMMIT::4}"
[[ -z "${docker_username}" ]] && DockerRepo='' || DockerRepo="${docker_username}/"
docker build -t "${DockerRepo}code-chan:latest" -t "${DockerRepo}code-chan:1.0-$Tag" ./