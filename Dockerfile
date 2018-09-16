FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04

ARG docker_user=dev
ARG docker_uid=1000
ARG docker_gid=1000

ARG docker_home=/home/$docker_user
ARG DEBIAN_FRONTEND=noninteractive

ENV PATH="${docker_home}/.local/bin:${PATH}"
ENV CONTAINER_NAME=docker

# The base utilities.
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    apt-utils \
    build-essential

# The convenient utilities.
RUN apt-get update && apt-get -y install \
    bash-completion \
    ca-certificates \
    curl \
    git \
    imagemagick \
    python3 \
    python3-pip \
    python3-tk \
    sudo \
    tmux \
    vim \
    wget

# Login as a normal user with sudo privilege
RUN groupadd --gid $docker_gid $docker_user \
    && useradd \
       --comment "" \
       --create-home \
       --shell "/bin/bash" \
       --gid $docker_gid \
       --uid $docker_uid \
       $docker_user \
    && echo "$docker_user:12345" | chpasswd \
    && usermod -aG sudo $docker_user

COPY requirements.txt /tmp/

COPY --chown=dev dotfiles $docker_home/

USER $docker_user
WORKDIR $docker_home
