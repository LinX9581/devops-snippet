# Git
* 版本回溯

git log #查看所有版本
git status #查看目前檔案修改紀錄
git reset --hard 版本號

* 合併分支
git fetch #更新本地版本
git merge origin/master #合併遠地版本

## Git Clone Private Repo & Push No Password
1. 把公KEY丟到Github
2. 連線測試 
```ssh -T git@github.com```
```ssh -i /var/www/rsa_id -T git@github.com```
3. git remote set-url origin git@github.com:LinX9581/cicd.git
git clone git@github.com:linx9581/cicd.git
git clone git@github.com:linx9581/week-report.git

## Push 到不同帳戶
需要在  控制台\使用者帳戶\認證管理員
更改一般認證
把github A帳戶 帳密改成 B帳戶才能上船
* Github 現在不能輸入密碼 可能要參考上面的方法 把SSH Key 放到不同帳戶上