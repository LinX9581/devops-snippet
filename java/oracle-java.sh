apt update
apt upgrade -y
sudo timedatectl set-timezone Asia/Taipei
apt install git net-tools -y
GCS=nas8451

# java install
cd /usr
mkdir java
cd java
gsutil cp -r gs://${GCS}/jdk-8u221-linux-x64.tar.gz /usr/java
sudo tar -zxf jdk-8u221-linux-x64.tar.gz
sudo update-alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_221/bin/java 100

sudo update-alternatives --display java
sudo update-alternatives --config java

sed -i '1iexport JAVA_HOME=/usr/java/jdk1.8.0_221 \
export JRE_HOME=/usr/java/jdk1.8.0_221/jre \
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib \
export PATH=${PATH}:${JAVA_HOME}/bin:${JRE_HOME}/bin \
' ~/.bashrc
source ~/.bashrc
sudo apt-get update

# tomcat install
cd /etc
mkdir tomcat
cd tomcat
VERSION=8.5.50
gsutil cp -r gs://${GCS}/apache-tomcat-${VERSION}.tar.gz /etc/tomcat/ 
sudo tar -xf apache-tomcat-${VERSION}.tar.gz
cd /opt
VERSION=8.5.50
sudo ln -s /etc/tomcat/apache-tomcat-${VERSION} /opt/tomcat
sudo ln -s /etc/tomcat/apache-tomcat-${VERSION}/bin/startup.sh /opt/
sudo ln -s /etc/tomcat/apache-tomcat-${VERSION}/bin/shutdown.sh /opt/

# tomcat setting
gsutil cp -r gs://${GCS}/server.xml /tmp
cp /tmp/server.xml /opt/tomcat/conf/

sh /opt/shutdown.sh
sh /opt/startup.sh