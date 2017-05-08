# Build hadoop
FROM sequenceiq/pam:centos-6.5

ENV HADOOP_BUILD_VERSION=hadoop-3.0.0-alpha2
ENV HADOOP_BUILD_TGZ_URL=http://www.apache.org/dist/hadoop/common/hadoop-3.0.0-alpha2/hadoop-3.0.0-alpha2-src.tar.gz
ENV MVN_BIN_PATH=/usr/local/bin/apache-maven-3.5.0/bin

USER root

# install needed packaged
RUN yum install -y java-1.8.0-openjdk-devel curl which tar sudo rsync bunzip2 wget gcc gcc-c++ autoconf automake libtool cmake zlib-devel openssl-devel

# devel tools
RUN yum groupinstall "Development Tools" -y

# update libselinux
RUN yum update -y libselinux

# install maven
ADD install_maven.sh /
RUN /install_maven.sh

# protobuf
RUN curl -L https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz | tar -zxv -C /tmp
RUN cd /tmp/protobuf-2.5.0 && ./configure
RUN cd /tmp/protobuf-2.5.0 && make && make install
ENV LD_LIBRARY_PATH /usr/local/lib
ENV export LD_RUN_PATH /usr/local/lib

# hadoop
RUN curl -s $HADOOP_BUILD_TGZ_URL | tar -xz -C /tmp

# build native libs
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk.x86_64
RUN cd /tmp/${HADOOP_BUILD_VERSION}-src && $MVN_BIN_PATH/mvn package -Pdist,native -DskipTests -Dtar

# install hadoop
RUN tar -xvf /tmp/${HADOOP_BUILD_VERSION}-src/hadoop-dist/target/hadoop-*.tar.gz -C /usr/local
RUN cd /usr/local && ln -s ./${HADOOP_BUILD_VERSION} hadoop
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
