#!/bin/bash

export HBASE_CONF_FILE=/opt/hbase/conf/hbase-site.xml
export HADOOP_USER_NAME=root
export HBASE_MANAGES_ZK=false

sed -i "s/@HDFS_PATH@/$HDFS_PATH/g" $HBASE_CONF_FILE
sed -i "s/@ZOOKEEPER_IP_LIST@/$ZOOKEEPER_SERVICE_LIST/g" $HBASE_CONF_FILE
sed -i "s/@ZOOKEEPER_PORT@/$ZOOKEEPER_PORT/g" $HBASE_CONF_FILE
sed -i "s/@ZNODE_PARENT@/$ZNODE_PARENT/g" $HBASE_CONF_FILE

if [ "$HBASE_SERVER_TYPE" = "master" ]; then
    /opt/hbase/bin/hbase master start
elif [ "$HBASE_SERVER_TYPE" = "regionserver" ]; then
    /opt/hbase/bin/hbase regionserver start
fi
