# docker-deeplearning (future branch)

This is a new image that is based on jupyter/tensorflow-notebook (https://hub.docker.com/r/jupyter/tensorflow-notebook/).

In order to use it with GPUs, the host machine needs nvidia-docker2 (https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)).

The container has many options (https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html). For example the container can be started as follows:

`docker run --rm --runtime=nvidia -e NB_UID=$UID -e NB_USER=$USER -p 10000:8888 -e JUPYTER_LAB_ENABLE=yes -v "${HOME}":/home/${USER}/work bethgelab/future`

