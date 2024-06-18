
apt update
apt install maven

cd /var/www
* 建立初始專案
mvn archetype:generate -DgroupId=com.example -DartifactId=email-sender -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

* 編譯
mvn clean compile

* 執行
mvn exec:java -Dexec.mainClass="com.example.EmailSender"