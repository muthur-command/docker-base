# Muthur Command 基础镜像

英文文档: [`README.md`](./README.md)

这些基础镜像是用于构建 Muthur Command 容器与 add-on 的 Docker 基础镜像。  
建议将本仓库镜像作为您自有 **Muthur Command Add-on** 的基础镜像。

不建议将本镜像用作其他与 Muthur Command 无关的 Docker 项目的基础。

镜像内包含 [S6-Overlay](https://github.com/just-containers/s6-overlay)、[Bashio](https://github.com/mcio-addons/bashio) 与 [TempIO](https://github.com/muthur-command/tempio)。

## 支持的架构

镜像面向 Muthur Command 官方支持的平台构建，即 `amd64` 与 `arm64`。

自 **2026.03.1** 起，上述平台均以 **多架构（multi-arch）** 形式发布。仍可使用旧的前缀镜像名（`aarch64-*`、`amd64-*`），但 **优先建议使用多架构镜像**。

## 基础镜像

仅支持未 EOL 的版本，参见：<https://alpinelinux.org/releases/>

| 镜像 | 操作系统 | Tags | latest |
|-------|----|------|--------|
| base | Alpine | 3.21, 3.22, 3.23 | 3.23 |

### jemalloc

在支持的平台上可使用 jemalloc。若要在应用中启用，请在 Dockerfile 中或启动应用前设置环境变量：`LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"`。

### Python 镜像

在最新的 3 个 Alpine 版本上支持最新的 3 个 Python 主版本线。

| 镜像 | 操作系统 | Python 版本 | Tags | latest |
|-------|----|-----------------|------|--------|
| base-python | Alpine | 3.12, 3.13, 3.14 | 3.12-alpine3.21, 3.12-alpine3.22, 3.12-alpine3.23, 3.13-alpine3.21, 3.13-alpine3.22, 3.13-alpine3.23, 3.14-alpine3.21, 3.14-alpine3.22, 3.14-alpine3.23 | 3.14-alpine3.23 |

## 其他

### Debian 镜像

**说明**：我们更推荐基于 **Alpine** 的版本，因其更适合 IoT。若确需 **glibc** 环境，可使用本类镜像。

| 镜像 | 操作系统 | Tags | latest |
|-------|----|------|--------|
| base-debian | Debian | bookworm, trixie | trixie |

### Ubuntu 镜像

**说明**：我们更推荐基于 **Alpine** 的版本，因其更适合 IoT。若确需 **glibc** 环境，可使用本类镜像。

| 镜像 | 操作系统 | Tags | latest |
|-------|----|------|--------|
| base-ubuntu | Ubuntu | 22.04, 24.04 | 24.04 |

## 本地构建镜像

可使用 Docker BuildKit（`docker buildx`）在本地构建，无需额外工具链。以下为在 **单一（宿主机）架构** 上构建的示例。

若需多平台构建或交叉编译，请为 `docker buildx build` 指定 `--platform` 及目标平台。详见 Docker 官方文档：[多平台构建](https://docs.docker.com/build/building/multi-platform/)。

### 示例

使用 Dockerfile 中的默认 Alpine 版本构建 base：

```bash
docker buildx build -t base alpine/
```

指定 Alpine 基础版本：

```bash
docker buildx build \
  --build-arg ALPINE_VERSION=3.21 \
  -t base:3.21 \
  alpine/
```

Debian base：

```bash
docker buildx build \
  --build-arg DEBIAN_VERSION=trixie \
  -t base-debian:trixie \
  debian/
```

Ubuntu base：

```bash
docker buildx build \
  --build-arg UBUNTU_VERSION=24.04 \
  -t base-ubuntu:24.04 \
  ubuntu/
```

Python 3.14 镜像，基于 GHCR 上的 Muthur Command Alpine 3.23 base：

```bash
docker buildx build \
  --build-arg BASE_IMAGE=ghcr.io/muthur-command/base \
  --build-arg BASE_VERSION=3.23 \
  -t base-python:3.14-alpine3.23 \
  python/3.14/
```

## 来源

- **上游：** [home-assistant/docker-base](https://github.com/home-assistant/docker-base) — 面向 Home Assistant 生态的 Docker 基础镜像，本目录由其移植而来。
- **本仓库：** **Muthur Command** 在此维护该副本，供 **Muthur Command OS** 的 CI 使用；镜像配方与 tag 可能随时间与上游产生差异。
- **许可：** 自上游继承的代码仍为 **Apache-2.0**；见 [`LICENSE`](./LICENSE)。
