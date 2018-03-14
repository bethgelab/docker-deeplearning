# install bazel
apt-get update
apt-get install -y openjdk-8-jdk
add-apt-repository -y ppa:webupd8team/java
echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
apt-get update && apt-get install -y oracle-java8-installer
echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
curl https://bazel.build/bazel-release.pub.gpg | apt-key add -

apt-get update && apt-get install -y bazel
apt-get upgrade -y bazel
