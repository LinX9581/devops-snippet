# 增加VM硬碟空間
```
要先裝 cloud-utils
growpart /dev/sda 1 
把剛剛新增的硬碟容量(disk) 擴增到 第一分割區(part)
part = 主要硬碟區

resize2fs /dev/sda1
根據不同的檔案系統 重新調整硬碟空間

centos 
xfs_growfs /dev/sda1

```

## 新增移除分割硬碟 mount
[分割參考](https://blog.gtwang.org/linux/linux-add-format-mount-harddisk/)
```
新增硬碟
gcloud compute disks create mydisk2 --size=10GB --zone asia-east1-c

把硬碟掛上該VM
gcloud compute instances attach-disk gcelab1 --disk mydisk2 --zone asia-east1-c

卸載硬碟
gcloud compute instances detach-disk instance-1 --disk=instance-1

確認硬碟 為 sda sdb or sdc
lsblk

互動式分割工具
fdisk  /dev/sdc
n -> 新增分割區
p -> 主要分割區
1 -> 新增一個分割區
+100G -> 切割成100G 預設是最大
w -> 儲存 離開

刪除磁區
----------------------
p -> 檢視
d -> 刪除
w -> 儲存

檢查分割狀況
lsblk

格式化該分割區為 ext4的格式
mkfs -t ext4 /dev/sdc1

sudo mkdir /mnt/mydisk

查看所有硬碟的名稱
ls -l /dev/disk/by-id/

把該硬碟 掛載到 /mnt/mydisk
sudo mount -o discard,defaults /dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1-part1 /mnt/mydisk

nano /etc/fstab
新增下面這行 讓開機自動 mount
/dev/disk/by-id/scsi-0Google_PersistentDisk_persistent-disk-1-part1 /mnt/mydisk ext4 defaults 1 1

```
### 建立LVM & Mount
apt install -y lvm2
yum install -y lvm2

* 分割後選擇 LVN格式
```
fdisk  /dev/sdc
n -> 新增分割區
p -> 主要分割區
1 -> 新增一個分割區
+100G -> 切割成100G 預設是最大
t -> 8e
w -> 儲存 離開

如果新增的磁碟區未顯示
yum -y install parted
partprobe

建立pv
pvcreate /dev/sdb1
建立vg
vgcreate <vg_name> /dev/sdb1
建立兩個lv
lvcreate -L 20476M -n testlv01 testvg
lvcreate -L 20476M -n testlv02 testvg

查看狀態
vgs pvs lvs
格式化
mkfs.xfs /dev/testvg/testlv01

mkdir /lvmdata

mount
mount /dev/testvg/testlv01 /lvmdata

blkid
查看uuid

增加大小
lvresize -L +1024M /dev/vtest1/lvtest1

增加VG大小
增加前 要再從磁區分割一個LVM磁區
vgextend testvg /dev/sdb2 /dev/sdc1

xfs_growfs /dev/testvg/testlv01
如果已經mount到本地資料夾的話 則改成該目錄

debain 需要裝xfsprogs
sudo apt-get install xfsprogs

vgchange  -ay /dev/vg_tjlinux
```
[LVM參考](https://sc8log.blogspot.com/2017/03/linux-lvm-lvm.html)
## GCE Auto Scaling
1. 確保機器重啟 服務都會重啟
2. 建立快照、映像檔
3. 建立執行個體群組
4. 設定大於多少CPU 自動增減
-> CPC是每台的CPU使用量
5. 設定health check
-> 設邊也是平均健康度

https://ithelp.ithome.com.tw/articles/10200447
https://ithelp.ithome.com.tw/articles/10200319
https://ithelp.ithome.com.tw/articles/10200447

