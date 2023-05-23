# Git

## 基本操作
1. 上傳到 新建立的repo
```
git init 
git add .
git commit -m "init"
git remote add origin YourRepo
git push -u origin master
```
2. 上傳到不同的 Repo
```
git remote set-url origin new.git.url/here
```

3. 版本回溯
```
git log #查看所有版本
git status #查看目前檔案修改紀錄
git reset --hard 版本號
```
4. 更新本地版本
```
git fetch #更新本地版本
git merge origin/master #合併遠地版本
上面 = git pull
```

6. 修改 commit
[參考](https://gitbook.tw/chapters/rewrite-history/change-commit-message.html)
* 單純修改 commit name
git commit --amend -C HEAD

## Git Clone Private Repo & Push No Password
[參考](https://aben20807.blogspot.com/2018/03/1070302-git-push-ssh-key.html)
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

## 分支合併

查看目前分支
```
git branch
```
新增一個 branch & 進入到該branch ； push 該 branch & 查看所有branch
```
git branch branchname
git checkout branchname
(= git checkout -b iss53)
git push -u origin branchname 
git branch -a #查看遠端
git branch -r #查看本地+遠端
git merge branchname #合併branch
```

拉遠端分支到本地新建的分支 & 只拉遠端分支
```
git checkout origin/branchname -b newbranchname 
git checkout -t origin/branchname
```
刪除遠端的 branch
```
git push origin :branchname 
git push origin --delete branchname
```