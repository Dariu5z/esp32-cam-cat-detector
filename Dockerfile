FROM ubuntu:24.04

# remove default `ubuntu` user, create new user and raise rights to root
RUN userdel -r ubuntu

ARG USERNAME
ARG USER_UID
ARG USER_GID

RUN id $USERNAME 2>/dev/null || useradd --uid $USER_UID --shell /bin/bash $USERNAME
RUN echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

USER $USERNAME
WORKDIR /home/$USERNAME

# update apt and install common stuff
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get dist-upgrade -y \
    && apt-get autoremove -y \
    && apt-get autoclean

RUN apt-get install -y \
    git \
    cmake \
    wget \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get clean

# install project tools
ARG TOOLS_DIR=/home/tools
RUN mkdir -p ${TOOLS_DIR}

CMD ["bash"]