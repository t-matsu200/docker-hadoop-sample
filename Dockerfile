FROM openjdk:8

ENV HADOOP_VERSION 2.10.2
ENV HADOOP_HOME=/hadoop-${HADOOP_VERSION}
ENV HADOOP_OPTS "-Djava.library.path=${HADOOP_HOME}/lib/native"
ENV HADOOP_PREFIX ${HADOOP_HOME}
ENV HADOOP_COMMON_HOME ${HADOOP_HOME}
ENV HADOOP_HDFS_HOME ${HADOOP_HOME}
ENV HADOOP_MAPRED_HOME ${HADOOP_HOME}
ENV HADOOP_YARN_HOME ${HADOOP_HOME}
ENV HADOOP_CONF_DIR ${HADOOP_HOME}/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV SPARK_HOME=/usr/local/lib/spark
ENV PATH=${HADOOP_HOME}/bin:${SPARK_HOME}/bin:$PATH


RUN apt-get update \
  && apt-get install -y --no-install-recommends ssh \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && wget -q -O - http://ftp.yz.yamagata-u.ac.jp/pub/network/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | tar zxf - \
  && wget https://dlcdn.apache.org/spark/spark-3.3.0/spark-3.3.0-bin-hadoop2.tgz \
  && tar zxvf spark-3.3.0-bin-hadoop2.tgz -C /usr/local/lib/ \
  && ln -s /usr/local/lib/spark-3.3.0-bin-hadoop2 /usr/local/lib/spark \
  && rm spark-3.3.0-bin-hadoop2.tgz

USER ${USERNAME}

WORKDIR /hadoop-${HADOOP_VERSION}
COPY config ./etc/hadoop/
COPY start ./
COPY main.py ./

RUN mkdir -p /run/sshd /data \
    && ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa \
    && cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys \
    && chmod 0600 /root/.ssh/authorized_keys \
    && hdfs namenode -format

CMD ["./start"]
