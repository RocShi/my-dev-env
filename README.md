# my-dev-env

> 个人 Linux 开发环境通用配置框架，持续迭代。

## 1 特性

### 1.1 基础环境

- `apt` 软件源自动修改为阿里云，加速软件安装速度
- 安装 `wget` `curl` `git` `vim` `build-essential` 等基础工具，并设置了常用 `git alias`
- 安装 `locales` 解决潜在的字符编码问题
- 安装 Docker 及 NVIDIA Container Toolkit 等虚拟化工具，便于进行容器化开发

### 1.2 效率工具

本项目默认安装了下述工具用于提升开发体验和效率：

- [shfmt](https://github.com/mvdan/sh)：shell 脚本格式化工具，可配合 vscode shell-format 插件（v7.0.1）使用
- [zoxide](https://github.com/ajeetdsouza/zoxide)：目录快速跳转工具，bash / fish / zsh 均已配置，通过 `z` 或 `zz` 命令快速唤起
- [fzf](https://github.com/junegunn/fzf)：命令行交互式过滤工具，典型应用如历史命令快速查找，bash / fish / zsh 均已配置，通过 `CTRL + R` 快速唤起
- [fish shell](https://github.com/fish-shell/fish-shell)：开箱即用的现代化交互式 shell，包含语法高亮、命令智能提示、TAB 补全等诸多特性，在易用性上显著优于其它 shell，但与 POSIX 不兼容导致在使用某些软件（如 ROS、Conda）时可能有兼容性问题，一般也不难解决
- [z-shell](https://www.zsh.org)：zsh，强大的交互式 shell，兼容 POSIX，依赖丰富的社区插件扩展其能力。本项目不依赖 [Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh) 框架对 zsh 进行配置（过于臃肿），直接通过下面几个插件增强 zsh（体验接近 fish 且兼容性更强）：
  - [fzf-tab](https://github.com/Aloxaf/fzf-tab)：基于 fzf 的 zsh tab 补全增强
  - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)：命令输入智能提示
  - [zsh-completions](https://github.com/zsh-users/zsh-completions)：zsh 命令补全增强
  - [conda-zsh-completion](https://github.com/conda-incubator/conda-zsh-completion)：zsh conda 命令补全
  - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)：语法高亮，错误命令红色提醒

**Tips**

- 可单独执行 `common_scripts/install_efficiency_tools.sh` 脚本单独一键安装配置高效开发工具，提升开发体验和效率（**注意安装完需重启系统以使改动生效**）
- 可通过执行 `common_scripts/change_shell.sh` 脚本修改系统默认交互式 shell（bash / fish / zsh），最佳实践：
  - 交互式 shell 使用 fish 或 zsh，提升效率
  - shell 脚本中设置 shebang 为 `#!/bin/bash`（使用 bash 作为脚本解释器），确保脚本兼容性

### 1.3 Docker 环境

- `docker` 目录用于存储自定义 docker 镜像的构建文件及 `docker-compose.yml`
- 为简化使用，`docker-compose.sh` 对 `docker compose -f` 命令及 `docker-compose.yml` 进行了简单封装
- 为支持不同类型开发镜像的构建需求，通过 YAML 锚点模块化 `docker-compose.yml` 的 service 配置，具体可参考项目文档 [docker_env_guide](docs/docker_env_guide.md)
- 可将本项目嵌套进其它开发项目进行使用（如 [deep-learner](https://github.com/RocShi/deep-learner)），可方便地新增自定义镜像，具体参考 [docker_env_guide](docs/docker_env_guide.md)

## 2 使用方法

### 2.1 克隆仓库

```bash
git clone --depth=1 --recurse-submodules --shallow-submodules https://github.com/RocShi/my-dev-env.git
```

### 2.2 主机环境配置

#### 2.2.1 WSL2 配置

首先需要在 Windows 环境中下载并安装 [NVIDIA App](https://www.nvidia.cn/software/nvidia-app/)，并通过该软件直接安装 NVIDIA 驱动；然后在 WSL2 终端中执行下述命令完成基础开发环境的配置：

```bash
cd my-dev-env/host && chmod +x setup_wsl2.sh && ./setup_wsl2.sh
```

#### 2.2.2 Linux 配置 (TODO)

需要在 Linux 环境中安装 NVIDIA 驱动，其它配置步骤与 WSL2 类似，暂未实现。

### 2.3 Docker 环境配置

上述步骤已完成 docker 及 NVIDIA Container Toolkit 的安装，此处直接构建并使用指定的 docker 镜像即可：

```bash
cd my-dev-env && chmod +x docker-compose.sh

# 构建镜像（添加 --no-cache 选项将强制重新构建而非使用缓存）
sudo ./docker-compose.sh build <service-name>

# 启动容器
sudo ./docker-compose.sh up -d <service-name>

# 进入容器进行开发
sudo docker exec -it <container-name> bash

# 停止服务，删除容器
sudo ./docker-compose.sh down <service-name>
```

**Taste is all you need!**
