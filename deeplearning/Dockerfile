FROM nvidia/cuda:9.0-cudnn7-devel

MAINTAINER bethgelab (it@bethgelab.org)

USER root

# Set the time zone correctly
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV SHELL /bin/bash

# Install SSH, sudo and gfortran, etc.
RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get install -yq -qq --no-install-recommends \
    ca-certificates \
    gfortran \
    openssh-server \
    pwgen \
    screen \
    sudo \
    tmux \
    vim \
    wget \
    xterm \
    git \
    zsh \
    build-essential \
    curl \
    libcurl3-dev \
    libfreetype6-dev \
    libpng12-dev \
    libzmq3-dev \
    pkg-config \
    python-dev \
    rsync \
    software-properties-common \
    unzip \
    zip \
    python-pip \
    python3-pip \
    zlib1g-dev \
    libjs-mathjax \ 
	libgoogle-perftools-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# fix invalid pointer bug in Tensorboard
ENV LD_PRELOAD /usr/lib/libtcmalloc_minimal.so.4

# Enable passwordless sudo for all users
RUN echo '%sudo ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers

# Setup gosu (https://github.com/tianon/gosu)
# gosu is an improved version of su which behaves better inside docker
# we use it to dynamically switch to the desired user in the entrypoint
# (see below)
ENV GOSU_VERSION 1.10
# Use unsecure HTTP via Port 80 to fetch key due to firewall in CIN.
RUN set -x \
 && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
 && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true

COPY entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# install python 3.6
RUN add-apt-repository ppa:jonathonf/python-3.6 \
 && apt-get update \
 && apt-get install -y python3.6 python3.6-dev \
 && rm /usr/bin/python3 \
 && ln /usr/bin/python3.6 /usr/bin/python3 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN cd /usr/lib/python3/dist-packages \
 && ln -s apt_pkg.cpython-35m-x86_64-linux-gnu.so apt_pkg.cpython-36m-x86_64-linux-gnu.so \
 && ln -s apt_inst.cpython-35m-x86_64-linux-gnu.so apt_inst.cpython-36m-x86_64-linux-gnu.so

# We have to use `pip` (instead of `pip2`) to upgrade pip, since these two are
# different and only `pip` works. After the upgrade, we can start using `pip2`.
RUN pip install pip --upgrade \
 && pip3 install pip --upgrade \
 && pip2 install setuptools \
 && pip3 install setuptools

RUN mkdir /usr/.jupyter
ENV JUPYTER_CONFIG_DIR /usr/.jupyter
COPY jupyter_notebook_config.py /usr/.jupyter/

RUN pip3 --no-cache-dir install \
    tqdm \
    ipykernel \
    jupyter \
    jupyterlab \
    matplotlib \
    numpy \
    scipy \
    theano \
    https://github.com/Lasagne/Lasagne/archive/master.zip \
    sklearn \
    pandas \
    seaborn \
    click \
    mypy \
    boltons \
    https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.5.0-cp36-cp36m-linux_x86_64.whl \
    http://download.pytorch.org/whl/cu90/torch-0.3.1-cp36-cp36m-linux_x86_64.whl \
    torchvision \
 && python3 -m ipykernel.kernelspec

# enable jupyter extensions
RUN pip install jupyter_contrib_nbextensions \
 && jupyter contrib nbextension install --system \
 && jupyter nbextension enable codefolding/main \
 && jupyter nbextension enable hinterland/hinterland \
 && jupyter nbextension enable varInspector/main \
 && jupyter nbextension enable comment-uncomment/main

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /usr/local/bin
COPY run_jupyterlab.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run_jupyter.sh \
 && chmod -R a+rwx /usr/.jupyter \
 && chmod +x /usr/local/bin/run_jupyterlab.sh

USER $NB_USER

CMD ["/usr/local/bin/run_jupyter.sh"]
