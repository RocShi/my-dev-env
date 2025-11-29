# Docker 开发环境说明

## 1 架构设计

### 1.1 独立仓库设计

`my-dev-env` 设计为独立仓库，支持两种使用方式：

1. **作为独立项目使用**：在 `my-dev-env` 目录下运行
2. **作为子模块使用**：被其他项目引入

### 1.2 分层配置锚点

使用 YAML 锚点实现灵活的配置组合：

| 锚点名称        | 用途                   | 包含配置                 |
| --------------- | ---------------------- | ------------------------ |
| `x-base-config` | 所有开发容器的基础配置 | tty, stdin_open, command |
| `x-gpu-config`  | GPU 相关配置           | NVIDIA GPU、环境变量     |
| `x-dev-volumes` | 开发挂载配置           | 默认挂载 `/:/host`       |
| `x-dl-config`   | 深度学习特定配置       | 8GB 共享内存             |

### 1.3 服务类型

不同类型的服务组合不同的配置锚点：

```yaml
# 深度学习服务（需要 GPU）
dl-dev-cuda11.8-cudnn8-pytorch1.13.1-ubuntu22.04:
  <<: [*base-config, *gpu-config, *dev-volumes, *dl-config]

# C++ 开发服务（不需要 GPU）
cpp-dev:
  <<: [*base-config, *dev-volumes]

# Python 通用开发（不需要 GPU，较小共享内存）
python-dev:
  <<: [*base-config, *dev-volumes]
  shm_size: '2gb'
```

## 2 快速开始

### 2.1 作为独立项目使用

```bash
cd my-dev-env
chmod +x docker-compose.sh

# 构建镜像
./docker-compose.sh build dl-dev-cuda11.8-cudnn8-pytorch1.13.1-ubuntu22.04

# 启动容器
./docker-compose.sh up -d dl-dev-cuda11.8-cudnn8-pytorch1.13.1-ubuntu22.04

# 进入容器
docker exec -it dl_dev_cuda11.8 bash
```

### 2.2 作为子模块在父项目中使用

#### 2.2.1 使用基础配置（挂载整个主机根目录）

```bash
# 从父项目根目录运行
docker compose -f my-dev-env/docker/docker-compose.yml up -d dl-dev-cuda11.8-cudnn8-pytorch1.13.1-ubuntu22.04

# 进入容器
docker exec -it dl_dev_cuda11.8 bash
```

#### 2.2.2 使用父项目自定义配置（推荐）

在父项目根目录创建 `docker-compose.yml` 覆盖配置：

```yaml
services:
  dl-dev-cuda11.8-cudnn8-pytorch1.13.1-ubuntu22.04:
    volumes:
      - ./samples:/workspace/samples
    working_dir: /workspace/samples
```

然后组合使用两个 `docker-compose.yml`：

```bash
docker compose --project-directory . \
  -f my-dev-env/docker/docker-compose.yml \
  -f docker-compose.yml \
  up -d dl-dev-cuda11.8-cudnn8-pytorch1.13.1-ubuntu22.04
```

## 3 添加新镜像

### 3.1 添加深度学习镜像（需要 GPU）

#### 步骤 1：创建 Dockerfile 目录

```bash
mkdir -p docker/cuda12.1-cudnn8-pytorch2.0-ubuntu22.04
# 添加 Dockerfile, environment.yml, requirements.txt
```

#### 步骤 2：在 docker-compose.yml 中添加服务

编辑 `docker/docker-compose.yml`：

```yaml
services:
  dl-dev-cuda12.1-cudnn8-pytorch2.0-ubuntu22.04:
    <<: [*base-config, *gpu-config, *dev-volumes, *dl-config]
    build:
      context: cuda12.1-cudnn8-pytorch2.0-ubuntu22.04
      dockerfile: Dockerfile
    image: dev-env:cuda12.1-cudnn8-pytorch2.0-ubuntu22.04
    container_name: dl_dev_cuda12.1
```

#### 步骤 3：在父项目 docker-compose.yml 中添加覆盖配置（可选）

编辑父项目根目录的 `docker-compose.yml`：

```yaml
services:
  dl-dev-cuda12.1-cudnn8-pytorch2.0-ubuntu22.04:
    volumes:
      - ./samples:/workspace/samples
    working_dir: /workspace/samples
```

### 3.2 添加 C++ 开发镜像（不需要 GPU）

#### 步骤 1：创建 Dockerfile 目录

```bash
mkdir -p docker/cpp-dev-ubuntu22.04
# 在该目录创建 Dockerfile
```

#### 步骤 2：在 docker-compose.yml 中添加服务

编辑 `docker/docker-compose.yml`：

```yaml
services:
  cpp-dev:
    <<: [*base-config, *dev-volumes]
    build:
      context: cpp-dev-ubuntu22.04
      dockerfile: Dockerfile
    image: dev-env:cpp-dev-ubuntu22.04
    container_name: cpp_dev
```

#### 步骤 3：在父项目 docker-compose.yml 中添加覆盖配置（可选）

编辑父项目根目录的 `docker-compose.yml`：

```yaml
services:
  dl-dev-cuda12.1-cudnn8-pytorch2.0-ubuntu22.04:
    volumes:
      - ./samples:/workspace/samples
    working_dir: /workspace/samples
```

## 4 常用命令

```bash
# 查看所有服务
docker compose -f docker/docker-compose.yml config --services

# 构建镜像（添加 --no-cache 强制重新构建）
./docker-compose.sh build <service-name>
./docker-compose.sh build --no-cache <service-name>

# 启动容器
./docker-compose.sh up -d <service-name>

# 停止服务，删除容器
./docker-compose.sh down <service-name>

# 查看日志
docker compose -f docker/docker-compose.yml logs <service-name>

# 进入容器
docker exec -it <container-name> bash
```

## 5 注意事项

1. **路径设计**：所有 `context` 路径都是相对于 compose 文件的，确保可以在任何位置运行
2. **配置组合**：`<<: [*base-config, *gpu-config, ...]` 中，后面的配置会覆盖前面的同名字段
3. **容器名称唯一**：每个服务的 `container_name` 必须唯一
4. **GPU 权限**：只有需要 GPU 的服务才包含 `*gpu-config`，确保主机已安装 NVIDIA Container Toolkit
5. **共享内存**：深度学习环境默认 8GB，通用环境可根据需要调整或不设置
