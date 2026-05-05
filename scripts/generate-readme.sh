#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

REPO="ghcr.io/perfcom/node-php-git"
DIRS=(8.2 8.3 8.4 8.5)
OUT="README.md"

# --- Read versions from the first Dockerfile (all share the same ARG values) ---
FIRST_DF="${DIRS[0]}/Dockerfile"
NODE_VERSION=$(grep    '^ARG NODE_VERSION='     "$FIRST_DF" | cut -d= -f2)
COMPOSER_VERSION=$(grep '^ARG COMPOSER_VERSION=' "$FIRST_DF" | cut -d= -f2)

ALL_EXT="bcmath, bz2, curl, dom, exif, ftp, gd, intl, mbstring, mysqli, opcache, pdo_mysql, pdo_pgsql, pgsql, simplexml, soap, sockets, xml, xsl, zip"

# --- Build PHP version table rows ---
PHP_ROWS=""
for dir in "${DIRS[@]}"; do
  df="${dir}/Dockerfile"
  php_ver=$(grep '^FROM php:' "$df" | head -1 | sed 's/FROM php:\(.*\)-cli-alpine.*/\1/')
  PHP_ROWS="${PHP_ROWS}| \`${php_ver}\` | \`${REPO}:${php_ver}\` | \`docker pull ${REPO}:${php_ver}\` |
"
done

# --- Write README ---
cat > "$OUT" <<EOF
# node-php-git

Alpine-based Docker images bundling PHP, Node.js, Composer, and Git — built for CI pipelines.

## Images

| PHP  | Image | Pull |
|------|-------|------|
${PHP_ROWS}
Each image is published as a multi-arch manifest (\`linux/amd64\` + \`linux/arm64\`).

## Versions

| Tool     | Version |
|----------|---------|
| Node.js  | \`${NODE_VERSION}\` (LTS 22) |
| Composer | \`${COMPOSER_VERSION}\` |
| Git      | Alpine latest |

## PHP Extensions

\`\`\`
${ALL_EXT}
\`\`\`

Built-in (always enabled): \`curl\`, \`dom\`, \`mbstring\`, \`simplexml\`, \`xml\`

## Usage

\`\`\`bash
docker run --rm ${REPO}:8.3 php -v
docker run --rm ${REPO}:8.3 node -v
docker run --rm ${REPO}:8.3 composer --version
docker run --rm ${REPO}:8.3 git --version
\`\`\`

In a CI pipeline:

\`\`\`yaml
image: ${REPO}:8.3
\`\`\`

## Updating

Run the update script to bump Composer and Node to their latest patch versions,
then commit — the publish workflow triggers automatically on push to \`main\`.

\`\`\`bash
./scripts/update.sh
git add 8.2/Dockerfile 8.3/Dockerfile 8.4/Dockerfile README.md
git commit -m "chore: update dependencies"
git push
\`\`\`

Alternatively, the \`update\` GitHub Actions workflow runs every Monday at 04:00 UTC
and commits any changes automatically.

## Local build

\`\`\`bash
# Build PHP 8.3 for your native arch (arm64 on Apple Silicon)
PHP_VERSION=8.3 ./scripts/build-local.sh

# Force amd64 to match CI
DOCKER_PLATFORM=linux/amd64 PHP_VERSION=8.3 ./scripts/build-local.sh
\`\`\`

## Structure

\`\`\`
8.2/Dockerfile
8.3/Dockerfile
8.4/Dockerfile
scripts/update.sh          # bump Composer + Node patch versions
scripts/generate-readme.sh # regenerate this file
scripts/build-local.sh     # local debug build via Docker
\`\`\`
EOF

echo "Written: ${OUT}"
