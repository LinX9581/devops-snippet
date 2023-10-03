## 調整時區、內核、CPU、硬碟

調整時區
sudo timedatectl set-timezone Asia/Taipei
sudo dpkg-reconfigure tzdata

系統內核版本 , 查看Linux發行版本 , 系統型號
uname -a
cat /etc/lsb-release
cat /etc/os-release

* CPU
CPU 記憶體
top -bn 1 -i -c
top下 指令c 顯示完整指令

看 CPU 資訊
cat /proc/cpuinfo

讓CPU變 100%
md5sum /dev/urandom

CPU 使用率排序
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head

限制CPU使用率
https://blog.gtwang.org/linux/limit-cpu-usage-of-a-process-in-linux-with-cpulimit-tool/

* RAM
查看占用記憶體程序
ps aux --sort -rss >/log.txt

記憶體
free -t -m

* FILE 
各個檔案大小
du -d 1 -m -x /run

查詢全盤下容量
du --exclude="proc" | sort -g

查詢個別資料夾
du -csh /var/log

新增一個70G檔案
fallocate -l 70G /tmp/temp.img



清除安裝套件快取
sudo apt clean

清除系統LOG
truncate -s 0 /var/log/syslog
