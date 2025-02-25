set -eux

DOCKER_SOCKET=/var/run/docker.sock

# If the user is attempting to run jenkins as root and the docker socket is mounted
#if [ "$3" = "/usr/local/bin/jenkins.sh" ] && [ "$(id -u)" = "0" ] && [ -S ${DOCKER_SOCKET} ]; then
    # Container Docker GID
    CONTAINER_DOCKER_GID=$(getent group docker | awk -F ":" '{ print $3 }')

    # Host Docker GID (from mounted /var/run/docker.sock)
    HOST_DOCKER_GID=$(stat -c '%g' ${DOCKER_SOCKET})

    # If the host and container have a docker GID and the two are different
    # then update the container GID to match the host
    if [ -n "${CONTAINER_DOCKER_GID}" ] && [ -n "${HOST_DOCKER_GID}" ] && [ "${CONTAINER_DOCKER_GID}" != "${HOST_DOCKER_GID}" ]; then
        echo "Updating the Docker GID in the container to match the host"
        groupmod -g ${HOST_DOCKER_GID} -o docker
    fi

    # run jenkins as jenkins user
    exec gosu jenkins "$@"

#fi

# run any other command
exec "$@"