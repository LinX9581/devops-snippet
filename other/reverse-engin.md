apktool 教學
https://blog.csdn.net/u010659278/article/details/45568385

1.先下載 apktool.jar
https://ibotpeaches.github.io/Apktool/ 

2. 載完後 更名為 apktool.jar

3. 新增 apktool.bat 內容為
@echo off
set PATH=%CD%;%PATH%;
java -jar -Duser.language=en "%~dp0\apktool.jar" %1 %2 %3 %4 %5 %6 %7 %8 %9

4. cmd 輸入 apktool -d apk

沒安裝成功的話 把該資料夾加入環境變數





jadx 教學
https://blog.csdn.net/dorytmx/article/details/80841970

1. git clone https://github.com/skylot/jadx.git

2. cmd 到該目錄 輸入 gradlew dist
會生出 build資料夾 點開執行檔 jadx-gui-dev.exe 選擇APK


