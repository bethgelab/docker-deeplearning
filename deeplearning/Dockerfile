FROM nvidia/cuda:8.0-cudnn5-devel

MAINTAINER bethgelab (it@bethgelab.org)

USER root

# Set the time zone correctly
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set USER & ID
ENV SHELL /bin/bash
ENV NB_USER wbrendel
ENV NB_UID 5321
ENV HOME /gpfs01/bethge/home/$NB_USER

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

# Create jovyan user with UID=1000 and in the 'users' group
RUN groupadd -g 1019 bethgelab && \
	groupadd -g 1011 cin && \
	useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
	usermod -g bethgelab $NB_USER && \
	usermod -a -G cin $NB_USER && \
	usermod -a -G sudo $NB_USER

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
	  /etc/sudoers


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
COPY run_jupyter.sh /
RUN chmod +x /run_jupyter.sh && \
    chmod -R a+rwx /usr/.jupyter

USER $NB_USER

CMD ["/run_jupyter.sh"]
