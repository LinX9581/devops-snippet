# grep的欄位要客製 & awk分析欄位以要客製

# 整體前10名訪問量IP
awk '{print $NF}' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -n 10

awk '{print $0, $NF}' /var/log/nginx/access.log | sort -nk2 | tail -n 1
# 特定時間 前十名訪問量
grep '13:19' /var/log/nginx/access.log | awk '{print $NF}' | sort | uniq -c | sort -nr | head -n 10

# 404訪問的位子 (要去算欄位是第幾個) $8
grep '" 404' /var/log/nginx/access.log | awk '{print $8}' | sort | uniq -c | sort -nr | head -n 30

# 404訪問的前幾名IP
grep '" 404' /var/log/nginx/access.log | awk '{print $NF}' | sort | uniq -c | sort -nr | head -n 30

# 前幾名IP訪問
awk '{print $NF}' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -n 30

# 特定網址 IP訪問量
grep '/js.20211115111100/bootstrap.min.js' /var/log/nginx/access.log | awk '{print $NF}' | sort | uniq -c | sort -nr | head -n 30

# grep 特定網址路徑 並排除特定IP
grep '/js.20211115111100/bootstrap.min.js' /var/log/nginx/access.log | grep -v '218.250.217.244' | grep -v '1.161.207.6'