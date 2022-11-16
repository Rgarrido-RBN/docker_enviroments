#!/bin/bash

set -e

echo "Starting with USER : ${USER_NAME} "

source /opt/esp/idf/export.sh

export HOME=/home/${USER_NAME}

exec /usr/local/bin/gosu ${USER_NAME} "$@"

