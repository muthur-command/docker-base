# MCOS base images (`docker-base`)

Docker base images for **MCOS** / **muthur-command** container builds (add-ons, plugins, Core).

| Item | In this repo |
|--------|----------------|
| GHCR namespace | **`ghcr.io/muthur-command/`** (CI uses `${{ github.repository_owner }}`; publish under **`muthur-command`**) |
| OCI labels | **`io.mcio.*`** on base layers and CI-injected metadata |
| TempIO binary | **`https://github.com/muthur-command/tempio/releases/...`** |
| Python package index (Alpine) | **PyPI** default (`https://pypi.org/simple`) via pip / uv; no third-party wheel mirror. On musl, some packages may build from source unless wheels exist on PyPI. Override with **`UV_EXTRA_INDEX_URL`** or **`pip.conf`** if you add a private index. |

Images bundle [S6-Overlay](https://github.com/just-containers/s6-overlay), [Bashio](https://github.com/hassio-addons/bashio), and [TempIO](https://github.com/muthur-command/tempio).

## Architectures

`amd64` and `arm64` (`aarch64`), published as multi-arch manifests where applicable.

## Base images

Alpine versions follow [Alpine releases](https://alpinelinux.org/releases/).

| Image | OS | Tags | latest |
|-------|----|------|--------|
| base | Alpine | 3.21, 3.22, 3.23 | 3.23 |

### jemalloc

Set `LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"` in the application image or at runtime where supported (Alpine build).

### Python images

| Image | OS | Python | Notes |
|-------|----|--------|--------|
| base-python | Alpine | 3.12, 3.13, 3.14 | Built on **`ghcr.io/muthur-command/base:<alpine>`** by default |

### Debian / Ubuntu

| Image | OS | Tags |
|-------|----|------|
| base-debian | Debian | bookworm, trixie |
| base-ubuntu | Ubuntu | 22.04, 24.04 |

## CI

Reusable workflow **`.github/workflows/build-base-image.yml`** uses **`muthur-command/builder`** composite actions (`@mc`; pin by SHA/tag in production).

## Building locally

Use Docker BuildKit / `buildx`. Example Python image on published MCOS base:

```bash
docker buildx build \
  --build-arg BASE_IMAGE=ghcr.io/muthur-command/base \
  --build-arg BASE_VERSION=3.23 \
  -t base-python:3.14-alpine3.23 \
  python/3.14/
```

## License

See **LICENSE** (Apache-2.0; upstream copyright retained). Add **NOTICE** for MCOS when legal approves.
