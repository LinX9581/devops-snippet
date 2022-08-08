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