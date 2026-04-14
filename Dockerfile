# 1. 使用 Ubuntu 官方镜像作为底座（这个国内随处可见，绝对能拉下来）
FROM ubuntu:24.04

# 2. 设置非交互模式
ENV DEBIAN_FRONTEND=noninteractive

# 3. 更换为国内清华源/阿里源，并安装基础工具和 ROS 2 Jazzy
RUN sed -i 's/ports.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
    apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    lsb-release \
    && curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg || \
       curl -sSL https://mirror.ghproxy.com/https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] https://mirrors.tuna.tsinghua.edu.cn/ros2/ubuntu noble main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update && apt-get install -y \
    ros-jazzy-ros-base \
    python3-colcon-common-extensions \
    build-essential \
    cmake \
    git \
    && rm -rf /var/lib/apt/lists/*

# 4. 设置环境变量
ENV ROS_DISTRO=jazzy
ENV AMENT_PREFIX_PATH=/opt/ros/jazzy
ENV PYTHONPATH=/opt/ros/jazzy/lib/python3.12/site-packages
ENV PATH=/opt/ros/jazzy/bin:$PATH

WORKDIR /ros2_ws
