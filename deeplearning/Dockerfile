FROM nvidia/cuda:8.0-cudnn5-devel

MAINTAINER bethgelab (it@bethgelab.org)

USER root

# Set the time zone correctly
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV SHELL /bin/bash

# Install SSH, sudo and gfortran, etc.
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
		gfortran \
		openssh-server \
		pwgen \
		screen \
		sudo \
		tmux \
		vim \
		wget \
		xterm \
		&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
	  /etc/sudoers

# Setup gosu (https://github.com/tianon/gosu)
# gosu is an improved version of su which behaves better inside docker
# we use it to dynamically switch to the desired user in the entrypoint
# (see below)
ENV GOSU_VERSION 1.10
# Use unsecure HTTP via Port 80 to fetch key due to firewall in CIN.
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/* \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver "hkp://ha.pool.sks-keyservers.net:80" --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true \
    && apt-get purge -y --auto-remove ca-certificates


COPY entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Use https:// instead of git:// to access github (e.g. for jupyter install)
RUN apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
		git \
		&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Python Packages
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
		curl \
        git \
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
        zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install pip --upgrade && \
    pip3 install pip --upgrade && \
    pip install setuptools && \
    pip3 install setuptools

RUN mkdir /usr/.jupyter
ENV JUPYTER_CONFIG_DIR /usr/.jupyter
COPY jupyter_notebook_config.py /usr/.jupyter/

RUN pip3 --no-cache-dir install \
        ipykernel \
		jupyter \
        matplotlib \
        numpy \
        scipy \
        sklearn \
		tensorflow-gpu \
		&& \
    python3 -m ipykernel.kernelspec

# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run_jupyter.sh && \
    chmod -R a+rwx /usr/.jupyter

USER $NB_USER

CMD ["/usr/local/bin/run_jupyter.sh"]
