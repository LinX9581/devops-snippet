# Github
## 部屬Key
RSA Public Key 放到 Github deploy key
同一把 Private Key 要放在要部屬的VM /home/keyUser/.ssh/
drone 會用該key 去做fetch動作

## Github 免密碼登入
要用上面的keyUser ssh keyUser@VMIP
cd /cicd
git clone git@github.com:linx9581/javatest.git

## 其他指令遇到沒權限通通

# Gitlab
