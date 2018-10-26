# docker-deeplearning (future branch)

This is a new image that is based on jupyter/tensorflow-notebook (https://hub.docker.com/r/jupyter/tensorflow-notebook/).

In order to use it with GPUs, the host machine needs nvidia-docker2 (https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)).

The container has many options (https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html). For example the container can be started as follows:

`docker run --rm --runtime=nvidia -e NB_UID=$UID -e NB_USER=$USER -p 10000:8888 -e JUPYTER_LAB_ENABLE=yes -v "${HOME}":/home/${USER}/work bethgelab/future`

# Worstation setup
A short receip how to setup a machine up from scratch to get the container running.

1. Install Ubuntu 18.04.1 LTS
https://www.ubuntu.com/download/desktop

2. Install nvidia drivers and cuda
https://askubuntu.com/a/1077063

3. Install docker
https://docs.docker.com/install/linux/docker-ce/ubuntu/

4. Install nvidia-docker2
https://github.com/nvidia/nvidia-docker/wiki/CUDA#requirements

Checks:
docker run -ti --rm --runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=0 nvidia/cuda

5. Run our docker container
docker run --rm --runtime=nvidia -e NB_UID=$UID -e NB_USER=$USER -p 10000:8888 -e JUPYTER_LAB_ENABLE=yes -v "${HOME}":/home/${USER}/work bethgelab/deeplearning:future
