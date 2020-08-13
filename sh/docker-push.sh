#!/bin/bash ...
docker push "$docker_username/code-chan:1.0-${GIT_COMMIT::4}" 
docker push "$docker_username/code-chan:latest" &
wait