
// 計算陣列內 每個值擁有數量 並回傳陣列
const myArray = [3,2,3,3,5,6,5,5,8,4,4,7,7,7];
const counts = {};

for (const num of myArray) {
    counts[num] = counts[num] ? counts[num] + 1 : 1;
    console.log(counts[num]);
}
console.log(counts);
// { '2': 1, '3': 3, '4': 2, '5': 3, '6': 1, '7': 3, '8': 1 }

