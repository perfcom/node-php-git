#!/bin/bash

echo "NOTE: THIS SCRIPT IS FOR DEBUGGING PURPOSES ONLY."

set -e

docker build --progress plain --build-arg PHP_VERSION=8.2 -t perfcom/node-php-git:8.2-2.2 .

# Run it
#docker run -it perfcom/node-php-git:8.2-2.2 bash
