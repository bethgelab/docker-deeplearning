FROM jupyter/scipy-notebook

USER root

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get install \
    -yq -qq --no-install-recommends \
    openssh-server \
    tmux \
    git \
    emacs \
    zsh \
    unzip \
    htop \
    less \
    zip \
    libjs-mathjax \ 
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN conda install \
    --quiet --yes \
    mypy \
    pytest \
    tqdm \
    scikit-image \
    xarray \
 && conda clean -tipsy \
 && fix-permissions $CONDA_DIR \
 && fix-permissions /home/$NB_USER

RUN pip install --no-cache-dir --upgrade pip \
 && pip --no-cache-dir install \
    keras \ 
    tensorflow-gpu \
    sphinx \
    sphinxcontrib-napoleon \
    sphinx_rtd_theme \
    sphinx_gallery

### SSH ###
EXPOSE 22
RUN mkdir /var/run/sshd
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile
COPY hook.sh /usr/local/bin/before-notebook.d/

USER $UID
