export JAVA_HOME=/usr/local/openjdk-8
export HDFS_NAMENODE_USER=root
export HDFS_DATANODE_USER=root
export HDFS_SECONDARYNAMENODE_USER=root
export HADOOP_SSH_OPTS="-o StrictHostKeyChecking=no -o BatchMode=yes"
export HADOOP_OPTS="${HADOOP_OPTS} -XX:-PrintWarnings -Djava.net.preferIPv4Stack=true -Djava.library.path=${HADOOP_HOME}/lib/native"