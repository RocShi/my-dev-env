# for more details, check NGC: https://ngc.nvidia.com/catalog/containers/nvidia:tensorrt:24.06-py3
FROM nvcr.io/nvidia/tensorrt:24.06-py3

ENV TZ=Asia/Shanghai
ARG user=shipeng

# 1. set timezone in case of interation during installation
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 2. use bash shell with pipefail option for better error handling
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# 3. replace Ubuntu apt source with Aliyun and install base packages
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends wget curl vim git unzip locales clang-format \
    sudo build-essential cmake pkg-config libgtk-3-dev libavcodec-dev libavformat-dev \
    libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libjpeg-dev libpng-dev \
    libtiff-dev gfortran openexr libatlas-base-dev python3-dev python3-numpy libtbb2 \
    libtbb-dev libdc1394-dev libgflags-dev libboost-dev libxml2-dev libyaml-cpp-dev \
    sqlite3 libsqlite3-dev libboost-all-dev lsb-release && \
    apt-get -y clean && rm -rf /var/lib/apt/lists/*

# 4. generate en_US.UTF-8 locale
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# 5. build opencv4.5.5
WORKDIR /root
RUN wget -O opencv.zip https://gh-proxy.com/https://github.com/opencv/opencv/archive/refs/tags/4.5.5.zip && \
    wget -O opencv_contrib.zip https://gh-proxy.com/https://github.com/opencv/opencv_contrib/archive/refs/tags/4.5.5.zip && \
    unzip opencv.zip && mv opencv-4.5.5 opencv && \
    unzip opencv_contrib.zip && mv opencv_contrib-4.5.5 opencv_contrib && \
    rm opencv.zip opencv_contrib.zip && \
    cd opencv && mkdir build && cd build && \
    cmake -D OPENCV_GENERATE_PKGCONFIG=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D WITH_GSTREAMER=ON \
    -D WITH_LIBV4L=ON \
    -D BUILD_opencv_python2=ON \
    -D BUILD_opencv_python3=ON \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D PYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages \
    -D CMAKE_INSTALL_PREFIX=/usr/local .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    cd /root && \
    rm -rf opencv opencv_contrib

# 6. configure pip to use Tsinghua mirror and install netron
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install netron

# 7. set userinfo
RUN useradd -rm -c ${user} -u 1000 -d /home/${user} -s /bin/bash -G sudo ${user} && \
    echo "${user}   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 8. set working directory
RUN chown -R ${user}:users /home/${user}
WORKDIR /home/${user}
USER ${user}

CMD ["/bin/bash"]
