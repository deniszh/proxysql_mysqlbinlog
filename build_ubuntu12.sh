#!/bin/bash

apt-get install -y python-software-properties
add-apt-repository ppa:ubuntu-toolchain-r/test
add-apt-repository ppa:roblib/ppa
wget https://repo.percona.com/apt/percona-release_0.1-4.precise_all.deb
dpkg -i percona-release_0.1-4.precise_all.deb
apt-get update
apt-get install -y cmake gcc-4.8 g++-4.8 libboost-all-dev libperconaserverclient20=5.7.18-16-1.precise libperconaserverclient20-dev=5.7.18-16-1.precise percona-server-source-5.7=5.7.18-16-1.precise
apt-get -y autoremove && apt-get -y remove libmysqlclient-dev ibmysqlclient18 libmysqlclient18-dev libmysqlclient18.1 libmysqlclient18.1-de
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.8 50

# patching libs
cd /usr/src/percona-server/ && tar -xpzf percona-server-5.7_5.7.18-16.orig.tar.gz && cp -fv /usr/src/percona-server/percona-server-5.7.18-16/include/hash.h /usr/include/mysql/ && \
cd /usr/lib/x86_64-linux-gnu/ && ln -s libperconaserverclient.a libmysqlclient.a && ln -s libperconaserverclient.so libmysqlclient.so && \

# building libslave
cd /opt/proxysql_mysqlbinlog/libslave/ && cmake . && make slave_a && \
# building binlog server
cd ../ && make
mkdir -p /opt/proxysql/bin && \
cp /opt/proxysql_mysqlbinlog/proxysql_binlog_reader /opt/proxysql/bin/proxysql_binlog_reader
