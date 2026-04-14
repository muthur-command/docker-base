# MCOS 基础镜像（`docker-base`）

用于 **MCOS** / **muthur-command** 容器构建（add-ons、plugins、Core）的 Docker 基础镜像仓库。

| 项目 | 本仓库约定 |
|--------|----------------|
| GHCR 命名空间 | **`ghcr.io/muthur-command/`**（CI 使用 `${{ github.repository_owner }}`；正式发布到 **`muthur-command`**） |
| OCI 标签 | 基础层与 CI 注入元数据统一使用 **`io.mcio.*`** |
| TempIO 二进制 | **`https://github.com/muthur-command/tempio/releases/...`** |
| Alpine Python 包索引 | 默认使用 **PyPI**（`https://pypi.org/simple`）通过 pip / uv；不使用第三方 wheel 镜像。在 musl 环境下，若 PyPI 无现成 wheel，部分包可能走源码构建。若需私有索引，可通过 **`UV_EXTRA_INDEX_URL`** 或 **`pip.conf`** 覆盖。 |

镜像内集成了 [S6-Overlay](https://github.com/just-containers/s6-overlay)、[Bashio](https://github.com/hassio-addons/bashio) 与 [TempIO](https://github.com/muthur-command/tempio)。

## 架构

支持 `amd64` 与 `arm64`（`aarch64`），并在适用场景发布多架构 manifest。

## 基础镜像

Alpine 版本跟随 [Alpine releases](https://alpinelinux.org/releases/)。

| 镜像 | 操作系统 | Tags | latest |
|-------|----|------|--------|
| base | Alpine | 3.21, 3.22, 3.23 | 3.23 |

### jemalloc

在支持的场景（Alpine 构建）下，可在应用镜像或运行时设置：`LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"`。

### Python 镜像

| 镜像 | 操作系统 | Python | 说明 |
|-------|----|--------|--------|
| base-python | Alpine | 3.12, 3.13, 3.14 | 默认基于 **`ghcr.io/muthur-command/base:<alpine>`** 构建 |

### Debian / Ubuntu

| 镜像 | 操作系统 | Tags |
|-------|----|------|
| base-debian | Debian | bookworm, trixie |
| base-ubuntu | Ubuntu | 22.04, 24.04 |

## CI

工作流 **`.github/workflows/builder.yml`**：每次 push 和 PR 都会运行 **Alpine / Debian / Ubuntu** 构建。**`base-python`** 仅在 **`release`（`published`）** 触发，因为各 Python Dockerfile 都是 **`FROM ghcr.io/<owner>/base:<alpine>`**，必须先在 Alpine 矩阵中完成 push 后，GHCR 上才有可用基础镜像。首次初始化仓库时，建议先发一个 **release**（或临时允许在 `mc`/`main` 的 `push` 上推送，接受预发布 tag）。

可复用工作流 **`.github/workflows/build-base-image.yml`** 使用 **`muthur-command/builder`** 组合 Action（生产环境建议固定 SHA/tag）。

## 本地构建

使用 Docker BuildKit / `buildx`。以下为基于已发布 MCOS base 的 Python 镜像示例：

```bash
docker buildx build \
  --build-arg BASE_IMAGE=ghcr.io/muthur-command/base \
  --build-arg BASE_VERSION=3.23 \
  -t base-python:3.14-alpine3.23 \
  python/3.14/
```

## 许可证

见 **LICENSE**（Apache-2.0；保留上游版权信息）。MCOS 的 **NOTICE** 建议在法务确认后补充。
