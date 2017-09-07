FROM ubuntu:16.04

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

#  update repositories
RUN \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y --no-install-recommends openjdk-8-jre-headless ca-certificates-java net-tools curl && \
  rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

ENV HBASE_VERSION 1.2.6
ENV HBASE_INSTALL_DIR /opt/hbase

RUN mkdir -p ${HBASE_INSTALL_DIR} \
    && curl -L https://archive.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz | tar -xz --strip=1 -C ${HBASE_INSTALL_DIR}

ADD conf/hbase-site.xml ${HBASE_INSTALL_DIR}/conf/hbase-site.xml
ADD bin/start-k8s-hbase.sh ${HBASE_INSTALL_DIR}/bin/start-k8s-hbase.sh
RUN chmod +x ${HBASE_INSTALL_DIR}/bin/start-k8s-hbase.sh

WORKDIR ${HBASE_INSTALL_DIR}
RUN echo "export HBASE_JMX_BASE=\"-Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false\"" >> conf/hbase-env.sh && \
    echo "export HBASE_MASTER_OPTS=\"\$HBASE_MASTER_OPTS \$HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10101\"" >> conf/hbase-env.sh && \
    echo "export HBASE_REGIONSERVER_OPTS=\"\$HBASE_REGIONSERVER_OPTS \$HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10102\"" >> conf/hbase-env.sh && \
    echo "export HBASE_THRIFT_OPTS=\"\$HBASE_THRIFT_OPTS \$HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10103\"" >> conf/hbase-env.sh && \
    echo "export HBASE_ZOOKEEPER_OPTS=\"\$HBASE_ZOOKEEPER_OPTS \$HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10104\"" >> conf/hbase-env.sh && \
    echo "export HBASE_REST_OPTS=\"\$HBASE_REST_OPTS \$HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10105\"" >> conf/hbase-env.sh

ENV PATH=$PATH:/opt/hbase/bin

CMD /opt/hbase/bin/start-k8s-hbase.sh
