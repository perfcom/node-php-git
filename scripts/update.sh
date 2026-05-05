#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

DIRS=(8.2 8.3 8.4 8.5)
# Bump to next LTS major when Node 22 reaches EOL (April 2027)
NODE_LTS_MAJOR=22

command -v jq   >/dev/null 2>&1 || { echo "Error: jq is required (brew install jq)"; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "Error: curl is required"; exit 1; }

echo "Fetching latest versions..."

COMPOSER_VERSION=$(curl -fsSL "https://getcomposer.org/versions" | jq -r '.stable[0].version')
COMPOSER_SHA256=$(curl -fsSL "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar.sha256sum" | awk '{print $1}')

NODE_VERSION=$(curl -fsSL "https://nodejs.org/dist/index.json" | \
  jq -r --argjson major "${NODE_LTS_MAJOR}" \
  '[.[] | select(.lts and ((.version | ltrimstr("v") | split(".")[0] | tonumber) == $major))] | first | .version | ltrimstr("v")')

echo "  Composer : ${COMPOSER_VERSION}  (sha256: ${COMPOSER_SHA256})"
echo "  Node     : ${NODE_VERSION}"
echo ""

for dir in "${DIRS[@]}"; do
  f="${dir}/Dockerfile"
  echo "  Updating ${f}..."
  perl -i -pe "
    s|^(ARG COMPOSER_VERSION=).*|\${1}${COMPOSER_VERSION}|;
    s|^(ARG COMPOSER_SHA256=).*|\${1}${COMPOSER_SHA256}|;
    s|^(ARG NODE_VERSION=).*|\${1}${NODE_VERSION}|;
  " "$f"
done

echo ""
echo "Regenerating README..."
bash scripts/generate-readme.sh

echo ""
echo "Done. Review with: git diff"
