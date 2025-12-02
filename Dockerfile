# get Ubuntu 24.04 (LTS)
FROM ubuntu:24.04

# start as root
USER root

# update apt and install common stuff
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
        git \
        cmake \
        wget \
        build-essential \
        sudo && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# install project tools
ARG TOOLS_DIR=/home/tools
RUN mkdir -p ${TOOLS_DIR} && chown -R ${USERNAME}:${USERNAME} ${TOOLS_DIR}

# remove default 'ubuntu' user, create new user and raise rights to root
RUN userdel -r ubuntu 2>/dev/null || true

# load user args
ARG USERNAME
ARG USER_UID
ARG USER_GID

# create group and user
RUN groupadd -g ${USER_GID} ${USERNAME} 2>/dev/null || true && \
    useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash ${USERNAME} 2>/dev/null || true

# gain sudo access without passwd
RUN echo "$USERNAME ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers

# switch to new user
USER $USERNAME
WORKDIR /home/$USERNAME

# run processes
CMD ["bash"]