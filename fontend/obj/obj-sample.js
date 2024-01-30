// 計算陣列內 每個值擁有數量 並回傳物件
const myArray = [3, 2, 3, 3, 5, 6, 5, 5, 8, 4, 4, 7, 7, 7];
const counts = {};

for (const num of myArray) {
  counts[num] = counts[num] ? counts[num] + 1 : 1;
}
console.log(counts);
// { '2': 1, '3': 3, '4': 2, '5': 3, '6': 1, '7': 3, '8': 1 }

// 清除物件的第一個屬性
const data = {
  summary: [3901, 7638, 242, 11365, 2603, 46, 1379, 52, 513, 2],
  global: [1113, 2483, 108, 1681, 316, 29, 1013, 19, 92, 2],
  sport: [7577, 9423, 959, 9433, 2598, 58, 358, 39, 1068, 5],
  entertainment: [23767, 35376, 1834, 55917, 61546, 177, 8455, 80, 1709, 51],
};

delete data[Object.keys(data)[0]];
console.log(data);


// 建立24個空陣列 並將screenPageViews的值依照hour的值分配到對應的陣列中
const hourScreenPageViews = Array.from({ length: 24 }, () => []);
  
for (let i = 0; i < hour.length; i++) {
  const index = parseInt(hour[i]);
  hourScreenPageViews[index].push(screenPageViews[i]);
}