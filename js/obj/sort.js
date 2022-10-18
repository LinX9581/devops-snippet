let allSource = ['Yahoo奇摩股市', 'Yahoo奇摩股市', '經濟日報', '經濟日報', '經濟日報']
for (const num of allSource) {
    newsCounts[num] = newsCounts[num] ? newsCounts[num] + 1 : 1;
}

// 陣列排序
let originObj = [
    '中時新聞網 Chinatimes.com': 40,
    'Yahoo奇摩股市': 31,
    '中央社即時新聞': 16,
    'Yahoo時尚美妝': 2,
    '工商時報': 18,
    'Yahoo': 11,
    '經濟日報': 16,
    '自由財經': 13,
    'Anue鉅亨': 28,
]

// 排序方式1. 讓陣列有 key value
let newsCountsObj = []
for (let i = 0; i < Object.values(newsCounts).length; i++) {
    newsCountsObj.push({ 'new': Object.keys(newsCounts)[i], 'count': Object.values(newsCounts)[i] })
}
newsCountsObj.sort((a, b) => {
    return a.count - b.count;
});
// 時間排序
// googleRelatedNews.sort((a, b) => {
//     return b.newsTime.localeCompare(a.newsTime);
// });

// 排序方式2. 取的所有value 排序後 再去拿該索引的 Keys+Value
let sortNewsCounts = Object.values(newsCounts)
sortNewsCounts.sort((a, b) => {
    return a - b;
});
sortNewsCounts = sortNewsCounts.reverse()

for (let i = 0; i < 9; i++) {
    Object.keys(newsCounts)[Object.values(newsCounts).indexOf(sortNewsCounts[i])]
    console.log(Object.keys(newsCounts)[Object.values(newsCounts).indexOf(sortNewsCounts[i])] + Object.values(newsCounts)[Object.values(newsCounts).indexOf(sortNewsCounts[i])]);
}