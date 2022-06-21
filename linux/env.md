## 環境變數
### export指令
export PATH="$PATH":/home/bin
或
export PATH=${PATH}:/home/bin
輸入之後可以使用export指令來查看環境變數是否有輸入進去。
* 此修改重開機後，就必須再作一次

### profile
profile的路徑是在 "/etc/profile"
直接修改profile這個檔案在裡面加入
export PATH="$PATH":/home/bin
或
export PATH=${PATH}:/home/bin
* 此修改必須在重開機之後，才會有作用

### .bashrc
.bashrc的路徑是在"/home/danny/.bashrc"
在檔案最後面加入
export PATH="$PATH":/home/bin
或
export PATH=${PATH}:/home/bin
source ~/.bashrc
* 此修改只需關掉Terminal在開啟後，就都會被設定

### /etc/enviroment  
這檔案裡面包含原本PATH變數的資料, 要增加請在最後面用:加上你要加入的路徑即可
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin"