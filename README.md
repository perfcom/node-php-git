# node-php-git

Alpine-based Docker images bundling PHP, Node.js, Composer, and Git — built for CI pipelines.

## Images

| PHP  | Image | Pull |
|------|-------|------|
| `8.2` | `ghcr.io/perfcom/node-php-git:8.2` | `docker pull ghcr.io/perfcom/node-php-git:8.2` |
| `8.3` | `ghcr.io/perfcom/node-php-git:8.3` | `docker pull ghcr.io/perfcom/node-php-git:8.3` |
| `8.4` | `ghcr.io/perfcom/node-php-git:8.4` | `docker pull ghcr.io/perfcom/node-php-git:8.4` |
| `8.5` | `ghcr.io/perfcom/node-php-git:8.5` | `docker pull ghcr.io/perfcom/node-php-git:8.5` |

Each image is published as a multi-arch manifest (`linux/amd64` + `linux/arm64`).

## Versions

| Tool     | Version |
|----------|---------|
| Node.js  | `22.23.2` (LTS 22) |
| Composer | `2.10.2` |
| Git      | Alpine latest |

## PHP Extensions

```
bcmath, bz2, curl, dom, exif, ftp, gd, intl, mbstring, mysqli, opcache, pdo_mysql, pdo_pgsql, pgsql, simplexml, soap, sockets, xml, xsl, zip
```

Built-in (always enabled): `curl`, `dom`, `mbstring`, `simplexml`, `xml`

## Usage

```bash
docker run --rm ghcr.io/perfcom/node-php-git:8.3 php -v
docker run --rm ghcr.io/perfcom/node-php-git:8.3 node -v
docker run --rm ghcr.io/perfcom/node-php-git:8.3 composer --version
docker run --rm ghcr.io/perfcom/node-php-git:8.3 git --version
```

In a CI pipeline:

```yaml
image: ghcr.io/perfcom/node-php-git:8.3
```

## Updating

Run the update script to bump Composer and Node to their latest patch versions,
then commit — the publish workflow triggers automatically on push to `main`.

```bash
./scripts/update.sh
git add 8.2/Dockerfile 8.3/Dockerfile 8.4/Dockerfile README.md
git commit -m "chore: update dependencies"
git push
```

Alternatively, the `update` GitHub Actions workflow runs every Monday at 04:00 UTC
and commits any changes automatically.

## Local build

```bash
# Build PHP 8.3 for your native arch (arm64 on Apple Silicon)
PHP_VERSION=8.3 ./scripts/build-local.sh

# Force amd64 to match CI
DOCKER_PLATFORM=linux/amd64 PHP_VERSION=8.3 ./scripts/build-local.sh
```

## Structure

```
8.2/Dockerfile
8.3/Dockerfile
8.4/Dockerfile
scripts/update.sh          # bump Composer + Node patch versions
scripts/generate-readme.sh # regenerate this file
scripts/build-local.sh     # local debug build via Docker
```
