# my-dev-env

> 个人开发环境通用配置框架，持续迭代。

## 1 主机环境配置

### 1.1 WSL2

首先需要在 Windows 环境中下载并安装 [NVIDIA App](https://www.nvidia.cn/software/nvidia-app/)，并通过该软件直接安装 NVIDIA 驱动；然后在 WSL2 终端中执行下述命令完成基础开发环境的配置：

```bash
git clone https://github.com/RocShi/my-dev-env.git
cd my-dev-env/host && chmod +x setup_wsl2.sh && ./setup_wsl2.sh
```

### 1.2 Linux (TODO)

需要在 Linux 环境中安装 NVIDIA 驱动，其它配置步骤与 WSL2 类似，暂未实现。

## 2 Docker 环境配置

上述步骤已完成 docker 及 NVIDIA Container Toolkit 的安装，此处直接构建并使用指定的 docker 镜像即可：

```bash
cd my-dev-env && chmod +x docker-compose.sh

# 构建镜像（添加 --no-cache 选项将强制重新构建而非使用缓存）
./docker-compose.sh build <service-name>

# 启动容器
./docker-compose.sh up -d <service-name>

# 进入容器进行开发
docker exec -it <container-name> /bin/bash

# 停止服务，删除容器
./docker-compose.sh down <service-name>
```

可将本项目嵌套进其它开发项目进行使用（如 [deep-learner](https://github.com/RocShi/deep-learner)），可方便地新增自定义镜像，具体参考 [docker_env_guide](docs/docker_env_guide.md)。
