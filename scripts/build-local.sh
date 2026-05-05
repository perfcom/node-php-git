#!/usr/bin/env bash
# Local debug build using Docker — no Nix required.
set -euo pipefail

cd "$(dirname "$0")/.."

PHP="${PHP_VERSION:-8.2}"

case "$(uname -m)" in
  arm64)  PLATFORM="${DOCKER_PLATFORM:-linux/arm64}" ;;
  x86_64) PLATFORM="${DOCKER_PLATFORM:-linux/amd64}" ;;
  *) echo "Unsupported arch: $(uname -m)"; exit 1 ;;
esac

TAG="node-php-git:${PHP}"

echo "Building ${TAG} for ${PLATFORM}..."

docker buildx build \
  --platform "${PLATFORM}" \
  --tag "${TAG}" \
  --load \
  "${PHP}/"

echo ""
echo "Built: ${TAG}"
echo "Run:   docker run -it ${TAG} bash"
echo "Test:  docker run --rm ${TAG} sh -c 'php -v && node -v && composer --version && git --version'"
