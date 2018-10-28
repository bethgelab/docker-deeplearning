FROM jupyter/scipy-notebook

USER root

### install NVIDIA libraries and development tools
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
    rm -rf /var/lib/apt/lists/*
ENV CUDA_VERSION 10.0.130
ENV CUDA_PKG_VERSION 10-0=$CUDA_VERSION-1
ENV NCCL_VERSION 2.3.5
ENV CUDNN_VERSION 7.3.1.20
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-cudart-$CUDA_PKG_VERSION \
        cuda-compat-10-0=410.48-1 \
        cuda-libraries-$CUDA_PKG_VERSION \
        cuda-nvtx-$CUDA_PKG_VERSION \
        libnccl2=$NCCL_VERSION-2+cuda10.0 \
        cuda-libraries-dev-$CUDA_PKG_VERSION \
        cuda-nvml-dev-$CUDA_PKG_VERSION \
        cuda-minimal-build-$CUDA_PKG_VERSION \
        cuda-command-line-tools-$CUDA_PKG_VERSION \
        libnccl-dev=$NCCL_VERSION-2+cuda10.0 \
        libcudnn7=$CUDNN_VERSION-1+cuda10.0 \
        libcudnn7-dev=$CUDNN_VERSION-1+cuda10.0 && \
    ln -s cuda-10.0 /usr/local/cuda && \
    apt-mark hold libnccl2 libcudnn7 && \
    rm -rf /var/lib/apt/lists/*
ENV PATH /usr/local/cuda/bin:${PATH}
# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.0 brand=tesla,driver>=384,driver<385"
ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

### install ubuntu packages
RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get install \
    -yq -qq --no-install-recommends \
    openssh-server \
    tmux \
    git \
    apt-utils \
    emacs \
    zsh \
    ispell \
    unzip \
    htop \
    less \
    zip \
    libjs-mathjax \ 
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

### install conda packages
RUN conda install \
    --quiet --yes \
    mypy \
    pytest \
    tqdm \
    xarray \
 && conda clean -tipsy \
 && fix-permissions $CONDA_DIR \
 && fix-permissions /home/$NB_USER

### install pip packages
RUN pip install --no-cache-dir --upgrade pip \
 && pip --no-cache-dir install \
    keras \ 
    https://github.com/evdcush/TensorFlow-wheels/releases/download/tf-1.11.0-gpu-10.0_7.3_5.0-mkl/tensorflow-1.11.0-cp36-cp36m-linux_x86_64.whl \
    sphinx \
    numpy==1.15.3 \
    sphinxcontrib-napoleon \
    sphinx_rtd_theme \
    sphinx_gallery \
 && fix-permissions $CONDA_DIR \
 && fix-permissions /home/$NB_USER

### start sshd
EXPOSE 22
RUN mkdir /var/run/sshd
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
COPY hook.sh /usr/local/bin/before-notebook.d/

### setup environment variables system wide
RUN echo "export PATH="$PATH >> /etc/profile.d/env.sh
RUN echo "export LIBRARY_PATH="$LIBRARY_PATH >> /etc/profile.d/env.sh
RUN echo "export LD_LIBRARY_PATH="$LD_LIBRARY_PATH >> /etc/profile.d/env.sh

### add tmux config
COPY tmux.conf /etc/

### emacs setup
RUN sudo mkdir /usr/share/emacs/site-lisp/elpa
COPY installEmacsPackages.el /usr/share/emacs/site-lisp/
RUN emacs --script /usr/share/emacs/site-lisp/installEmacsPackages.el
COPY default.el /usr/share/emacs/site-lisp/
RUN pip install --no-cache-dir flake8 wheel \
 && pip install --no-cache-dir --upgrade /usr/share/emacs/site-lisp/elpa/jedi-core-*/ \
 && fix-permissions $CONDA_DIR \
 && fix-permissions /home/$NB_USER

USER $UID
