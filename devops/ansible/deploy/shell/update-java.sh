#!/bin/bash

# Variables
OLD_JAVA_HOME="/usr/java/jdk1.8.0_451"
NEW_JAVA_HOME="/usr/java/jdk1.8.0_461"
JAVA_TAR="/home/ansible/java/jdk-8u461-linux-x64.tar.gz"

echo "Updating Java from 8u451 to 8u461..."

# Check if tar file exists
[ ! -f "$JAVA_TAR" ] && echo "Error: $JAVA_TAR not found" && exit 1

# Remove old Java and alternatives
sudo rm -rf "$OLD_JAVA_HOME"
sudo update-alternatives --remove java "$OLD_JAVA_HOME/bin/java" 2>/dev/null || true

# Install new Java
sudo mkdir -p /usr/java
sudo tar -zxf "$JAVA_TAR" -C /usr/java
sudo update-alternatives --install /usr/bin/java java $NEW_JAVA_HOME/bin/java 100
echo "0" | sudo update-alternatives --config java

# Update Tomcat setenv.sh
[ -f "/opt/tomcat/bin/setenv.sh" ] && sudo sed -i 's/jdk1\.8\.0_451/jdk1.8.0_461/g' /opt/tomcat/bin/setenv.sh

# Update environment
export JAVA_HOME=$NEW_JAVA_HOME
export PATH=$PATH:$JAVA_HOME/bin

# Verify
java -version
echo "Java update completed."
