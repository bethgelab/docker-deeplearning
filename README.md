# docker-deeplearning (future branch)

This is a new image that is based on jupyter/tensorflow-notebook (https://hub.docker.com/r/jupyter/tensorflow-notebook/).

In order to use it with GPUs, the host machine needs nvidia-docker2 (https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)).

The container has many options (https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html). 

## start jupyter notebooks

Notebooks can be started as follows:
   ```
   docker run --rm -d \
   --runtime=nvidia \
   -e NB_UID=$UID \
   -e NB_GID=`id -g` \
   -e NB_USER=$USER \
   -e NVIDIA_VISIBLE_DEVICES=0 \
   -e JUPYTER_LAB_ENABLE=yes \
   -p 10000:8888 \
   bethgelab/deeplearning:future
   ```
## run batch scripts

The same setup can be used to run batch scripts (or any other command) using `start.sh` as follows:
```docker run -d --rm \
   --runtime=nvidia \
   -e NB_UID=$UID \
   -e NB_GID=`id -g` \
   -e NB_USER=$USER \
   -e NVIDIA_VISIBLE_DEVICES=0 \
   -w ${HOME} \
   -v /gpfs01/:/gpfs01 \
   bethgelab/deeplearning:future start.sh python3 /gpfs01/bethge/home/aboettcher/scripts/batch.py
   ```
For more details about the `start.sh` script see https://jupyter-docker-stacks.readthedocs.io/en/latest/using/common.html#start-sh.

# Workstation setup
A short recipe how to setup a machine up from scratch to get the container running.

1. Install Ubuntu 18.04.1 LTS

   https://www.ubuntu.com/download/desktop

2. Install nvidia drivers and cuda

   Based on https://askubuntu.com/a/1077063
   
   1. Remove potential previously installed packages
      `sudo apt remove nvidia-*`
   2. Remove potential setup ppa
      ```
      sudo rm /etc/apt/sources.list.d/cuda*
      sudo apt remove nvidia-cuda-toolkit
      sudo apt update
      ```
   3. Add ppa
      ```
      sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
      sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
      sudo apt update
      ````
   4. Install cuda and nvidia drivers
      `sudo apt install cuda-10-0`
   5. Reboot
   6. Check installation
      `nvidia-smi`

3. Install docker
   
   Based on https://docs.docker.com/install/linux/docker-ce/ubuntu/
   
   1. Remove old installs
      `sudo apt-get remove docker docker-engine docker.io`
   2. Install packages to allow apt to use a repository over HTTPS
      ```
      sudo apt-get install \
      apt-transport-https \
      ca-certificates \
      curl \
      software-properties-common
      ```
   3. Add key
      `curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`
      Verify that you now have the key with the fingerprint `9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88`.
   4. Add repository
      ```
      sudo add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) \
      stable"
      sudo apt-get update
      ```
   5. Install docker
      `sudo apt-get install docker-ce`

4. Install nvidia-docker2

   Based on https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-2.0)
   
   1. Removing potentially installed old verions:
      ```
      docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
      sudo apt-get purge nvidia-docker
      ```
   2. Add the nvidia repository
      ```
      curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | \
      sudo apt-key add -
      distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
      curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
      sudo tee /etc/apt/sources.list.d/nvidia-docker.list
      sudo apt-get update
      ```
   3. Install nvidia-docker2
      ```
      sudo apt install nvidia-docker2
      sudo pkill -SIGHUP dockerd
      ```
   4. Check installation
      `docker run --runtime=nvidia --rm nvidia/cuda nvidia-smi`

5. Run our docker container
   ```
   docker run --rm -d \
   --runtime=nvidia \
   -e NB_UID=$UID \
   -e NB_GID=`id -g` \
   -e NB_USER=$USER \
   -e JUPYTER_LAB_ENABLE=yes \
   -p 10000:8888 \
   -v "${HOME}":/home/${USER}/work \
   bethgelab/deeplearning:future
   ```
   
# Bethgelab 
In order to mount our group filesystem (gpfs) and make your home directory available use the following command:
```
docker run --rm \
--runtime=nvidia \
-e NB_UID=$UID \
-e NB_GID=`id -g` \
-e NB_USER=$USER \
-e NVIDIA_VISIBLE_DEVICES=0 \
-e JUPYTER_LAB_ENABLE=yes \
-p 10000:8888 \
-p 22222:22 \
-w ${HOME} \
-v /gpfs01/:/gpfs01 \
bethgelab/deeplearning:future
```
**NOTE: The above command works only in our lab where `/gpfs01` is available on the host machine.**
