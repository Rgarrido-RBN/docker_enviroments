#!/bin/bash

# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
# @    CONTACT ME!          Rubén Garrido - rgarrido.rbn@gmail.com        @
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

if [ "$0" = "$BASH_SOURCE" ]; then
    echo "THIS SCRIPT MUST BE SOURCED!"
    exit 1
fi

export DOCKER_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

echo ">>>>>>>>>>>>>>>> AVAILABLE COMMANDS "
echo
echo "    docker_permision -->  Add permission to docker after installation, use it only if docker throws permission errors"
echo "    docker_build {image} -->  BUILD docker image"
echo "    docker_run {image} -->  RUN docker image"
echo "    list_docker -->  list different docker images ready to build on this repository"

list_docker ()
{
    echo ">>>>>>>>>>>>>>> Available images"
    echo "    - ubuntu20 -> Ubuntu 20.04 image with necessary tools for cross compiling for differents architectures"
    echo "    - ubuntu18 -> Ubuntu 18.04 image with necessary tools for cross compiling for differents architectures"
    echo "    - ubuntu16 -> Ubuntu 16.04 image with necessary tools for cross compiling for differents architectures"
    echo "    - esp32 -> esp-idf enviroment ready to build esp-idf based projects"
    echo "    - rust -> debian enviroment ready to build rust projects"
}

# Add permission to docker after installation, use it only if you need it
docker_permision ()
{
    sudo groupadd docker
    sudo usermod -aG docker ${USER}
    sudo chmod 666 /var/run/docker.sock
}

# Build docker image
docker_build ()
{
    IMAGE_NAME="$1"

    docker build --build-arg USERNAME="$(id -un)" \
                 --build-arg GROUPNAME="$(id -gn)" \
                 --build-arg USERID="$(id -u)" \
                 --build-arg GROUPID="$(id -g)" \
                 -t $IMAGE_NAME $DOCKER_DIR/$IMAGE_NAME  \
}

# Run docker image
docker_run ()
{
    IMAGE_NAME="$1"
    docker run --privileged -it -v $HOME/Projects/:/${USER} $IMAGE_NAME /bin/bash
}
