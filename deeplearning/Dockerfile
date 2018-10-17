FROM nvidia/cuda:9.2-cudnn7-devel-ubuntu18.04

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
    libpng-dev \
    libzmq3-dev \
    pkg-config \
    python-dev \
    rsync \
    software-properties-common \
    unzip \
    zip \
    python-pip \
    python3-pip \
    python3-venv \
    python-setuptools \
    python3-setuptools \
    cuda-command-line-tools-9-2 \
    zlib1g-dev \
    libjs-mathjax \ 
	libgoogle-perftools-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# fix invalid pointer bug in Tensorboard
# ENV LD_PRELOAD /usr/lib/libtcmalloc_minimal.so.4

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


# install conda
ENV CONDA_DIR /opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH
ENV MINICONDA_VERSION latest
RUN echo ${MINICONDA_VERSION}
RUN cd /tmp && \
  wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
  /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
  rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh
RUN $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
  $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
  $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
  $CONDA_DIR/bin/conda install --quiet --yes python=3.6 conda=`$CONDA_DIR/bin/conda --version | awk '{print $2}'` && \
  $CONDA_DIR/bin/conda update --all --quiet --yes && \
  conda clean -tipsy
# addinga sym link such that pip3 is also linked to the conda env
RUN ln -s $CONDA_DIR/bin/pip $CONDA_DIR/bin/pip3

RUN mkdir /usr/.jupyter
ENV JUPYTER_CONFIG_DIR /usr/.jupyter
COPY jupyter_notebook_config.py /usr/.jupyter/

RUN pip --no-cache-dir install \
    tqdm \
    ipykernel \
    jupyter \
    jupyterlab \
    matplotlib \
    numpy \
    scipy \
    keras-applications \
    keras-preprocessing \
    h5py \
    setuptools \
    theano \
    https://github.com/Lasagne/Lasagne/archive/master.zip \
    scikit-learn \
    pandas \
    tables \
    seaborn \
    click \
    mypy \
    boltons \
    http://download.pytorch.org/whl/cu92/torch-0.4.1-cp36-cp36m-linux_x86_64.whl \
    torchvision \
 && python3 -m ipykernel.kernelspec

# install tensorflow from source
COPY install_bazel.sh /tmp
RUN bash /tmp/install_bazel.sh
COPY install_tensorflow.sh /tmp
RUN bash /tmp/install_tensorflow.sh

# enable jupyter extensions
RUN pip --no-cache-dir install jupyter_contrib_nbextensions \
 && jupyter contrib nbextension install --system \
 && jupyter nbextension enable codefolding/main
# && jupyter nbextension enable hinterland/hinterland \
# && jupyter nbextension enable varInspector/main \
# && jupyter nbextension enable comment-uncomment/main

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
