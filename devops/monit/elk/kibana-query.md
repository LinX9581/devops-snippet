查询所有字段中有包含 200 的数据：200
查询 status 字段等于 200 的数据：status:200
查询多个词语请使用双引号：city:"xia men"
大于 400 且小于 500：status:{400 TO 500}
大于等于 400 且小于等于 500：status:[400 TO 500]
大于：age:>10（小于同理）
大于等于：age:>=10（小于等于同理）
不等于：NOT age:10 或 -age:10
匹配单个字符（?）：os:centos?
匹配 0 个或多个字符（*）：os:centos*
多条件查询（逻辑运算符请使用大写）：status:[400 TO 499] AND (extension:php OR extension:html)
查询以下特殊字符需要使用反斜杠转义：+ - && || ! ( ) { } [ ] ^ " ~ * ? : \

nginx.access.response_code : status = [404 TO 504]
nginx.access.response_code < 200 or nginx.access.response_code > 400
nginx.access.response_code : 40*
nginx.access.url.keyword : /news/536*
nginx.access.response_code.keyword >5
nginx.access.referrer : *t.co*
NOT nginx.access.referrer: "*t.co*"

不區分大小寫，也不會保證順序 也會被分詞
message:hello world

不會被分詞 也不會區分大小寫
message:"hello world yes"

or and , and 優先於 or
name:jane or addr:beijing

response:(200 or 404)

包含200 但整條紀錄不包含yes
response:200 and not yes

包含200 不包含yes
response:(200 and not yes)

要過濾包含特殊字元的 需要雙引號包住
nginx.access.url: "%E2%AC%85%EF%B8%8F" and not nginx.access.x_forwarded_for.keyword: 66*

nginx.access.url : "search?q="