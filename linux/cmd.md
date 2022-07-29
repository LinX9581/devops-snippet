# Linux 指令

## SSH
ssh -i C:\Users\Linx\.ssh\id_rsa linx@34.80.208.4
建立ssk key
ssh-keygen -t rsa
ssh-keygen -R 伺服器端的IP或網址

* 免確認 ssh 會依序執行 a.sh b.sh c.sh (遠端執行腳本預設目錄會在 /home/username)
ssh -o StrictHostKeyChecking=no lin@34.92.123.5 "sudo sh /shell/a.sh && sudo sh /shell/b.sh && sudo sh /shell/c.sh"

## 壓測
```
apt-get install apache2-utils -y
ab -c 20 -n 200 http://127.0.0.1/
ab -c 20 -n 200 http://elk.linx.services/
wrk  -t 10 -c 200 -d 60s -T 30s --latency https://
```
## 簡化指令
```
nano ~/.bashrc
alias k8s='kubectl'
```

## openVPN架設
```
https://ellis-wu.github.io/2017/03/31/openvpn-installation/
```

## 資料夾比對工具
```
WinMerge
diff -bur folder1/ folder2/ //會比對檔案差異和改甚麼
diff -qr folder1/ folder2/ | sort //只比多檔案有多或少或改
```

## 搜尋取代
```
sed -i 's/name:.*/name: Duke/g' settings.conf //將 name:* 改成 name: Duke
sed -i '12i測試' ngx_http_sticky_misc.c //在第12行加入測試
//寫入多行資料 字串內有 $ 前面要加上/
cat>/usr/local/nginx/conf/nginx.conf<<EOF
asdasd
EOF

目錄下所有檔案取代
find ./ -type f -exec sed -i -e 's/game/game1/g' {} \;

找副檔名為go
find . -type f -name "*.go"

讀取檔案底下的資料量
find ./ -type f |wc -l

查詢檔案
sudo find / -name name

grep 'test' d*
顯示所有以d開頭的文件中包含 test的行。
grep 'test' aa bb cc
顯示在aa，bb，cc文件中匹配test的行。
grep '[a-z]\{5\}' aa
顯示所有包含每個字符串至少有5個連續小寫字符的字符串的行。
grep '[9,10,11]' dd     # 二位數
grep '[0-9]' ee         # 只能顯示一位數0-9 不能8-12 只能[8,9,10,11,12]
grep 'w\(es\)t.*\1' aa
如果west被匹配，則es就被存儲到內存中，並標記為1，然後搜索任意個字符(.*)，這些字符後面緊跟著 另外一個es(\1)，找到就顯示該行。如果用egrep或grep -E，就不用”\”號進行轉義，直接寫成’w(es)t.*\1′就可以了

```

## 調整時區、內核、CPU、硬碟
```
調整時區
sudo timedatectl set-timezone Asia/Taipei
sudo dpkg-reconfigure tzdata

系統 內核版本
uname -a

查看 Linux 發行版本
cat /etc/lsb-release

系統型號
cat /etc/os-release

CPU 記憶體
top -bn 1 -i -c
top下 指令c 顯示完整指令


查看占用記憶體程序
ps aux --sort -rss
>/log.txt

記憶體
free -t -m

各個檔案大小
du -d 1 -m -x /run

查詢全盤下容量
du --exclude="proc" | sort -g

查詢個別資料夾
du -csh /var/log

新增一個70G檔案
fallocate -l 70G /tmp/temp.img

看 CPU 資訊
cat /proc/cpuinfo

讓CPU變 100%
md5sum /dev/urandom

CPU 使用率排序
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head

限制CPU使用率
https://blog.gtwang.org/linux/limit-cpu-usage-of-a-process-in-linux-with-cpulimit-tool/

清除安裝套件快取
sudo apt clean

清除系統LOG
truncate -s 0 /var/log/syslog
```
## 環境變數
export指令
export PATH="$PATH":/home/bin
或
export PATH=${PATH}:/home/bin
輸入之後可以使用export指令來查看環境變數是否有輸入進去。

* 此修改重開機後，就必須再作一次
修改profile
profile的路徑是在 "/etc/profile"
直接修改profile這個檔案在裡面加入
export PATH="$PATH":/home/bin
或
export PATH=${PATH}:/home/bin

* 此修改必須在重開機之後，才會有作用
修改.bashrc
.bashrc的路徑是在"/home/danny/.bashrc"
在檔案最後面加入
export PATH="$PATH":/home/bin
或
export PATH=${PATH}:/home/bin
source ~/.bashrc

* 只需關掉Terminal在開啟後，就會被設定
修改 /etc/enviroment  
這檔案裡面包含原本PATH變數的資料, 要增加請在最後面用:加上你要加入的路徑即可
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin"

## 查看 背景執行的Proccess
```
查詢哪些port被占用
netstat -tnlp

查看源站 port
nc -v -w 1 107.167.0.0 80

查看node的詳細
ps -fC node

查詢哪些程式在執行
ps aux | grep node

殺掉特定 Port 的 Proccess
sudo fuser -k 80/tcp

殺掉特定 Proccess ID 
kill -9 12413
```
## 解壓縮
```
壓縮特定檔到特定地方
tar cvf wp-test/test.tar wordpress-init/
壓縮 但排除特定檔案
tar cvf bobee.tar --exclude=linxnote.club/wp-content/uploads --exclude=linxnote.club/wp-content/uploads2 linxnote.club
解壓縮
tar xvf FileName.tar
```
## 排程
```
定期刪除五天以前的檔案
40 1 * * * userxx /usr/bin/rm `date  --date="-5 day"  +\%Y-\%m-\%d`*.gz
日期運算另一種寫法 date -d "-1 day" +"%Y-%m-%d"

使用Nodejs的 cronjob
https://stackoverflow.com/questions/20643470/execute-a-command-line-binary-with-node-js

dump特定格式的sql檔
mysqldump -u developer -p7e9BurMrbt88JuIC dbtest > /var/www/db-backup-crojob/$(date '+%Y.%m.%d'-%H-%M).sql

調整時區
sudo dpkg-reconfigure tzdata
```

## Rsync
[參考](https://blog.gtwang.org/linux/rsync-local-remote-file-synchronization-commands/)
```
# rsync 參數
-v：verbose 模式，輸出比較詳細的訊息。
-r：遞迴（recursive）備份所有子目錄下的目錄與檔案。
-a：封裝備份模式，相當於 -rlptgoD，遞迴備份所有子目錄下的目錄與檔案，保留連結檔、檔案的擁有者、群組、權限以及時間戳記。
-z：啟用壓縮。
-h：將數字以比較容易閱讀的格式輸出。

# 未壓縮 ssh 網內傳輸 
rsync -avh --progress 'ssh -i /root/.ssh/id_rsa' /var/www/lynis-3.0.0.tar.gz drone@10.140.15.213:/var/www
速度為 30~100M
# port 12345
rsync -avzh -e 'ssh -p 12345' /mypath/myfile.gz pi@192.168.1.12:/mybackup/
# 排除特定檔案 移AtoB
rsync -avh --exclude '*.txt' myfolder/ backup/

Key 已放到中繼資料
rsync -avh --progress /var/www logmonit@10.140.0.12:/test
```
## NFS ZFS
[centos參考1](https://www.ichiayi.com/wiki/tech/nfs)
[centos參考2](https://ithelp.ithome.com.tw/articles/10078793)
```
# centos 安裝方式
yum install nfs-utils rpcbind

# ubuntu 安裝方式
sudo apt-get install nfs-kernel-server -y

# 使用方式
ubuntu、centos 可以共用

## nfs-server
先起用這些
systemctl start rpcbind nfs-server 
systemctl enable rpcbind nfs-server

修改該檔案 新增要mount 過去的IP
/etc/exports
(Server共享資料夾) (clientip) (給予的檔案權限)
/data    10.140.0.49(rw,sync,no_root_squash,subtree_check)
/dockerfile    127.0.0.1(rw,sync,no_root_squash,subtree_check)

新增完 exportfs -r 重新加載配置
showmount -e 確認是否新增成功

## nfs-client
安裝方式一樣
mount -t nfs (serverip) (clint要共享的資料夾)
mount -t nfs  10.140.0.53:/data /ubuntunfs
 (-o nolock)可省

## 開機自動執行
chmod +x /etc/rc.local
nano rc.local // 把mount指令寫上去
解除mount
umount -f -l /var/www



## 注意
portmap已經被rpcbind代替了
server 共享資料夾 chmod 755 ， client 似乎隨便?!
chown lin dir   限定特定使用者編輯
多個參數 可用 , 隔開
mount後的資料夾會無法刪除 需要 umount dir
echo "mount -t nfs 172.16.1.100:/data /mnt" >>/etc/rc.local 開機後自動mount

# 參數
ro  只有讀的權限(唯讀read-only)
rw  可讀可寫的權限(read-write)
不過最後是否能讀寫，還是要看檔案和資料的rwx及身份有關係。

sync   所有資料會在請求使用時同步寫入到記憶體和硬碟。
async  資料會先暫存在記憶體中，而不是直接寫入硬碟。

hide     在NFS共享目錄中不共享子目錄
no_hide  在NFS共享目錄中共享子目錄

subtree_check     如果共享/usr/bin之類的子目錄時，強制NFS檢查父目錄權限(預設值)
no_ subtree_check   如果共享/usr/bin之類的子目錄時，強制NFS不檢查父目錄權限

此參數用來讓系統判斷當使用者在使用NFS時的帳號若是root，該如何判別此身份。
no_root_squash   讓使用者能用root身份來執行NFS。並且對根目錄有完全的管理權限
root_squash      使用者的root身份會變成nfsnobody。可增加系統的安全性。(預設值)
all_squash       把所有登入nfs的使用者身份都變為匿名使用者(nobody、nfsbody)

wdelay       如果同時有多個使用者要寫入NFS，可以用群組的方式設定。(預設值)
no_wdelay   如果同時有多個使用者要寫入NFS，立即寫入，當有使用async就不用設置此參數

anon指的是anonymous(匿名者)。在*_squash指的匿名者的UID設定值，通常都是nobody(nfsbody)，而此UID也可自行設定，前題是此UID必須存在/etc/passwd中。anonuid指的是UID而anongid則指的是群組的GID
anonuid=xxxxx  指定NFS伺服器/etc/passwd中匿名用戶的UID
anongid=xxxxx  指定NFS伺服器/etc/passwd中匿名用戶的GID

secure    設定NFS通過1024以下的TCP/IP 端口發送
insecure  設定NFS通過1024以上的TCP/IP端口發送

# zfs (未整理完全)
server
zfs list
zpool list
zfs get sharenfs data/wp-uploads
zfs set sharenfs=rw=client ip
上下指令一樣
showmount -e

client
chmod +x /etc/rc.d/rc.local
mount -t nfs 10.140.0.51:/data/wp-uploads /mnt/uploads
mount -t nfs 10.140.0.51:/data/web-linxnote /var/vhosts/www.linxnote.club
```
## 歷史紀錄 & Log
history
export HISTTIMEFORMAT='%F %T' 新增每行指令的時間
history -c 刪除歷程記錄
more /home/user/.bash_history 查看個別使用者
last 最後登入者


Web console 登入格式
```
Apr 27 19:06:25 wordpress-mysql-error-test systemd[1]: Created slice User Slice of linx9581.
Apr 27 19:06:25 wordpress-mysql-error-test systemd[1]: Starting User Manager for UID 1005...
Apr 27 19:06:25 wordpress-mysql-error-test google-accounts: INFO Adding user linx9581 to the Google sudoers group.
```
一般 FTP Vscode 登入格式
```
Apr 27 19:04:33 wordpress-mysql-error-test systemd[1]: Started Session 97323 of user linx.
```

## local linux 防火牆
sudo apt-get install ufw
sudo ufw status //防火牆
sudo ufw enable
sudo apt-get install gufw
sudo ufw allow in 80


設定真實ip > 前面在wp-config檔案裡的 define 的IP也要同時更改
sudo nano /etc/network/interfaces > 新增四行(如果有dhcp要把dhcp註解掉)
auto eh0
iface eh0 inet static
address X.X.X.X
network X.X.X.X
gateway X.X.X.X
dns-nameservers X.X.X.X

設定完重新啟動:
sudo /etc/init.d/networking restart

## 參考
[別人的筆記整理](https://blog.gtwang.org/category/linux/page/2/)
[shell script 教學](https://blog.twtnn.com/2013/12/shell-script.html)

