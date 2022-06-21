const myArray = [3,2,3,3,5,6,5,5,8,4,4,7,7,7];
const counts = {};

for (const num of myArray) {
    console.log(counts[num]);
  counts[num] = counts[num] ? counts[num] + 1 : 1;
}

console.log(counts);
// console.log(counts[2], counts[3], counts[4], counts[5], counts[6], counts[7], counts[8]);