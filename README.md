# my-dev-env

> 个人 Linux 开发环境通用配置框架，持续迭代。

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
sudo ./docker-compose.sh build <service-name>

# 启动容器
sudo ./docker-compose.sh up -d <service-name>

# 进入容器进行开发
sudo docker exec -it <container-name> /bin/bash

# 停止服务，删除容器
sudo ./docker-compose.sh down <service-name>
```

可将本项目嵌套进其它开发项目进行使用（如 [deep-learner](https://github.com/RocShi/deep-learner)），可方便地新增自定义镜像，具体参考 [docker_env_guide](docs/docker_env_guide.md)。

## 3 特别说明

也可单独执行 `common_scripts/install_efficiency_tools.sh` 脚本，一键安装配置高效开发工具，提升开发体验和效率（默认离线模式，安装更快速，**注意安装完需重启系统以使改动生效**）：

- [shfmt](https://github.com/mvdan/sh)：shell 脚本格式化工具，可配合 vscode shell-format 插件（v7.0.1）使用
- [zoxide](https://github.com/ajeetdsouza/zoxide)：目录快速跳转工具
- [fzf](https://github.com/junegunn/fzf)：命令行交互式过滤工具，典型应用如历史命令快速查找
- [fish shell](https://github.com/fish-shell/fish-shell)：现代化的交互式 shell，包含语法高亮、命令智能提示、TAB 补全等诸多特性，可显著提效
