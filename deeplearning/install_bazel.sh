# install bazel
apt-get update
apt-get install -y openjdk-8-jdk

### workaround to install oracle jdk8 until ppa will be updated
# install java via wget site oficial oracle
# note: JAVA_FILE_TAR, JAVA_URL_DOWNLOAD and JAVA_DIR  must be entered manually
export JAVA_FILE_TAR=jdk-8u191-linux-x64.tar.gz
export JAVA_URL_DOWNLOAD="http://download.oracle.com/otn-pub/java/jdk/8u191-b12/2787e4a523244c269598db4e85c51e0c/${JAVA_FILE_TAR}"
export JAVA_DIR=jdk1.8.0_191
# download and extract tar
cd /opt
wget -q --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" ${JAVA_URL_DOWNLOAD}
tar zxvf ${JAVA_FILE_TAR} && pwd && ls -la
# set default java
update-alternatives --install /usr/bin/java java /opt/${JAVA_DIR}/bin/java 1
update-alternatives --install /usr/bin/javac javac /opt/${JAVA_DIR}/bin/javac 1
update-alternatives --install /usr/bin/jar jar /opt/${JAVA_DIR}/bin/jar 1
# set temp env vars
export JAVA_HOME=/opt/${JAVA_DIR}
export PATH=$PATH:/opt/${JAVA_DIR}/bin:/opt/${JAVA_DIR}/jre/bin
echo "export JAVA_HOME=/opt/${JAVA_DIR}" >> /etc/environment
echo "export PATH=$PATH:/opt/${JAVA_DIR}/bin:/opt/${JAVA_DIR}/jre/bin" >> /etc/environment

# installing jdk8 with the ppa (does not work currently)
#add-apt-repository -y ppa:webupd8team/java
#echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
#apt-get update && apt-get install -y oracle-java8-installer

# install bazel
echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
curl https://bazel.build/bazel-release.pub.gpg | apt-key add -
apt-get update && apt-get install -y bazel
apt-get upgrade -y bazel
