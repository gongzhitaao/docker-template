FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04

ARG docker_user=dev
ARG docker_uid=1000
ARG docker_gid=1000

ARG docker_home=/home/$docker_user
ARG DEBIAN_FRONTEND=noninteractive
ARG conda_home=${docker_home}/.local/conda

ENV PATH="${docker_home}/.local/bin:${conda_home}/bin:${PATH}"
ENV CONTAINER_NAME=docker

ENV TINI_VERSION v0.16.1

# The base utilities.
RUN apt-get update --fix-missing && \
    apt-get -y --no-install-recommends install \
    apt-utils \
    build-essential

# The convenient utilities.
RUN apt-get update && \
    apt-get -y --no-install-recommends install \
        bash-completion \
        bzip2 \
        ca-certificates \
        curl \
        ffmpeg \
        git \
        imagemagick \
        sudo \
        tmux \
        vim \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

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

COPY --chown=dev dotfiles $docker_home/
COPY requirements.txt /tmp

ENTRYPOINT [ "/usr/bin/tini", "--" ]

USER $docker_user
WORKDIR $docker_home

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p ${conda_home} && \
    rm /tmp/miniconda.sh && \
    ${conda_home}/bin/conda clean -tipsy && \
    echo ". ${conda_home}/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

CMD [ "/bin/bash" ]
