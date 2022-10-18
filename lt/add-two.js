// Example 1:
// Input: l1 = [2,4,3], l2 = [5,6,4]
// Output: [7,0,8]
// Explanation: 342 + 465 = 807.
// Example 2:

// Input: l1 = [0], l2 = [0]
// Output: [0]
// Example 3:

// Input: l1 = [9,9,9,9,9,9,9], l2 = [9,9,9,9]
// Output: [8,9,9,9,0,0,0,1]

let a = [1,7,9],b=[3,5,1];
const addTwoNumbers = (l1, l2) => {
    let aAll = 0;
    let bAll = 0;
    for(let i=0;i<l1.length;i++){
        aAll = aAll + l1[i] * Math.pow(10,i) 
    }

    for(let j=0;j<l2.length;j++){
        bAll = bAll + l2[j] * Math.pow(10,j) 
    }
    let total = aAll + bAll;
    let myFunc = num => Number(num);
    let intArr = Array.from(String(total), myFunc);
    let ans = intArr.reverse()
    return ans
};

// console.log(Math.pow(2,3));
// console.log(a.reverse());
l1 = [0], l2 = [0]
console.log(addTwoNumbers(l1,l2));
console.log([8, 9, 9, 9,0, 0, 0, 1]);
