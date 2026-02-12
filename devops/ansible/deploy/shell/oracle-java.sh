#!/bin/bash

# Variables for paths
# JDK 8 用法:  JAVA_VERSION="8u461"
# JDK 21 用法: JAVA_VERSION="21.0.8"
JAVA_VERSION="21.0.8"
SOURCE_DIR="/home/ansible/java"
JAVA_INSTALL_DIR="/usr/java"

# 自動判斷版本格式並組合路徑 (POSIX 兼容)
case "$JAVA_VERSION" in
    8u*)
        # JDK 8 格式: 8u461 -> jdk-8u461-linux-x64.tar.gz / jdk1.8.0_461
        UPDATE_NUM="${JAVA_VERSION#8u}"
        JAVA_TAR="$SOURCE_DIR/jdk-${JAVA_VERSION}-linux-x64.tar.gz"
        JAVA_HOME="$JAVA_INSTALL_DIR/jdk1.8.0_${UPDATE_NUM}"
        JRE_HOME='$JAVA_HOME/jre'
        ;;
    *)
        # JDK 9+ 格式: 21.0.8 -> jdk-21.0.8_linux-x64_bin.tar.gz / jdk-21.0.8
        JAVA_TAR="$SOURCE_DIR/jdk-${JAVA_VERSION}_linux-x64_bin.tar.gz"
        JAVA_HOME="$JAVA_INSTALL_DIR/jdk-${JAVA_VERSION}"
        JRE_HOME='$JAVA_HOME'
        ;;
esac

TOMCAT_TAR="/home/ansible/java/apache-tomcat-9.0.93.tar"
TOMCAT_VERSION="9.0.93"
TOMCAT_HOME="/etc/tomcat/apache-tomcat-$TOMCAT_VERSION"
TOMCAT_BIN="$TOMCAT_HOME/bin"

# Update system and install prerequisites
sudo apt-get update
sudo timedatectl set-timezone Asia/Taipei
sudo apt install wget net-tools -y
sudo chmod -x /etc/update-motd.d/*

# Install Java
sudo mkdir -p /usr/java
sudo tar -zxf "$JAVA_TAR" -C /usr/java
sudo update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 100

# Verify Java installation
sudo update-alternatives --display java
# Automatically select the first option (auto mode) without user interaction
echo "0" | sudo update-alternatives --config java

# Install Tomcat
sudo mkdir -p /etc/tomcat
sudo cp "$TOMCAT_TAR" /etc/tomcat/
sudo tar -xvf /etc/tomcat/apache-tomcat-$TOMCAT_VERSION.tar -C /etc/tomcat
sudo ln -s $TOMCAT_HOME /opt/tomcat
sudo ln -s $TOMCAT_BIN/startup.sh /opt/startup.sh
sudo ln -s $TOMCAT_BIN/shutdown.sh /opt/shutdown.sh

# Move custom configurations
sudo mv /home/ansible/java/server.xml $TOMCAT_HOME/conf/

# 動態生成 setenv.sh（根據 Java 版本自動設定正確路徑）
cat > /tmp/setenv.sh << EOF
JAVA_OPTS="-Xms2560m -Xmx2560m -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/tmp/heapdumps -Duser.timezone=Asia/Taipei"
CATALINA_OPTS="-Duser.timezone=Asia/Taipei"

JAVA_HOME=$JAVA_HOME
JRE_HOME=$JRE_HOME
PATH=\$PATH:\$JAVA_HOME/bin:\$JRE_HOME/bin
EOF
sudo mv /tmp/setenv.sh $TOMCAT_BIN/

# Start Tomcat
sudo sh /opt/startup.sh
