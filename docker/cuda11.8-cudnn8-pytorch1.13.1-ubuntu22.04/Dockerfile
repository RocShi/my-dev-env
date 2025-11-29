# 使用 NVIDIA 提供的 CUDA 11.8 + cuDNN 8 开发版镜像 (基于 Ubuntu 22.04)
# 注意：GTX 1060 (compute capability 6.1) 需要 PyTorch 1.13.x，该版本最高支持 CUDA 11.7
# 使用 CUDA 11.8 基础镜像（向后兼容 CUDA 11.7）
FROM nvcr.io/nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# 避免交互式前端
ENV DEBIAN_FRONTEND=noninteractive

# 1. 更换 Ubuntu apt 源为阿里云
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends wget curl vim git libgl1-mesa-glx libglib2.0-0 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 2. 安装 Miniconda
ENV CONDA_DIR=/opt/conda
# 使用清华源下载 Miniconda
RUN wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh

# 将 conda 加入 PATH
ENV PATH=$CONDA_DIR/bin:$PATH

# 3. 配置 Conda 和 Pip 镜像源 (使用清华源，它包含 PyTorch 镜像)
RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/ && \
    conda config --add channels conda-forge && \
    conda config --set show_channel_urls yes && \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 3.1. 接受 Conda 服务条款（非交互式构建需要）
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# 4. 复制环境配置文件
WORKDIR /workspace
COPY environment.yml /tmp/environment.yml
COPY requirements.txt /tmp/requirements.txt

# 5. 创建 Conda 环境并安装依赖
# 注意：这里会使用 environment.yml 中定义的 pip 依赖
RUN conda env create -f /tmp/environment.yml && \
    conda clean -ya

# 6. 设置默认 shell 环境
# 使得后续 RUN 指令在 py3.10-torch1.13.1 环境下执行
SHELL ["conda", "run", "-n", "py3.10-torch1.13.1", "/bin/bash", "-c"]

# 7. 安装 PyTorch (需要从官方源安装 CUDA 版本)
# PyTorch 1.13.1 是最后一个支持 GTX 1060 (compute capability 6.1) 的版本
RUN pip install torch==1.13.1+cu117 torchvision==0.14.1+cu117 torchaudio==0.13.1+cu117 \
    --extra-index-url https://download.pytorch.org/whl/cu117

# 验证 PyTorch 安装 (可选)
RUN python -c "import torch; print(f'PyTorch version: {torch.__version__}, CUDA available: {torch.cuda.is_available()}')"

# 8. 设置容器启动时的默认行为
# 在 .bashrc 中激活环境，这样进入容器终端时会自动激活
RUN echo "source /opt/conda/etc/profile.d/conda.sh" >>~/.bashrc && \
    echo "conda activate py3.10-torch1.13.1" >>~/.bashrc

CMD ["/bin/bash"]
