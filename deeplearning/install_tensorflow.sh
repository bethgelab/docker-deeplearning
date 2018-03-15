apt-get install -y python3-numpy python3-dev python3-pip python3-wheel cuda-command-line-tools-9-1 libcupti-dev
apt-get clean

ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/libcuda.so.1

# clone tensorflow
cd /tmp/
git clone https://github.com/tensorflow/tensorflow.git
cd /tmp/tensorflow
git checkout r1.6

# configurate build
export PYTHON_BIN_PATH=/usr/bin/python3.6
export PYTHON_LIB_PATH=/usr/local/lib/python3.6/dist-packages

export TF_NEED_JEMALLOC=1
export TF_NEED_GCP=1
export TF_NEED_HDFS=1
export TF_NEED_S3=1
export TF_NEED_KAFKA=0
export TF_ENABLE_XLA=0
export TF_NEED_GDR=0
export TF_NEED_VERBS=0
export TF_NEED_OPENCL_SYCL=0
export TF_CUDA_CLANG=0
export TF_NEED_CUDA=1
export TF_CUDA_VERSION=9.1
export CUDA_TOOLKIT_PATH=/usr/local/cuda
export TF_CUDNN_VERSION=7
export CUDNN_INSTALL_PATH=/usr/local/cuda
export TF_NEED_TENSORRT=0
export TF_NEED_MPI=0
export CC_OPT_FLAGS="-march=native"
export TF_SET_ANDROID_WORKSPACE=0
export TF_CUDA_COMPUTE_CAPABILITIES=7.0,6.1,3.7,3.5
export GCC_HOST_COMPILER_PATH=/usr/bin/gcc
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64
export LD_PRELOAD=/usr/lib/libtcmalloc_minimal.so.4
./configure

# build
bazel build --jobs 24 --action_env="LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" --config=opt --config=cuda //tensorflow/tools/pip_package:build_pip_package
bazel-bin/tensorflow/tools/pip_package/build_pip_package ./

# install
pip3 --no-cache-dir install tensorflow-1.6.0-cp36-cp36m-linux_x86_64.whl

# clean up
cd /
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
rm /usr/local/cuda/lib64/libcuda.so.1
